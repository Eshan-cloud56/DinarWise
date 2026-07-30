from datetime import date

from pydantic import BaseModel, Field


class SafeToSpendRequest(BaseModel):
    current_available_minor: int = Field(ge=0)
    upcoming_bills_minor: int = Field(ge=0)
    upcoming_bnpl_minor: int = Field(ge=0)
    planned_savings_minor: int = Field(ge=0)
    emergency_buffer_minor: int = Field(ge=0)
    payday: date
    as_of: date
    currency: str = Field(pattern="^(SAR|AED)$")


class SafeToSpendResult(BaseModel):
    available_minor: int
    daily_minor: int
    remaining_days: int
    currency: str
