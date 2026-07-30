from fastapi import APIRouter

from app.api.routes import budgets, capture, health

api_router = APIRouter()
api_router.include_router(health.router)
api_router.include_router(capture.router)
api_router.include_router(budgets.router)
