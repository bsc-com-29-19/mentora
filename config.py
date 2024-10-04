from pydantic_settings import BaseSettings
from functools import  lru_cache

class Settings(BaseSettings):
    DB_NAME: str
    DB_USERNAME: str
    DB_PASSWORD: str
    PGADMIN_EMAIL: str
    PGADMIN_PASSWORD: str
    SECRET_KEY: str
    TOKEN_EXPIRATION_HOURS: int
    class Config:
        env_file: str = ".env"
        env_prefix = ""


@lru_cache
def get_settings() -> Settings:
    return Settings()