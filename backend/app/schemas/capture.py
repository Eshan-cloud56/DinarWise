from datetime import date
from decimal import Decimal
from typing import Literal, get_args

from pydantic import BaseModel, Field, model_validator

# Mirrors GulfCurrency.supported in mobile/lib/core/currency/gulf_currency.dart.
# The ledger is hundredth-based (minorFactor 100) for every currency, so amounts
# are always carried at two decimal places even for KWD/BHD/OMR.
CurrencyCode = Literal["SAR", "AED", "KWD", "BHD", "QAR", "OMR"]

# Mirrors systemCategoryCodes in
# mobile/lib/features/categories/data/drift_category_repository.dart.
CategoryCode = Literal[
    "restaurants",
    "groceries",
    "fuel",
    "transportation",
    "shopping",
    "healthcare",
    "utilities",
    "subscriptions",
    "bnpl",
    "other",
]

# Mirrors defaultPaymentMethodCodes in
# mobile/lib/features/payment_methods/payment_method_repository.dart.
PaymentMethodCode = Literal[
    "cash",
    "debit_card",
    "credit_card",
    "bank_transfer",
    "mada",
    "stc_pay",
    "google_pay",
    "tabby",
    "tamara",
    "other",
]

ReviewLevel = Literal["normal", "uncertain", "manual"]
CaptureEngine = Literal["regex_text", "ollama_vision"]

SUPPORTED_CURRENCIES: tuple[str, ...] = get_args(CurrencyCode)
SUPPORTED_CATEGORIES: tuple[str, ...] = get_args(CategoryCode)
SUPPORTED_PAYMENT_METHODS: tuple[str, ...] = get_args(PaymentMethodCode)


class ReceiptLineItem(BaseModel):
    """A single row read off a receipt. Display-only; never used to compute totals."""

    description: str = Field(max_length=120)
    amount: Decimal | None = Field(default=None, ge=0, decimal_places=2)
    quantity: Decimal | None = Field(default=None, gt=0)


class ExtractedTransaction(BaseModel):
    merchant_name: str | None = None
    amount: Decimal = Field(gt=0, decimal_places=2)
    currency: CurrencyCode
    transaction_date: date
    category: CategoryCode
    payment_method: PaymentMethodCode | None = None
    bnpl_provider: str | None = None
    confidence: Decimal = Field(ge=0, le=1)

    # Receipt-only enrichment. The text capture path leaves these empty.
    tax_amount: Decimal | None = Field(default=None, ge=0, decimal_places=2)
    line_items: list[ReceiptLineItem] = Field(default_factory=list, max_length=50)
    # Field names the client should visually flag for the user to double check.
    low_confidence_fields: list[str] = Field(default_factory=list)

    @property
    def review_level(self) -> ReviewLevel:
        if self.confidence >= Decimal("0.85"):
            return "normal"
        if self.confidence >= Decimal("0.60"):
            return "uncertain"
        return "manual"


class TextCaptureRequest(BaseModel):
    text: str = Field(min_length=2, max_length=1000)
    language: Literal["ar", "en"] | None = None


class CaptureDraft(BaseModel):
    job_id: str
    status: Literal["needs_review"]
    extraction: ExtractedTransaction
    review_level: ReviewLevel
    requires_confirmation: Literal[True] = True

    # Observability for the review UI. Additive, so older clients ignore them.
    engine: CaptureEngine = "regex_text"
    model: str | None = None
    warnings: list[str] = Field(default_factory=list)
    processing_ms: int | None = None

    @model_validator(mode="after")
    def derive_review_level(self) -> "CaptureDraft":
        self.review_level = self.extraction.review_level
        return self


class AiCaptureStatus(BaseModel):
    """Lets the client and the demo page explain setup problems in plain language."""

    enabled: bool
    reachable: bool
    model: str
    model_installed: bool
    installed_models: list[str] = Field(default_factory=list)
    detail: str
