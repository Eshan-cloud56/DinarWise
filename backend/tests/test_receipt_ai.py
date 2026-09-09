"""Tests for receipt extraction.

Everything here runs against captured model output rather than a live model, so the
suite passes on any machine with no GPU and nothing downloaded.
"""

from datetime import date
from decimal import Decimal

import pytest

from app.schemas.capture import ExtractedTransaction
from app.services.receipt_ai import (
    ReceiptExtractionError,
    build_transaction,
    looks_like_image,
    model_matches,
    parse_amount,
    parse_confidence,
    parse_receipt_date,
    prepare_image,
)

TODAY = date(2026, 9, 2)


def _payload(**overrides: object) -> dict:
    """A realistic bilingual Saudi supermarket receipt as a small VLM would report it."""
    base = {
        "is_receipt": True,
        "legible": True,
        "merchant_name": "Tamimi Markets",
        "merchant_name_arabic": "أسواق التميمي",
        "total_amount": "187.45",
        "tax_amount": "24.45",
        "currency": "SAR",
        "transaction_date": "2026-08-30",
        "category": "groceries",
        "payment_method": "mada",
        "line_items": [
            {"description": "Almarai Milk 2L", "amount": "12.00"},
            {"description": "خبز عربي", "amount": "5.50"},
        ],
        "confidence": "0.92",
    }
    base.update(overrides)
    return base


# ---------------------------------------------------------------------------
# parse_amount
# ---------------------------------------------------------------------------


@pytest.mark.parametrize(
    ("raw", "expected"),
    [
        ("187.45", Decimal("187.45")),
        ("1,234.50", Decimal("1234.50")),  # English thousands separator
        ("1.234,50", Decimal("1234.50")),  # European convention
        ("1234,5", Decimal("1234.50")),  # decimal comma
        ("١٢٠٫٥٠", Decimal("120.50")),  # Arabic-Indic digits and separator
        ("SAR 99.00", Decimal("99.00")),  # stray currency code
        ("﷼ 45", Decimal("45.00")),  # riyal symbol
        ("12.199", Decimal("12.20")),  # quantised to the hundredth-based ledger
        ("12.345", Decimal("12.35")),  # rounds half up, not banker's rounding
    ],
)
def test_parse_amount_handles_gulf_receipt_formats(raw: str, expected: Decimal) -> None:
    assert parse_amount(raw) == expected


@pytest.mark.parametrize("raw", ["unknown", "", None, "n/a", "0", "-5", "abc", "غير معروف"])
def test_parse_amount_rejects_unusable_values(raw: object) -> None:
    assert parse_amount(raw) is None


# ---------------------------------------------------------------------------
# parse_confidence
# ---------------------------------------------------------------------------


@pytest.mark.parametrize(
    ("raw", "expected"),
    [
        ("0.92", Decimal("0.92")),
        ("1", Decimal("1")),
        ("0", Decimal("0")),  # zero is meaningful here, unlike an amount
        ("85", Decimal("0.85")),  # model answered on a 0-100 scale
        ("85%", Decimal("0.85")),
    ],
)
def test_parse_confidence_normalises_scales(raw: str, expected: Decimal) -> None:
    assert parse_confidence(raw) == expected


@pytest.mark.parametrize("raw", ["unknown", "", None, "high", "-0.5", "500"])
def test_parse_confidence_rejects_unusable_values(raw: object) -> None:
    assert parse_confidence(raw) is None


# ---------------------------------------------------------------------------
# parse_receipt_date
# ---------------------------------------------------------------------------


@pytest.mark.parametrize(
    ("raw", "expected"),
    [
        ("2026-08-30", date(2026, 8, 30)),
        ("2026/08/30", date(2026, 8, 30)),
        ("30-08-2026", date(2026, 8, 30)),
        ("30/08/2026", date(2026, 8, 30)),
        ("٣٠-٠٨-٢٠٢٦", date(2026, 8, 30)),
    ],
)
def test_parse_receipt_date_accepts_common_formats(raw: str, expected: date) -> None:
    parsed, warning = parse_receipt_date(raw, TODAY)
    assert parsed == expected
    assert warning is None


def test_parse_receipt_date_rejects_unconverted_hijri_year() -> None:
    # 1448-02-19 is a Hijri date. Accepting it would file the expense in the year 1448.
    parsed, warning = parse_receipt_date("1448-02-19", TODAY)
    assert parsed is None
    assert warning == "hijri_date_not_converted"


def test_parse_receipt_date_rejects_future_and_ancient_dates() -> None:
    assert parse_receipt_date("2027-01-01", TODAY) == (None, "future_date_rejected")
    assert parse_receipt_date("2015-01-01", TODAY) == (None, "implausible_date_rejected")


