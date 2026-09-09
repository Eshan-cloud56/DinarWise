"""Reads a receipt image with a locally hosted vision model and returns a review draft.

Nothing in this module talks to a third-party API. The only outbound call is to an
Ollama server, which by default runs on the same machine as this process, so receipt
images never leave infrastructure the operator controls.

The contract with the rest of the app is deliberately narrow: this service produces an
``ExtractedTransaction`` that still has to be confirmed by a human before anything is
written, exactly as described under "AI capture lifecycle" in ARCHITECTURE.md.
"""

from __future__ import annotations

import base64
import json
import logging
import re
import time
from dataclasses import dataclass, field
from datetime import date, datetime
from decimal import ROUND_HALF_UP, Decimal, InvalidOperation
from io import BytesIO
from typing import Any

import httpx

from app.core.config import Settings, get_settings
from app.schemas.capture import (
    SUPPORTED_CATEGORIES,
    SUPPORTED_CURRENCIES,
    SUPPORTED_PAYMENT_METHODS,
    AiCaptureStatus,
    ExtractedTransaction,
    ReceiptLineItem,
)
from app.services.normalization import normalize_arabic_digits

logger = logging.getLogger(__name__)

ACCEPTED_IMAGE_TYPES = frozenset(
    {"image/jpeg", "image/jpg", "image/png", "image/webp", "image/heic", "image/heif"}
)

# Browsers do not reliably report a MIME type for HEIC, which is what iPhones produce by
# default, so the filename is accepted as a second opinion.
ACCEPTED_IMAGE_EXTENSIONS = (".jpg", ".jpeg", ".png", ".webp", ".heic", ".heif")

UNKNOWN = "unknown"


class ReceiptExtractionError(RuntimeError):
    """Raised when a receipt cannot be turned into a draft.

    ``code`` is stable and machine-readable; ``user_message`` is safe to show a user and
    is intentionally free of technical detail.
    """

    def __init__(self, code: str, user_message: str) -> None:
        super().__init__(f"{code}: {user_message}")
        self.code = code
        self.user_message = user_message


# --------------------------------------------------------------------------------------
# Prompting
# --------------------------------------------------------------------------------------

SYSTEM_PROMPT = """You read retail receipts from Saudi Arabia and the wider Gulf.
Receipts are often bilingual Arabic and English, and the Arabic is usually the merchant's
legal name while the English is a transliteration. Read both.

Rules you must follow:
- Report the FINAL amount actually paid: the grand total after VAT and after any discount.
  Never report a subtotal, a single line item, an amount tendered, or change given.
- Saudi and UAE receipts show 15% and 5% VAT respectively. If you can see a VAT line,
  report it separately in tax_amount. Do not add VAT to the total yourself.
- Dates may be Gregorian or Hijri, and may be written day-first. Always output Gregorian
  in strict YYYY-MM-DD form. If a Hijri date is the only one shown, convert it.
- If a value is genuinely not visible on the receipt, use the string "unknown" rather
  than guessing. Guessing is worse than admitting uncertainty here.
- Read digits exactly. Arabic-Indic digits (٠١٢٣٤٥٦٧٨٩) must be converted to 0-9.
- Amounts must be plain decimal numbers with a dot, no thousands separators, no currency
  symbol. Write one thousand two hundred and fifty as 1250.00
"""

USER_PROMPT = """Extract this receipt into the required JSON object.

Choose category from exactly these values, based on what was actually bought:
- restaurants: restaurants, cafes, coffee shops, food delivery
- groceries: supermarkets, grocers, butchers, bakeries
- fuel: petrol stations, car charging
- transportation: taxi, ride hailing, flights, parking, tolls, car service
- shopping: clothing, electronics, homeware, general retail
- healthcare: pharmacies, clinics, hospitals, opticians, labs
- utilities: electricity, water, internet, mobile top-up, government fees
- subscriptions: recurring digital services and memberships
- bnpl: buy-now-pay-later instalment payments
- other: anything that does not clearly fit above

Set is_receipt to false if this image is not a receipt or invoice at all.
Set legible to false if the image is too blurry, dark or cropped to read the total
reliably. Be honest about this; a false "true" here is the most damaging mistake.
Set confidence to your own honest estimate between 0 and 1 that the total you reported
is exactly correct.
"""


