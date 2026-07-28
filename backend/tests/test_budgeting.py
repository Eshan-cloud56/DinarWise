import uuid
from datetime import date

from app.schemas.budget import SafeToSpendRequest
from app.services.budgeting import calculate_safe_to_spend


def test_safe_to_spend_reserves_commitments_and_splits_remaining_days() -> None:
    result = calculate_safe_to_spend(
        SafeToSpendRequest(
            household_id=uuid.UUID(int=0),
            current_available_minor=200_000,
            upcoming_bills_minor=50_000,
            upcoming_bnpl_minor=20_000,
            planned_savings_minor=25_000,
            emergency_buffer_minor=15_000,
            as_of=date(2026, 7, 28),
            payday=date(2026, 8, 1),
            currency="SAR",
        )
    )
    assert result.available_minor == 90_000
    assert result.remaining_days == 5
    assert result.daily_minor == 18_000


def test_safe_to_spend_never_goes_negative() -> None:
    result = calculate_safe_to_spend(
        SafeToSpendRequest(
            household_id=uuid.UUID(int=0),
            current_available_minor=100,
            upcoming_bills_minor=200,
            upcoming_bnpl_minor=0,
            planned_savings_minor=0,
            emergency_buffer_minor=0,
            as_of=date(2026, 7, 28),
            payday=date(2026, 7, 28),
            currency="SAR",
        )
    )
    assert result.available_minor == 0
    assert result.daily_minor == 0