def test_parse_receipt_date_reports_unparsed_text() -> None:
    assert parse_receipt_date("last Tuesday", TODAY) == (None, "unparsed_date")


# ---------------------------------------------------------------------------
# build_transaction — the happy path
# ---------------------------------------------------------------------------


def test_builds_confident_draft_from_bilingual_receipt() -> None:
    draft, warnings = build_transaction(_payload(), default_currency="SAR", today=TODAY)

    assert isinstance(draft, ExtractedTransaction)
    assert draft.amount == Decimal("187.45")
    assert draft.currency == "SAR"
    assert draft.merchant_name == "Tamimi Markets"
    assert draft.transaction_date == date(2026, 8, 30)
    assert draft.category == "groceries"
    assert draft.payment_method == "mada"
    assert draft.tax_amount == Decimal("24.45")
    assert len(draft.line_items) == 2
    assert draft.low_confidence_fields == []
    assert draft.review_level == "normal"
    assert warnings == []


def test_falls_back_to_arabic_merchant_name_when_latin_is_missing() -> None:
    draft, _ = build_transaction(
        _payload(merchant_name="unknown"), default_currency="SAR", today=TODAY
    )
    assert draft.merchant_name == "أسواق التميمي"
    assert "merchant_name" not in draft.low_confidence_fields


def test_draft_always_requires_review_even_when_confident() -> None:
    # The confirmation step is a design guarantee, not a confidence threshold.
    draft, _ = build_transaction(
        _payload(confidence="1.0"), default_currency="SAR", today=TODAY
    )
    assert draft.confidence <= Decimal("1")
    assert draft.review_level == "normal"


# ---------------------------------------------------------------------------
# build_transaction — degradation
# ---------------------------------------------------------------------------


def test_missing_total_is_a_hard_failure() -> None:
    with pytest.raises(ReceiptExtractionError) as excinfo:
        build_transaction(
            _payload(total_amount="unknown"), default_currency="SAR", today=TODAY
        )
    assert excinfo.value.code == "total_not_found"
    assert "manually" in excinfo.value.user_message


def test_non_receipt_image_is_rejected() -> None:
    with pytest.raises(ReceiptExtractionError) as excinfo:
        build_transaction(_payload(is_receipt=False), default_currency="SAR", today=TODAY)
    assert excinfo.value.code == "not_a_receipt"


def test_unknown_currency_falls_back_to_user_selection_and_flags_it() -> None:
    draft, warnings = build_transaction(
        _payload(currency="unknown"), default_currency="AED", today=TODAY
    )
    assert draft.currency == "AED"
    assert "currency" in draft.low_confidence_fields
    assert "currency_assumed" in warnings


def test_missing_date_falls_back_to_today_and_flags_it() -> None:
    draft, warnings = build_transaction(
        _payload(transaction_date="unknown"), default_currency="SAR", today=TODAY
    )
    assert draft.transaction_date == TODAY
    assert "transaction_date" in draft.low_confidence_fields
    assert warnings == []


def test_illegible_receipt_drops_to_manual_review() -> None:
    draft, _ = build_transaction(
        _payload(legible=False, confidence="0.9"), default_currency="SAR", today=TODAY
    )
    assert draft.review_level == "manual"
    assert "amount" in draft.low_confidence_fields


def test_optimistic_self_reported_confidence_is_capped() -> None:
    # A model claiming certainty on a receipt it also could not date should not reach
    # "normal" review, or the UI would wave a wrong date straight through.
    draft, _ = build_transaction(
        _payload(confidence="1.0", transaction_date="unknown", currency="unknown"),
        default_currency="SAR",
        today=TODAY,
    )
    assert draft.review_level == "uncertain"


def test_vat_at_or_above_total_is_discarded() -> None:
    draft, warnings = build_transaction(
        _payload(tax_amount="500.00"), default_currency="SAR", today=TODAY
    )
    assert draft.tax_amount is None
    assert "tax_exceeded_total_discarded" in warnings


def test_partial_line_items_below_total_are_not_penalised() -> None:
    # Models routinely read only the first few rows of a long receipt. A subset that sums
    # below the total is normal and must not be treated as a misread.
    draft, warnings = build_transaction(_payload(), default_currency="SAR", today=TODAY)
    assert warnings == []
    assert draft.review_level == "normal"


def test_line_items_matching_total_boost_confidence() -> None:
    matched, _ = build_transaction(
        _payload(
            total_amount="17.50",
            tax_amount="unknown",
            confidence="0.80",
        ),
        default_currency="SAR",
        today=TODAY,
    )
    unmatched, _ = build_transaction(
        _payload(total_amount="17.50", tax_amount="unknown", confidence="0.80", line_items=[]),
        default_currency="SAR",
        today=TODAY,
    )
    assert matched.confidence > unmatched.confidence