def _response_schema() -> dict[str, Any]:
    """JSON schema handed to Ollama so the model is constrained to valid output.

    Amounts are strings rather than numbers on purpose: it keeps the model from emitting
    float artefacts like 12.199999 and lets us parse straight into Decimal.
    """
    amount = {"type": "string", "description": "Decimal number or 'unknown'"}
    return {
        "type": "object",
        "properties": {
            "is_receipt": {"type": "boolean"},
            "legible": {"type": "boolean"},
            "merchant_name": {"type": "string"},
            "merchant_name_arabic": {"type": "string"},
            "total_amount": amount,
            "tax_amount": amount,
            "currency": {
                "type": "string",
                "enum": [*SUPPORTED_CURRENCIES, UNKNOWN],
            },
            "transaction_date": {
                "type": "string",
                "description": "Gregorian YYYY-MM-DD, or 'unknown'",
            },
            "category": {"type": "string", "enum": [*SUPPORTED_CATEGORIES]},
            "payment_method": {
                "type": "string",
                "enum": [*SUPPORTED_PAYMENT_METHODS, UNKNOWN],
            },
            "line_items": {
                "type": "array",
                "items": {
                    "type": "object",
                    "properties": {
                        "description": {"type": "string"},
                        "amount": amount,
                    },
                    "required": ["description"],
                },
            },
            "confidence": {"type": "string"},
        },
        "required": [
            "is_receipt",
            "legible",
            "total_amount",
            "currency",
            "category",
            "confidence",
        ],
    }


# --------------------------------------------------------------------------------------
# Merchant knowledge
# --------------------------------------------------------------------------------------

# Gulf chains a small vision model routinely recognises visually but miscategorises.
# Used only to correct a vague "other", never to override a confident specific answer.
MERCHANT_CATEGORY_HINTS: tuple[tuple[tuple[str, ...], str], ...] = (
    (("al baik", "albaik", "البيك", "kudu", "كودو", "herfy", "هرفي", "starbucks",
      "ستاربكس", "dunkin", "tim hortons", "barns", "بارنز", "mcdonald", "ماكدونالدز",
      "kfc", "دجاج", "subway", "pizza", "بيتزا", "cafe", "كافيه", "مطعم", "مقهى",
      "talabat", "طلبات", "hungerstation", "هنقرستيشن", "jahez", "جاهز", "deliveroo",
      "careem food"), "restaurants"),
    (("panda", "بنده", "tamimi", "التميمي", "carrefour", "كارفور", "lulu", "لولو",
      "danube", "الدانوب", "othaim", "العثيم", "spinneys", "سبينس", "union coop",
      "نستو", "nesto", "بقالة", "hypermarket", "supermarket", "سوبرماركت", "farm superstores",
      "المزرعة"), "groceries"),
    (("aramco", "أرامكو", "adnoc", "أدنوك", "petromin", "بترومين", "sasco", "ساسكو",
      "enoc", "eppco", "محطة وقود", "petrol", "بنزين", "fuel"), "fuel"),
    (("uber", "أوبر", "careem", "كريم", "bolt", "parking", "مواقف", "salik", "darb",
      "saudia", "السعودية للطيران", "flynas", "طيران ناس", "emirates", "طيران الإمارات",
      "sar railway", "الخطوط الحديدية", "haramain", "الحرمين", "taxi", "تاكسي"),
     "transportation"),
    (("nahdi", "النهدي", "al dawaa", "الدواء", "aldawaa", "pharmacy", "صيدلية",
      "hospital", "مستشفى", "clinic", "عيادة", "مختبر", "laboratory", "magrabi",
      "مغربي", "dr sulaiman", "السليمان الحبيب"), "healthcare"),
    (("stc", "إس تي سي", "mobily", "موبايلي", "zain", "زين", "etisalat", "اتصالات",
      "du ", "sec", "الكهرباء", "electricity", "المياه", "water authority", "dewa",
      "sewa", "absher", "أبشر"), "utilities"),
    (("netflix", "نتفلكس", "spotify", "shahid", "شاهد", "starzplay", "osn",
      "youtube premium", "icloud", "google one", "microsoft 365", "adobe",
      "subscription", "اشتراك"), "subscriptions"),
    (("tabby", "تابي", "tamara", "تمارا", "mispay", "spotii", "postpay",
      "instalment", "installment", "قسط", "أقساط"), "bnpl"),
    (("jarir", "جرير", "extra", "إكسترا", "saco", "ساكو", "ikea", "ايكيا", "أيكيا",
      "noon", "نون", "amazon", "أمازون", "namshi", "نمشي", "centrepoint", "h&m",
      "zara", "زارا", "الدرة", "مول", "mall"), "shopping"),
)

