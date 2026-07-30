from fastapi import APIRouter

from app.schemas.budget import SafeToSpendRequest, SafeToSpendResult
from app.services.budgeting import calculate_safe_to_spend

router = APIRouter(prefix="/budgets", tags=["budgets"])


@router.post("/safe-to-spend", response_model=SafeToSpendResult)
async def safe_to_spend(
    request: SafeToSpendRequest,
) -> SafeToSpendResult:
    return calculate_safe_to_spend(request)
