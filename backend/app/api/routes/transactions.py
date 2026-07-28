import uuid
from typing import Annotated

from fastapi import APIRouter, Query, status
from sqlalchemy import select

from app.api.dependencies import DbDependency, UserDependency, require_household_member
from app.models.entities import Transaction
from app.schemas.transactions import TransactionCreate, TransactionRead

router = APIRouter(prefix="/transactions", tags=["transactions"])


@router.post("", response_model=TransactionRead, status_code=status.HTTP_201_CREATED)
async def create_transaction(
    payload: TransactionCreate, user: UserDependency, db: DbDependency
) -> Transaction:
    profile = await require_household_member(payload.household_id, user, db)
    transaction = Transaction(
        **payload.model_dump(exclude={"confirmed"}),
        created_by_id=profile.id,
        is_verified=True,
    )
    db.add(transaction)
    await db.commit()
    await db.refresh(transaction)
    return transaction


@router.get("", response_model=list[TransactionRead])
async def list_transactions(
    household_id: Annotated[uuid.UUID, Query()],
    user: UserDependency,
    db: DbDependency,
) -> list[Transaction]:
    await require_household_member(household_id, user, db)
    query = (
        select(Transaction)
        .where(Transaction.household_id == household_id)
        .order_by(Transaction.transacted_at.desc())
        .limit(100)
    )
    return list(await db.scalars(query))