BNPL_PROVIDERS: tuple[tuple[tuple[str, ...], str], ...] = (
    (("tabby", "تابي"), "Tabby"),
    (("tamara", "تمارا"), "Tamara"),
    (("mispay", "ميس باي"), "MISPAY"),
    (("spotii",), "Spotii"),
    (("postpay",), "Postpay"),
)

CURRENCY_TOKENS: tuple[tuple[tuple[str, ...], str], ...] = (
    (("sar", "s.r", "sr ", "ر.س", "ريال سعودي", "﷼"), "SAR"),
    (("aed", "d.h", "dhs", "د.إ", "درهم إماراتي", "درهم"), "AED"),
    (("kwd", "د.ك", "دينار كويتي"), "KWD"),
    (("bhd", "د.ب", "دينار بحريني"), "BHD"),
    (("qar", "ر.ق", "ريال قطري"), "QAR"),
    (("omr", "ر.ع", "ريال عماني", "ريال عُماني"), "OMR"),
)

PAYMENT_TOKENS: tuple[tuple[tuple[str, ...], str], ...] = (
    (("mada", "مدى"), "mada"),
    (("stc pay", "stcpay", "اس تي سي باي"), "stc_pay"),
    (("google pay", "gpay"), "google_pay"),
    (("apple pay",), "credit_card"),
    (("visa", "mastercard", "amex", "american express", "credit"), "credit_card"),
    (("debit", "خصم مباشر"), "debit_card"),
    (("cash", "نقدا", "نقداً", "نقدي", "كاش"), "cash"),
    (("transfer", "حوالة", "تحويل"), "bank_transfer"),
    (("tabby", "تابي"), "tabby"),
    (("tamara", "تمارا"), "tamara"),
)


# --------------------------------------------------------------------------------------
# Parsing helpers
# --------------------------------------------------------------------------------------

_AMOUNT_CLEAN = re.compile(r"[^\d.,\-]")
_TWO_PLACES = Decimal("0.01")


def _is_unknown(value: Any) -> bool:
    if value is None:
        return True
    text = str(value).strip().lower()
    return text in {"", UNKNOWN, "null", "none", "n/a", "na", "-", "غير معروف"}


def parse_amount(value: Any) -> Decimal | None:
    """Parse a model-reported amount into a 2dp Decimal, or None if unusable.

    Handles Arabic-Indic digits, thousands separators in either convention, and stray
    currency symbols. Returns None rather than raising so callers can degrade.
    """
    if _is_unknown(value):
        return None
    text = _AMOUNT_CLEAN.sub("", normalize_arabic_digits(str(value)).strip())
    if not text:
        return None

    has_comma, has_dot = "," in text, "." in text
    if has_comma and has_dot:
        # Whichever separator appears last is the decimal point.
        if text.rfind(",") > text.rfind("."):
            text = text.replace(".", "").replace(",", ".")
        else:
            text = text.replace(",", "")
    elif has_comma:
        # A single comma with 1-2 trailing digits is a decimal comma, else a separator.
        text = text.replace(",", "." if len(text.split(",")[-1]) <= 2 else "")

    try:
        amount = Decimal(text)
    except InvalidOperation:
        return None
    if not amount.is_finite() or amount <= 0:
        return None
    # ROUND_HALF_UP, not Python's default banker's rounding: 12.345 must become 12.35,
    # which is what a customer reading the receipt would expect.
    return amount.quantize(_TWO_PLACES, rounding=ROUND_HALF_UP)


