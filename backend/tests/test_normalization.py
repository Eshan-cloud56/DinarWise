from datetime import date
from decimal import Decimal

from app.services.normalization import extract_text_draft, normalize_arabic_digits


def test_normalizes_arabic_digits() -> None:
    assert normalize_arabic_digits("١٢٠٫٥٠") == "120.50"


def test_extracts_arabic_expense_as_unconfirmed_draft() -> None:
    draft = extract_text_draft("دفعت ١٢٠ ريال في كارفور", today=date(2026, 7, 28))
    assert draft.amount == Decimal("120")
    assert draft.currency == "SAR"
    assert draft.merchant_name == "كارفور"
    assert draft.review_level == "uncertain"
