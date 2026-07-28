import uuid
from datetime import datetime
from typing import Literal

from pydantic import BaseModel, Field


class TransactionCreate(BaseModel):
    household_id: uuid.UUID
    type: Literal["expense", "income", "refund"] = "expense"
    amount_minor: int = Field(gt=0)
    currency: Literal["SAR", "AED"]
    merchant_name: str | None = Field(default=None, max_length=160)
    description: str | None = Field(default=None, max_length=1000)
    category_id: uuid.UUID | None = None
    category_code: str = Field(default="other", min_length=2, max_length=50)
    transacted_at: datetime
    payment_method: str | None = Field(default=None, max_length=50)
    confirmed: Literal[True]


class TransactionRead(BaseModel):
    id: uuid.UUID
    household_id: uuid.UUID
    type: Literal["expense", "income", "refund"]
    amount_minor: int
    currency: Literal["SAR", "AED"]
    merchant_name: str | None
    description: str | None
    category_id: uuid.UUID | None
    category_code: str
    transacted_at: datetime
    payment_method: str | None
    created_by_id: uuid.UUID
    is_verified: bool

    model_config = {"from_attributes": True}