def parse_confidence(value: Any) -> Decimal | None:
    """Parse a self-reported confidence in [0, 1]. Unlike an amount, zero is meaningful."""
    if _is_unknown(value):
        return None
    text = normalize_arabic_digits(str(value)).strip().rstrip("%")
    try:
        score = Decimal(text)
    except InvalidOperation:
        return None
    if not score.is_finite() or score < 0:
        return None
    # Some models answer "85" when asked for a 0-1 value.
    if score > 1:
        score /= 100
    return score if score <= 1 else None


def parse_receipt_date(value: Any, today: date) -> tuple[date | None, str | None]:
    """Parse a date string into a Gregorian date, plus an optional warning code."""
    if _is_unknown(value):
        return None, None
    text = normalize_arabic_digits(str(value)).strip()

    # A Hijri year the model failed to convert. Rejecting is safer than a 600-year error.
    year_match = re.match(r"^(\d{4})", text)
    if year_match and 1300 <= int(year_match.group(1)) <= 1500:
        return None, "hijri_date_not_converted"

    for pattern in ("%Y-%m-%d", "%Y/%m/%d", "%d-%m-%Y", "%d/%m/%Y", "%d.%m.%Y"):
        try:
            parsed = datetime.strptime(text[:10], pattern).date()
        except ValueError:
            continue
        if parsed > today:
            return None, "future_date_rejected"
        if parsed.year < today.year - 5:
            return None, "implausible_date_rejected"
        return parsed, None
    return None, "unparsed_date"


def _searchable(payload: dict[str, Any], *keys: str) -> str:
    """Lowercased text from the given fields, with "unknown" placeholders dropped."""
    parts = [
        str(payload.get(key, "")).strip().lower()
        for key in keys
        if not _is_unknown(payload.get(key))
    ]
    return " ".join(part for part in parts if part)


def _match_token(haystack: str, table: tuple[tuple[tuple[str, ...], str], ...]) -> str | None:
    for tokens, result in table:
        if any(token in haystack for token in tokens):
            return result
    return None


def _coerce_choice(value: Any, allowed: tuple[str, ...]) -> str | None:
    """Match a model-reported value to an allowed code, returning the canonical spelling.

    The comparison has to be case-insensitive in both directions: currency codes are
    upper-case ("SAR") while categories and payment methods are lower-case ("groceries"),
    and models are inconsistent about which they echo back.
    """
    if _is_unknown(value):
        return None
    candidate = str(value).strip().lower().replace(" ", "_").replace("-", "_")
    for option in allowed:
        if option.lower() == candidate:
            return option
    return None


# --------------------------------------------------------------------------------------
# Image preparation
# --------------------------------------------------------------------------------------


def looks_like_image(content_type: str | None, filename: str | None) -> bool:
    """Whether an upload is plausibly a receipt photo.

    The MIME type is checked first, with the extension as a fallback: browsers often send
    ``application/octet-stream`` or nothing at all for HEIC, which is the default format
    on an iPhone and therefore the most likely thing a user tries first.
    """
    media_type = (content_type or "").split(";")[0].strip().lower()
    if media_type in ACCEPTED_IMAGE_TYPES:
        return True
    if media_type and not media_type.startswith(("image/", "application/octet-stream")):
        return False
    return (filename or "").strip().lower().endswith(ACCEPTED_IMAGE_EXTENSIONS)


