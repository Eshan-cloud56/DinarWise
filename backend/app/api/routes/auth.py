from datetime import UTC, datetime
from uuid import UUID, uuid4

from fastapi import APIRouter, HTTPException, Request, status
from sqlalchemy import select
from sqlalchemy.exc import IntegrityError

from app.api.dependencies import DbDependency
from app.core.security import create_access_token, hash_password, verify_password
from app.models.entities import (
    Household,
    HouseholdMember,
    LoginEvent,
    MemberRole,
    Profile,
    User,
)
from app.schemas.auth import AuthResponse, AuthUser, LoginRequest, RegisterRequest

router = APIRouter(prefix="/auth", tags=["auth"])


def _request_metadata(request: Request) -> tuple[str | None, str | None]:
    ip_address = request.client.host if request.client else None
    return ip_address, request.headers.get("user-agent", "")[:500] or None


def _auth_response(user: User, household_id: UUID) -> AuthResponse:
    return AuthResponse(
        access_token=create_access_token(str(user.id), user.email),
        user=AuthUser(
            id=user.id,
            full_name=user.full_name,
            email=user.email,
            household_id=household_id,
        ),
    )


@router.post("/register", response_model=AuthResponse, status_code=status.HTTP_201_CREATED)
async def register(
    payload: RegisterRequest, request: Request, db: DbDependency
) -> AuthResponse:
    email = payload.email.lower().strip()
    user = User(
        id=uuid4(),
        email=email,
        full_name=payload.full_name.strip(),
        password_hash=hash_password(payload.password),
    )
    profile = Profile(
        id=uuid4(),
        auth_user_id=user.id,
        language=payload.language,
        country=payload.country,
        currency="AED" if payload.country == "AE" else "SAR",
        timezone="Asia/Dubai" if payload.country == "AE" else "Asia/Riyadh",
    )
    household = Household(
        id=uuid4(),
        name=f"{payload.full_name.strip()}'s household",
        currency=profile.currency,
    )
    member = HouseholdMember(
        id=uuid4(),
        household_id=household.id,
        profile_id=profile.id,
        role=MemberRole.owner,
    )
    ip_address, user_agent = _request_metadata(request)
    db.add_all([user, profile, household, member])
    try:
        await db.flush()
        db.add(
            LoginEvent(
                user_id=user.id,
                email_attempted=email,
                succeeded=True,
                ip_address=ip_address,
                user_agent=user_agent,
            )
        )
        await db.commit()
    except IntegrityError as exc:
        await db.rollback()
        raise HTTPException(status_code=409, detail="An account already exists") from exc
    return _auth_response(user, household.id)


@router.post("/login", response_model=AuthResponse)
async def login(payload: LoginRequest, request: Request, db: DbDependency) -> AuthResponse:
    email = payload.email.lower().strip()
    user = await db.scalar(select(User).where(User.email == email))
    succeeded = bool(
        user
        and user.is_active
        and verify_password(payload.password, user.password_hash)
    )
    ip_address, user_agent = _request_metadata(request)
    db.add(
        LoginEvent(
            user_id=user.id if user else None,
            email_attempted=email,
            succeeded=succeeded,
            ip_address=ip_address,
            user_agent=user_agent,
        )
    )
    if not succeeded or user is None:
        await db.commit()
        raise HTTPException(status_code=401, detail="Invalid email or password")
    profile = await db.scalar(select(Profile).where(Profile.auth_user_id == user.id))
    if profile is None:
        raise HTTPException(status_code=500, detail="Account profile is missing")
    membership = await db.scalar(
        select(HouseholdMember).where(HouseholdMember.profile_id == profile.id)
    )
    if membership is None:
        raise HTTPException(status_code=500, detail="Account household is missing")
    user.last_login_at = datetime.now(UTC)
    await db.commit()
    return _auth_response(user, membership.household_id)
