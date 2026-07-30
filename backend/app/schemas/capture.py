from datetime import date
from decimal import Decimal
from typing import Literal

from pydantic import BaseModel, Field, model_validator


class ExtractedTransaction(BaseModel):
    merchant_name: str | None = None
    amount: Decimal = Field(gt=0, decimal_places=2)
    currency: Literal["SAR", "AED"]
    transaction_date: date
    category: str
    payment_method: str | None = None
    bnpl_provider: str | None = None
    confidence: Decimal = Field(ge=0, le=1)

    @property
    def review_level(self) -> Literal["normal", "uncertain", "manual"]:
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
    review_level: Literal["normal", "uncertain", "manual"]
    requires_confirmation: Literal[True] = True

    @model_validator(mode="after")
    def derive_review_level(self) -> "CaptureDraft":
        self.review_level = self.extraction.review_level
        return self
