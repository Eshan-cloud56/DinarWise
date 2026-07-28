import uuid
from typing import Annotated

from fastapi import Depends, HTTPException, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.core.security import CurrentUser, get_current_user
from app.models.entities import HouseholdMember, Profile

DbDependency = Annotated[AsyncSession, Depends(get_db)]
UserDependency = Annotated[CurrentUser, Depends(get_current_user)]


async def require_household_member(
    household_id: uuid.UUID,
    user: CurrentUser,
    db: AsyncSession,
) -> Profile:
    try:
        auth_user_id = uuid.UUID(user.id)
    except ValueError as exc:
        raise HTTPException(status_code=401, detail="Invalid user identifier") from exc
    query = (
        select(Profile)
        .join(HouseholdMember, HouseholdMember.profile_id == Profile.id)
        .where(
            Profile.auth_user_id == auth_user_id,
            HouseholdMember.household_id == household_id,
        )
    )
    profile = await db.scalar(query)
    if profile is None:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, detail="No access to this household"
        )
    return profile
