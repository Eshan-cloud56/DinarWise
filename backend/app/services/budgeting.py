from app.schemas.budget import SafeToSpendRequest, SafeToSpendResult


def calculate_safe_to_spend(request: SafeToSpendRequest) -> SafeToSpendResult:
    """Calculate spendable funds using integer minor units; AI is never involved."""
    reserved = (
        request.upcoming_bills_minor
        + request.upcoming_bnpl_minor
        + request.planned_savings_minor
        + request.emergency_buffer_minor
    )
    available = max(0, request.current_available_minor - reserved)
    remaining_days = max(1, (request.payday - request.as_of).days + 1)
    return SafeToSpendResult(
        available_minor=available,
        daily_minor=available // remaining_days,
        remaining_days=remaining_days,
        currency=request.currency,
    )
