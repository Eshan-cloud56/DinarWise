import uuid

from fastapi import APIRouter, HTTPException

from app.schemas.capture import CaptureDraft, TextCaptureRequest
from app.services.normalization import extract_text_draft

router = APIRouter(prefix="/capture", tags=["capture"])


@router.post("/text", response_model=CaptureDraft)
async def capture_text(
    request: TextCaptureRequest,
) -> CaptureDraft:
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