def test_line_items_exceeding_total_lower_confidence() -> None:
    # A subset of rows cannot exceed the grand total, so this indicates a misread.
    draft, warnings = build_transaction(
        _payload(line_items=[{"description": "Item", "amount": "500.00"}]),
        default_currency="SAR",
        today=TODAY,
    )
    assert "line_items_exceed_total" in warnings
    assert "amount" in draft.low_confidence_fields
    assert draft.confidence < Decimal("0.9")


def test_malformed_line_items_are_skipped_not_fatal() -> None:
    draft, _ = build_transaction(
        _payload(
            line_items=[
                "not a dict",
                {"description": ""},
                {"description": "Valid item", "amount": "bogus"},
            ]
        ),
        default_currency="SAR",
        today=TODAY,
    )
    assert len(draft.line_items) == 1
    assert draft.line_items[0].description == "Valid item"
    assert draft.line_items[0].amount is None


def test_line_items_are_capped() -> None:
    draft, _ = build_transaction(
        _payload(line_items=[{"description": f"Item {i}", "amount": "1.00"} for i in range(80)]),
        default_currency="SAR",
        today=TODAY,
    )
    assert len(draft.line_items) == 50


# ---------------------------------------------------------------------------
# Category recovery
# ---------------------------------------------------------------------------


@pytest.mark.parametrize(
    ("merchant", "expected"),
    [
        ("Al Baik", "restaurants"),
        ("البيك", "restaurants"),
        ("Carrefour Hypermarket", "groceries"),
        ("ADNOC Station", "fuel"),
        ("أدنوك", "fuel"),
        ("Careem", "transportation"),
        ("Nahdi Pharmacy", "healthcare"),
        ("صيدلية النهدي", "healthcare"),
        ("STC", "utilities"),
        ("Jarir Bookstore", "shopping"),
        ("Tabby", "bnpl"),
    ],
)
def test_vague_other_category_is_recovered_from_merchant(merchant: str, expected: str) -> None:
    draft, _ = build_transaction(
        _payload(merchant_name=merchant, merchant_name_arabic="unknown", category="other"),
        default_currency="SAR",
        today=TODAY,
    )
    assert draft.category == expected
    assert "category" not in draft.low_confidence_fields


def test_unrecognised_merchant_keeps_other_and_flags_category() -> None:
    draft, _ = build_transaction(
        _payload(merchant_name="Zzz Trading Co", merchant_name_arabic="unknown", category="other"),
        default_currency="SAR",
        today=TODAY,
    )
    assert draft.category == "other"
    assert "category" in draft.low_confidence_fields


def test_currency_field_does_not_leak_into_the_category_guess() -> None:
    # Regression: the transportation keywords include the Saudi railway, so a shared
    # keyword blob made every "SAR" receipt look like a train ticket.
    draft, _ = build_transaction(
        _payload(
            merchant_name="Zzz Trading Co",
            merchant_name_arabic="unknown",
            category="other",
            currency="SAR",
        ),
        default_currency="SAR",
        today=TODAY,
    )
    assert draft.category == "other"


def test_payment_method_text_does_not_leak_into_the_category_guess() -> None:
    draft, _ = build_transaction(
        _payload(
            merchant_name="Zzz Trading Co",
            merchant_name_arabic="unknown",
            category="other",
            payment_method="tabby",
        ),
        default_currency="SAR",
        today=TODAY,
    )
    assert draft.category == "other"
    assert draft.payment_method == "tabby"


def test_free_text_payment_method_is_recovered() -> None:
    draft, _ = build_transaction(
        _payload(payment_method="Visa Credit Card"), default_currency="SAR", today=TODAY
    )
    assert draft.payment_method == "credit_card"


def test_specific_model_category_is_not_overridden_by_merchant_hint() -> None:
    # Starbucks inside a mall food court billed as shopping should stay as the model read it.
    draft, _ = build_transaction(
        _payload(merchant_name="Starbucks", category="shopping"),
        default_currency="SAR",
        today=TODAY,
    )
    assert draft.category == "shopping"


def test_invalid_category_from_model_degrades_to_other() -> None:
    draft, _ = build_transaction(
        _payload(merchant_name="Zzz Trading Co", merchant_name_arabic="unknown",
                 category="entertainment"),
        default_currency="SAR",
        today=TODAY,
    )
    assert draft.category == "other"


