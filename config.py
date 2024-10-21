from pydantic_settings import BaseSettings, SettingsConfigDict
from functools import  lru_cache

import os 

def get_app_env():
    app_env = os.getenv('APP_ENV','dev')

    if(app_env == 'prod'):
        return '.env.prod'
    else:
        return '.env'

class Settings(BaseSettings):
    DB_HOST: str
    DB_NAME: str
    DB_USERNAME: str
    DB_PASSWORD: str
    PGADMIN_EMAIL: str
    PGADMIN_PASSWORD: str
    SECRET_KEY: str
    TOKEN_EXPIRATION_HOURS: int
    OPENAI_API_KEY: str
    DATABASE_URL: str

    model_config = SettingsConfigDict(env_file=get_app_env())
    # class Config:
    #     env_file: str = ".env"
    #     env_prefix = ""


@lru_cache
def get_settings() -> Settings:
    return Settings()