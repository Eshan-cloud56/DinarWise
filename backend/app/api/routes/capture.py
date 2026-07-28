import uuid

from fastapi import APIRouter, HTTPException

from app.api.dependencies import DbDependency, UserDependency, require_household_member
from app.schemas.capture import CaptureDraft, TextCaptureRequest
from app.services.normalization import extract_text_draft

router = APIRouter(prefix="/capture", tags=["capture"])


@router.post("/text", response_model=CaptureDraft)
async def capture_text(
    request: TextCaptureRequest, user: UserDependency, db: DbDependency
) -> CaptureDraft:
    await require_household_member(request.household_id, user, db)
    try:
        extraction = extract_text_draft(request.text)
    except ValueError as exc:
        raise HTTPException(status_code=422, detail=str(exc)) from exc
    return CaptureDraft(
        job_id=str(uuid.uuid4()),
        status="needs_review",
        extraction=extraction,
        review_level=extraction.review_level,
        requires_confirmation=True,
    )
