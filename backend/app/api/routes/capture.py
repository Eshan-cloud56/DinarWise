import uuid
from typing import Annotated

from fastapi import APIRouter, File, Form, HTTPException, UploadFile

from app.core.config import get_settings
from app.schemas.capture import (
    SUPPORTED_CURRENCIES,
    AiCaptureStatus,
    CaptureDraft,
    TextCaptureRequest,
)
from app.services.normalization import extract_text_draft
from app.services.receipt_ai import (
    ReceiptExtractionError,
    describe_ai_status,
    extract_receipt_draft,
    looks_like_image,
)

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
        engine="regex_text",
    )


@router.get("/ai-status", response_model=AiCaptureStatus)
async def capture_ai_status() -> AiCaptureStatus:
    """Reports whether the local model is ready, so clients can explain setup problems."""
    return await describe_ai_status()


@router.post("/receipt", response_model=CaptureDraft)
async def capture_receipt(
    file: Annotated[UploadFile, File(description="Photo or scan of a single receipt")],
    default_currency: Annotated[
        str,
        Form(description="The user's currency, used only if the receipt does not state one"),
    ] = "SAR",
) -> CaptureDraft:
    """Reads a receipt image with the locally hosted vision model.

    Returns an unconfirmed draft. Nothing is persisted here: the client shows the draft
    for review and only an explicit user confirmation writes the transaction to the
    device database.
    """
    settings = get_settings()

    if not looks_like_image(file.content_type, file.filename):
        raise HTTPException(
            status_code=415,
            detail="Upload a JPEG, PNG, WebP or HEIC image of the receipt.",
        )
    if default_currency not in SUPPORTED_CURRENCIES:
        raise HTTPException(
            status_code=422,
            detail=f"default_currency must be one of {', '.join(SUPPORTED_CURRENCIES)}.",
        )

    image = await file.read()
    if not image:
        raise HTTPException(status_code=422, detail="The uploaded file is empty.")
    if len(image) > settings.max_capture_bytes:
        limit_mb = settings.max_capture_bytes // (1024 * 1024)
        raise HTTPException(
            status_code=413,
            detail=f"Receipt images must be under {limit_mb} MB.",
        )

    try:
        result = await extract_receipt_draft(image, default_currency=default_currency)
    except ReceiptExtractionError as exc:
        # 422 means "this image did not yield a usable draft"; 503 means "the AI service
        # itself is not available". The client falls back to manual entry either way.
        unavailable = exc.code in {
            "ai_disabled",
            "model_unreachable",
            "model_timeout",
            "model_not_installed",
            "model_failed",
        }
        raise HTTPException(
            status_code=503 if unavailable else 422,
            detail={"code": exc.code, "message": exc.user_message},
        ) from exc

    return CaptureDraft(
        job_id=str(uuid.uuid4()),
        status="needs_review",
        extraction=result.transaction,
        review_level=result.transaction.review_level,
        requires_confirmation=True,
        engine="ollama_vision",
        model=result.model,
        warnings=result.warnings,
        processing_ms=result.processing_ms,
    )