def prepare_image(data: bytes, max_edge: int) -> bytes:
    """Downscale and flatten a receipt photo to keep inference fast.

    Pillow is optional: without it the original bytes are passed through, which still
    works but is slower on phone-sized photos.
    """
    try:
        from PIL import Image, ImageOps
    except ImportError:
        logger.info("Pillow not installed; sending receipt image without downscaling")
        return data

    try:
        with Image.open(BytesIO(data)) as image:
            image = ImageOps.exif_transpose(image)
            if image.mode not in {"RGB", "L"}:
                image = image.convert("RGB")
            if max(image.size) > max_edge:
                ratio = max_edge / max(image.size)
                new_size = (max(1, round(image.width * ratio)), max(1, round(image.height * ratio)))
                image = image.resize(new_size, Image.LANCZOS)
            buffer = BytesIO()
            image.save(buffer, format="JPEG", quality=88, optimize=True)
            return buffer.getvalue()
    except Exception:
        logger.warning("Could not pre-process receipt image; using original", exc_info=True)
        return data


# --------------------------------------------------------------------------------------
# Ollama transport
# --------------------------------------------------------------------------------------


class OllamaVisionClient:
    """Minimal async client for the two Ollama endpoints this feature needs."""

    def __init__(self, base_url: str, timeout: float) -> None:
        self._base_url = base_url.rstrip("/")
        self._timeout = timeout

    async def installed_models(self) -> list[str]:
        async with httpx.AsyncClient(timeout=10.0) as client:
            response = await client.get(f"{self._base_url}/api/tags")
            response.raise_for_status()
        payload = response.json()
        return sorted(str(item.get("name", "")) for item in payload.get("models", []))

    async def describe_image(self, model: str, image: bytes, schema: dict[str, Any]) -> str:
        body = {
            "model": model,
            "stream": False,
            "format": schema,
            "options": {
                # Deterministic: the same receipt should always produce the same draft.
                "temperature": 0,
                "top_p": 0.1,
                "num_predict": 1536,
            },
            "messages": [
                {"role": "system", "content": SYSTEM_PROMPT},
                {
                    "role": "user",
                    "content": USER_PROMPT,
                    "images": [base64.b64encode(image).decode("ascii")],
                },
            ],
        }
        async with httpx.AsyncClient(timeout=self._timeout) as client:
            response = await client.post(f"{self._base_url}/api/chat", json=body)
            response.raise_for_status()
        return str(response.json().get("message", {}).get("content", ""))


def model_matches(requested: str, installed: list[str]) -> bool:
    """True if the requested model is present, tolerating an implicit :latest tag."""
    if requested in installed:
        return True
    wanted = requested if ":" in requested else f"{requested}:latest"
    return wanted in installed


# --------------------------------------------------------------------------------------
# Extraction
# --------------------------------------------------------------------------------------


@dataclass
class ReceiptExtraction:
    transaction: ExtractedTransaction
    warnings: list[str] = field(default_factory=list)
    processing_ms: int = 0
    model: str = ""


