import uuid
from datetime import date, datetime
from decimal import Decimal
from enum import StrEnum

from sqlalchemy import (
    JSON,
    BigInteger,
    Boolean,
    Date,
    DateTime,
    Enum,
    ForeignKey,
    Integer,
    Numeric,
    String,
    Text,
    UniqueConstraint,
    Uuid,
    func,
)
from sqlalchemy.orm import Mapped, mapped_column

from app.models.base import Base, Timestamped, UUIDPrimaryKey


class MemberRole(StrEnum):
    owner = "owner"
    admin = "admin"
    member = "member"
    viewer = "viewer"


class TransactionType(StrEnum):
    expense = "expense"
    income = "income"
    refund = "refund"


class CaptureStatus(StrEnum):
    pending = "pending"
    processing = "processing"
    needs_review = "needs_review"
    confirmed = "confirmed"
    failed = "failed"


class User(UUIDPrimaryKey, Timestamped, Base):
    __tablename__ = "users"

    email: Mapped[str] = mapped_column(String(320), unique=True, index=True)
    password_hash: Mapped[str] = mapped_column(String(512))
    full_name: Mapped[str] = mapped_column(String(120))
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    last_login_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))


class LoginEvent(UUIDPrimaryKey, Base):
    __tablename__ = "login_events"

    user_id: Mapped[uuid.UUID | None] = mapped_column(
        ForeignKey("users.id", ondelete="SET NULL"), index=True
    )
    email_attempted: Mapped[str] = mapped_column(String(320))
    succeeded: Mapped[bool] = mapped_column(Boolean)
    ip_address: Mapped[str | None] = mapped_column(String(64))
    user_agent: Mapped[str | None] = mapped_column(String(500))
    occurred_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )


class Profile(UUIDPrimaryKey, Timestamped, Base):
    __tablename__ = "profiles"

    auth_user_id: Mapped[uuid.UUID] = mapped_column(
        Uuid(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        unique=True,
        index=True,
    )
    language: Mapped[str] = mapped_column(String(5), default="en")
    country: Mapped[str] = mapped_column(String(2), default="SA")
    currency: Mapped[str] = mapped_column(String(3), default="SAR")
    prefers_hijri: Mapped[bool] = mapped_column(Boolean, default=False)
    timezone: Mapped[str] = mapped_column(String(64), default="Asia/Riyadh")


class Household(UUIDPrimaryKey, Timestamped, Base):
    __tablename__ = "households"

    name: Mapped[str] = mapped_column(String(120))
    currency: Mapped[str] = mapped_column(String(3), default="SAR")


class HouseholdMember(UUIDPrimaryKey, Timestamped, Base):
    __tablename__ = "household_members"
    __table_args__ = (UniqueConstraint("household_id", "profile_id"),)

    household_id: Mapped[uuid.UUID] = mapped_column(
        ForeignKey("households.id", ondelete="CASCADE"), index=True
    )
    profile_id: Mapped[uuid.UUID] = mapped_column(
        ForeignKey("profiles.id", ondelete="CASCADE"), index=True
    )
    role: Mapped[MemberRole] = mapped_column(Enum(MemberRole), default=MemberRole.member)


class Category(UUIDPrimaryKey, Timestamped, Base):
    __tablename__ = "categories"

    household_id: Mapped[uuid.UUID | None] = mapped_column(
        ForeignKey("households.id", ondelete="CASCADE"), index=True
    )
    code: Mapped[str] = mapped_column(String(50), index=True)
    name_en: Mapped[str] = mapped_column(String(80))
    name_ar: Mapped[str] = mapped_column(String(80))
    is_system: Mapped[bool] = mapped_column(Boolean, default=False)


class Transaction(UUIDPrimaryKey, Timestamped, Base):
    __tablename__ = "transactions"

    household_id: Mapped[uuid.UUID] = mapped_column(
        ForeignKey("households.id", ondelete="CASCADE"), index=True
    )
    created_by_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("profiles.id"))
    category_id: Mapped[uuid.UUID | None] = mapped_column(ForeignKey("categories.id"))
    category_code: Mapped[str] = mapped_column(String(50), default="other")
    type: Mapped[TransactionType] = mapped_column(Enum(TransactionType))
    amount_minor: Mapped[int] = mapped_column(BigInteger)
    currency: Mapped[str] = mapped_column(String(3))
    merchant_name: Mapped[str | None] = mapped_column(String(160))
    description: Mapped[str | None] = mapped_column(Text)
    transacted_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), index=True)
    payment_method: Mapped[str | None] = mapped_column(String(50))
    is_verified: Mapped[bool] = mapped_column(Boolean, default=True)


