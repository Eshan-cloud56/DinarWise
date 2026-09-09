from collections.abc import AsyncIterator
from contextlib import asynccontextmanager
from pathlib import Path

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse, HTMLResponse

from app.api.router import api_router
from app.core.config import get_settings
from app.core.database import engine
from app.models import Base

DEMO_PAGE = Path(__file__).resolve().parent.parent / "demo" / "receipt_demo.html"


@asynccontextmanager
async def lifespan(_: FastAPI) -> AsyncIterator[None]:
    if get_settings().environment == "development":
        async with engine.begin() as connection:
            await connection.run_sync(Base.metadata.create_all)
    yield


settings = get_settings()
app = FastAPI(
    title=settings.app_name,
    version="0.1.0",
    docs_url="/docs" if settings.environment != "production" else None,
    lifespan=lifespan,
)
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_origin_regex=(
        r"^https?://(localhost|127\.0\.0\.1)(:\d+)?$"
        if settings.environment == "development"
        else None
    ),
    allow_credentials=True,
    allow_methods=["GET", "POST", "PATCH", "DELETE"],
    allow_headers=["Content-Type"],
)
app.include_router(api_router, prefix=settings.api_prefix)


if settings.enable_demo_page and settings.environment != "production":

    @app.get("/demo", include_in_schema=False)
    async def receipt_demo() -> FileResponse | HTMLResponse:
        """Local-only page for trying receipt scanning without running the Flutter app."""
        if not DEMO_PAGE.is_file():
            return HTMLResponse(
                "<h1>Demo page missing</h1><p>Expected backend/demo/receipt_demo.html</p>",
                status_code=404,
            )
        return FileResponse(DEMO_PAGE, media_type="text/html")
