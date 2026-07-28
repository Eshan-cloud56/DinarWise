from fastapi import APIRouter

from app.api.routes import auth, budgets, capture, health, transactions

api_router = APIRouter()
api_router.include_router(health.router)
api_router.include_router(auth.router)
api_router.include_router(transactions.router)
api_router.include_router(capture.router)
api_router.include_router(budgets.router)
