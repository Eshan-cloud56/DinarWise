from fastapi import APIRouter

from app.api.dependencies import DbDependency, UserDependency, require_household_member
from app.schemas.budget import SafeToSpendRequest, SafeToSpendResult
from app.services.budgeting import calculate_safe_to_spend

router = APIRouter(prefix="/budgets", tags=["budgets"])


@router.post("/safe-to-spend", response_model=SafeToSpendResult)
async def safe_to_spend(
    request: SafeToSpendRequest, user: UserDependency, db: DbDependency
) -> SafeToSpendResult:
    await require_household_member(request.household_id, user, db)
    return calculate_safe_to_spend(request)
