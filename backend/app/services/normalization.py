import re
from datetime import date
from decimal import Decimal

from app.schemas.capture import ExtractedTransaction

ARABIC_DIGITS = str.maketrans("٠١٢٣٤٥٦٧٨٩٫٬", "0123456789.,")
AMOUNT_PATTERN = re.compile(
    r"(?P<amount>\d+(?:[.,]\d{1,2})?)\s*(?P<currency>sar|aed|ريال|درهم)",
    re.IGNORECASE,
)


def normalize_arabic_digits(value: str) -> str:
    return value.translate(ARABIC_DIGITS)


def extract_text_draft(text: str, today: date | None = None) -> ExtractedTransaction:
    """Safe local fallback for MVP development. Production capture uses structured AI output."""
    normalized = normalize_arabic_digits(text)
    match = AMOUNT_PATTERN.search(normalized)
    if match is None:
        raise ValueError("Could not identify an amount and supported currency")
    currency_token = match.group("currency").lower()
    currency = "AED" if currency_token in {"aed", "درهم"} else "SAR"
    amount = Decimal(match.group("amount").replace(",", "."))
    lowered = normalized.lower()
    restaurant_terms = ("مطعم", "restaurant", "al baik")
    category = "restaurants" if any(x in lowered for x in restaurant_terms) else "other"
    merchant = None
    at_match = re.search(r"(?:at|في)\s+([\w\u0600-\u06ff ]+)", normalized, re.IGNORECASE)
    if at_match:
        merchant = at_match.group(1).strip(" .")
    return ExtractedTransaction(
        merchant_name=merchant,
        amount=amount,
        currency=currency,
        transaction_date=today or date.today(),
        category=category,
        confidence=Decimal("0.70"),
    )