def build_transaction(
    payload: dict[str, Any],
    *,
    default_currency: str,
    today: date,
) -> tuple[ExtractedTransaction, list[str]]:
    """Turn raw model output into a validated draft, degrading confidence as we go.

    Separated from the network call so it can be tested against captured model output
    without a model installed.
    """
    warnings: list[str] = []
    low_confidence: list[str] = []

    if payload.get("is_receipt") is False:
        raise ReceiptExtractionError(
            "not_a_receipt",
            "That image does not look like a receipt. Try a clearer photo of the receipt.",
        )

    amount = parse_amount(payload.get("total_amount"))
    if amount is None:
        raise ReceiptExtractionError(
            "total_not_found",
            "The total on this receipt could not be read. Enter the amount manually, "
            "or retake the photo with the total clearly visible.",
        )

    merchant = None
    for key in ("merchant_name", "merchant_name_arabic"):
        candidate = payload.get(key)
        if not _is_unknown(candidate):
            merchant = str(candidate).strip()[:80]
            break
    if merchant is None:
        low_confidence.append("merchant_name")

    # Keyword lookups are scoped to the field they belong to. Mixing them into one blob
    # causes false matches: "SAR" in the currency field would otherwise hit the Saudi
    # railway keyword and file every riyal receipt as transportation.
    merchant_text = _searchable(payload, "merchant_name", "merchant_name_arabic")
    currency_text = _searchable(payload, "currency")
    payment_text = _searchable(payload, "payment_method")

    currency = _coerce_choice(payload.get("currency"), SUPPORTED_CURRENCIES)
    if currency is None:
        currency = _match_token(currency_text, CURRENCY_TOKENS) or default_currency
        warnings.append("currency_assumed")
        low_confidence.append("currency")

    transaction_date, date_warning = parse_receipt_date(payload.get("transaction_date"), today)
    if date_warning:
        warnings.append(date_warning)
    if transaction_date is None:
        transaction_date = today
        low_confidence.append("transaction_date")

    category = _coerce_choice(payload.get("category"), SUPPORTED_CATEGORIES) or "other"
    if category == "other":
        # The model gave up on category; merchant name often still tells us.
        hinted = _match_token(merchant_text, MERCHANT_CATEGORY_HINTS)
        if hinted:
            category = hinted
        else:
            low_confidence.append("category")

    payment_method = _coerce_choice(payload.get("payment_method"), SUPPORTED_PAYMENT_METHODS)
    if payment_method is None:
        payment_method = _match_token(payment_text, PAYMENT_TOKENS)

    bnpl_provider = _match_token(f"{merchant_text} {payment_text}", BNPL_PROVIDERS)

    tax_amount = parse_amount(payload.get("tax_amount"))
    if tax_amount is not None and tax_amount >= amount:
        # A "tax" at or above the total means the model mixed up the lines.
        warnings.append("tax_exceeded_total_discarded")
        tax_amount = None

    line_items: list[ReceiptLineItem] = []
    for raw_item in payload.get("line_items") or []:
        if not isinstance(raw_item, dict):
            continue
        description = str(raw_item.get("description", "")).strip()
        if not description:
            continue
        line_items.append(
            ReceiptLineItem(
                description=description[:120],
                amount=parse_amount(raw_item.get("amount")),
            )
        )
        if len(line_items) == 50:
            break

    confidence = _score(
        payload=payload,
        amount=amount,
        line_items=line_items,
        low_confidence=low_confidence,
        warnings=warnings,
    )

    transaction = ExtractedTransaction(
        merchant_name=merchant,
        amount=amount,
        currency=currency,  # type: ignore[arg-type]
        transaction_date=transaction_date,
        category=category,  # type: ignore[arg-type]
        payment_method=payment_method,  # type: ignore[arg-type]
        bnpl_provider=bnpl_provider,
        confidence=confidence,
        tax_amount=tax_amount,
        line_items=line_items,
        low_confidence_fields=sorted(set(low_confidence)),
    )
    return transaction, warnings


def _score(
    *,
    payload: dict[str, Any],
    amount: Decimal,
    line_items: list[ReceiptLineItem],
    low_confidence: list[str],
    warnings: list[str],
) -> Decimal:
    """Blend the model's self-report with our own checks.

    Self-reported confidence from small vision models is optimistic, so it is capped and
    then reduced by every concrete problem we detected. The result drives review_level,
    which decides how loudly the UI asks the user to check the draft.
    """
    self_reported = parse_confidence(payload.get("confidence"))
    if self_reported is None:
        self_reported = Decimal("0.5")
    score = min(Decimal("0.9"), self_reported)

    if payload.get("legible") is False:
        score -= Decimal("0.35")
        low_confidence.append("amount")

    # Independent cross-check against the line items. Models routinely report only the
    # first few rows of a long receipt, so a sum *below* the total proves nothing and is
    # treated as neutral. A sum meaningfully *above* the total cannot happen on a real
    # receipt, so it means something was misread.
    summed = sum((item.amount for item in line_items if item.amount is not None), Decimal("0"))
    if summed > 0:
        if abs(summed - amount) <= amount * Decimal("0.02"):
            score += Decimal("0.08")
        elif summed > amount * Decimal("1.05"):
            score -= Decimal("0.15")
            low_confidence.append("amount")
            warnings.append("line_items_exceed_total")

    score -= Decimal("0.08") * len(set(low_confidence))
    return max(Decimal("0"), min(Decimal("1"), score)).quantize(
        _TWO_PLACES, rounding=ROUND_HALF_UP
    )