class Receipt(UUIDPrimaryKey, Timestamped, Base):
    __tablename__ = "receipts"

    household_id: Mapped[uuid.UUID] = mapped_column(
        ForeignKey("households.id", ondelete="CASCADE"), index=True
    )
    transaction_id: Mapped[uuid.UUID | None] = mapped_column(
        ForeignKey("transactions.id", ondelete="SET NULL")
    )
    storage_path: Mapped[str] = mapped_column(String(500), unique=True)
    status: Mapped[CaptureStatus] = mapped_column(
        Enum(CaptureStatus), default=CaptureStatus.pending
    )
    extracted_data: Mapped[dict | None] = mapped_column(JSON)
    confidence: Mapped[Decimal | None] = mapped_column(Numeric(4, 3))


class Budget(UUIDPrimaryKey, Timestamped, Base):
    __tablename__ = "budgets"

    household_id: Mapped[uuid.UUID] = mapped_column(
        ForeignKey("households.id", ondelete="CASCADE"), index=True
    )
    starts_on: Mapped[date] = mapped_column(Date)
    ends_on: Mapped[date] = mapped_column(Date)
    income_minor: Mapped[int] = mapped_column(BigInteger)
    emergency_buffer_minor: Mapped[int] = mapped_column(BigInteger, default=0)
    planned_savings_minor: Mapped[int] = mapped_column(BigInteger, default=0)
    currency: Mapped[str] = mapped_column(String(3))


class RecurringPayment(UUIDPrimaryKey, Timestamped, Base):
    __tablename__ = "recurring_payments"

    household_id: Mapped[uuid.UUID] = mapped_column(
        ForeignKey("households.id", ondelete="CASCADE"), index=True
    )
    name: Mapped[str] = mapped_column(String(120))
    amount_minor: Mapped[int] = mapped_column(BigInteger)
    currency: Mapped[str] = mapped_column(String(3))
    next_payment_date: Mapped[date] = mapped_column(Date, index=True)
    recurrence: Mapped[str] = mapped_column(String(30))
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)


class BnplPlan(UUIDPrimaryKey, Timestamped, Base):
    __tablename__ = "bnpl_plans"

    household_id: Mapped[uuid.UUID] = mapped_column(
        ForeignKey("households.id", ondelete="CASCADE"), index=True
    )
    provider: Mapped[str] = mapped_column(String(60))
    merchant_name: Mapped[str] = mapped_column(String(160))
    purchase_amount_minor: Mapped[int] = mapped_column(BigInteger)
    currency: Mapped[str] = mapped_column(String(3))
    instalment_count: Mapped[int] = mapped_column(Integer)


class BnplInstalment(UUIDPrimaryKey, Timestamped, Base):
    __tablename__ = "bnpl_instalments"

    household_id: Mapped[uuid.UUID] = mapped_column(
        ForeignKey("households.id", ondelete="CASCADE"), index=True
    )
    plan_id: Mapped[uuid.UUID] = mapped_column(
        ForeignKey("bnpl_plans.id", ondelete="CASCADE"), index=True
    )
    amount_minor: Mapped[int] = mapped_column(BigInteger)
    due_date: Mapped[date] = mapped_column(Date, index=True)
    paid_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
