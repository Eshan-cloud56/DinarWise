from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    app_name: str = "DinarWise API"
    environment: str = "development"
    api_prefix: str = "/api/v1"
    database_url: str = "sqlite+aiosqlite:///./dinarwise.db"
    jwt_secret: str = "change-this-development-secret-before-production-1234"
    access_token_minutes: int = 60 * 24 * 7
    supabase_url: str = ""
    supabase_jwt_secret: str = ""
    openai_api_key: str = ""
    cors_origins: list[str] = ["http://localhost:3000"]
    max_capture_bytes: int = 10 * 1024 * 1024

    model_config = SettingsConfigDict(
        env_file=".env", env_prefix="DINARWISE_", case_sensitive=False, extra="ignore"
    )


@lru_cache
def get_settings() -> Settings:
    return Settings()