async def extract_receipt_draft(
    image: bytes,
    *,
    default_currency: str = "SAR",
    today: date | None = None,
    settings: Settings | None = None,
) -> ReceiptExtraction:
    """Read a receipt image and return an unconfirmed draft transaction."""
    settings = settings or get_settings()
    if not settings.ai_capture_enabled:
        raise ReceiptExtractionError(
            "ai_disabled", "Receipt scanning is turned off. Add this expense manually."
        )

    client = OllamaVisionClient(settings.ollama_base_url, settings.ollama_timeout_seconds)
    prepared = prepare_image(image, settings.receipt_max_edge_pixels)
    started = time.perf_counter()

    try:
        raw = await client.describe_image(
            settings.ollama_vision_model, prepared, _response_schema()
        )
    except httpx.ConnectError as exc:
        raise ReceiptExtractionError(
            "model_unreachable",
            "The local AI service is not running. Start Ollama and try again.",
        ) from exc
    except httpx.TimeoutException as exc:
        raise ReceiptExtractionError(
            "model_timeout",
            "Reading the receipt took too long. A smaller model or a faster machine "
            "will help.",
        ) from exc
    except httpx.HTTPStatusError as exc:
        detail = "model_not_installed" if exc.response.status_code == 404 else "model_failed"
        message = (
            f"The model '{settings.ollama_vision_model}' is not installed. "
            "Run scripts/setup_ai_demo.sh to install it."
            if detail == "model_not_installed"
            else "The local AI service returned an error. Check the Ollama logs."
        )
        raise ReceiptExtractionError(detail, message) from exc

    elapsed_ms = int((time.perf_counter() - started) * 1000)

    try:
        payload = json.loads(raw)
    except json.JSONDecodeError as exc:
        logger.warning("Model returned non-JSON output: %.200s", raw)
        raise ReceiptExtractionError(
            "model_output_invalid",
            "The AI could not read this receipt properly. Please add it manually.",
        ) from exc
    if not isinstance(payload, dict):
        raise ReceiptExtractionError(
            "model_output_invalid",
            "The AI could not read this receipt properly. Please add it manually.",
        )

    transaction, warnings = build_transaction(
        payload, default_currency=default_currency, today=today or date.today()
    )
    return ReceiptExtraction(
        transaction=transaction,
        warnings=warnings,
        processing_ms=elapsed_ms,
        model=settings.ollama_vision_model,
    )


async def describe_ai_status(settings: Settings | None = None) -> AiCaptureStatus:
    """Report setup state so the UI can explain what is missing instead of just failing."""
    settings = settings or get_settings()
    model = settings.ollama_vision_model
    if not settings.ai_capture_enabled:
        return AiCaptureStatus(
            enabled=False,
            reachable=False,
            model=model,
            model_installed=False,
            detail="Receipt scanning is disabled by configuration.",
        )

    client = OllamaVisionClient(settings.ollama_base_url, settings.ollama_timeout_seconds)
    try:
        installed = await client.installed_models()
    except (httpx.HTTPError, ValueError):
        return AiCaptureStatus(
            enabled=True,
            reachable=False,
            model=model,
            model_installed=False,
            detail=(
                f"Cannot reach the local AI service at {settings.ollama_base_url}. "
                "Start it with: ollama serve"
            ),
        )

    if not model_matches(model, installed):
        return AiCaptureStatus(
            enabled=True,
            reachable=True,
            model=model,
            model_installed=False,
            installed_models=installed,
            detail=f"Connected, but '{model}' is not installed yet. Run: ollama pull {model}",
        )
    return AiCaptureStatus(
        enabled=True,
        reachable=True,
        model=model,
        model_installed=True,
        installed_models=installed,
        detail="Ready to read receipts.",
    )
