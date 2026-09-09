from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    app_name: str = "DinarWise API"
    environment: str = "development"
    api_prefix: str = "/api/v1"
    database_url: str = "sqlite+aiosqlite:///./dinarwise.db"
    openai_api_key: str = ""
    cors_origins: list[str] = ["http://localhost:3000"]
    max_capture_bytes: int = 10 * 1024 * 1024

    # Local (self-hosted) AI. No data leaves the machine running Ollama.
    ai_capture_enabled: bool = True
    ollama_base_url: str = "http://127.0.0.1:11434"
    ollama_vision_model: str = "qwen2.5vl:7b"
    ollama_timeout_seconds: float = 180.0
    # Longest edge an uploaded receipt is downscaled to before inference.
    # Smaller is faster; below ~1000px small print starts to break down.
    receipt_max_edge_pixels: int = 1400
    # Serves the browser demo page at /demo. Development only.
    enable_demo_page: bool = True

    model_config = SettingsConfigDict(
        env_file=".env", env_prefix="DINARWISE_", case_sensitive=False, extra="ignore"
    )


@lru_cache
def get_settings() -> Settings:
    return Settings()