def test_bnpl_provider_is_named() -> None:
    draft, _ = build_transaction(
        _payload(merchant_name="Tamara instalment", category="bnpl"),
        default_currency="SAR",
        today=TODAY,
    )
    assert draft.bnpl_provider == "Tamara"


# ---------------------------------------------------------------------------
# Currencies with three decimal places
# ---------------------------------------------------------------------------


@pytest.mark.parametrize("currency", ["KWD", "BHD", "OMR"])
def test_three_decimal_currencies_quantise_to_the_ledger(currency: str) -> None:
    # The mobile ledger is hundredth-based for every currency (GulfCurrency.minorFactor
    # is always 100), so a 3dp receipt amount has to round to 2dp here or the draft
    # would fail validation on the way out.
    draft, _ = build_transaction(
        _payload(total_amount="12.345", currency=currency, tax_amount="unknown"),
        default_currency="SAR",
        today=TODAY,
    )
    assert draft.currency == currency
    assert draft.amount == Decimal("12.35")


@pytest.mark.parametrize("currency", ["SAR", "AED", "KWD", "BHD", "QAR", "OMR"])
def test_supported_currency_is_not_flagged_as_assumed(currency: str) -> None:
    # Regression: the allowed codes are upper-case but the incoming value was lower-cased
    # before comparison, so every receipt was marked "currency_assumed" and lost
    # confidence even when the model read the currency correctly.
    draft, warnings = build_transaction(
        _payload(currency=currency), default_currency="SAR", today=TODAY
    )
    assert draft.currency == currency
    assert "currency_assumed" not in warnings
    assert "currency" not in draft.low_confidence_fields


def test_lowercase_currency_from_the_model_is_accepted() -> None:
    draft, warnings = build_transaction(
        _payload(currency="sar"), default_currency="AED", today=TODAY
    )
    assert draft.currency == "SAR"
    assert "currency_assumed" not in warnings


def test_unsupported_currency_falls_back_rather_than_failing() -> None:
    draft, warnings = build_transaction(
        _payload(currency="USD"), default_currency="QAR", today=TODAY
    )
    assert draft.currency == "QAR"
    assert "currency_assumed" in warnings


# ---------------------------------------------------------------------------
# Misc helpers
# ---------------------------------------------------------------------------


@pytest.mark.parametrize(
    ("requested", "installed", "expected"),
    [
        ("qwen2.5vl:7b", ["qwen2.5vl:7b"], True),
        ("minicpm-v", ["minicpm-v:latest"], True),  # implicit :latest
        ("qwen2.5vl:7b", ["qwen2.5vl:3b"], False),
        ("qwen2.5vl:7b", [], False),
    ],
)
def test_model_matches_tolerates_implicit_latest_tag(
    requested: str, installed: list[str], expected: bool
) -> None:
    assert model_matches(requested, installed) is expected


@pytest.mark.parametrize(
    ("content_type", "filename", "expected"),
    [
        ("image/jpeg", "receipt.jpg", True),
        ("image/png", "receipt.png", True),
        ("image/heic", "IMG_0421.HEIC", True),
        ("image/jpeg; charset=binary", "r.jpg", True),  # parameterised MIME type
        ("IMAGE/JPEG", "r.jpg", True),
        ("application/octet-stream", "IMG_0421.HEIC", True),  # what browsers do with HEIC
        ("", "IMG_0421.heic", True),
        (None, "receipt.webp", True),
        ("application/octet-stream", "notes.txt", False),
        ("application/pdf", "receipt.pdf", False),
        ("text/plain", "receipt.jpg", False),  # mismatched, so distrust the name
        ("image/gif", "animation.gif", False),  # an image, but not one we read
        (None, None, False),
    ],
)
def test_looks_like_image_accepts_phone_photos(
    content_type: str | None, filename: str | None, expected: bool
) -> None:
    # iPhones shoot HEIC and browsers often send no usable MIME type for it, so the
    # filename has to be accepted as a second opinion or the demo rejects real receipts.
    assert looks_like_image(content_type, filename) is expected


def test_prepare_image_passes_through_unreadable_bytes() -> None:
    # Never let a preprocessing failure block a capture attempt.
    junk = b"this is not an image"
    assert prepare_image(junk, 1400) == junk


def test_prepare_image_downscales_large_photos() -> None:
    pillow = pytest.importorskip("PIL.Image", reason="Pillow is an optional dependency")
    from io import BytesIO

    source = BytesIO()
    pillow.new("RGB", (3000, 4000), (255, 255, 255)).save(source, format="JPEG")

    result = prepare_image(source.getvalue(), 1400)

    with pillow.open(BytesIO(result)) as resized:
        assert max(resized.size) == 1400
        assert resized.size == (1050, 1400)
