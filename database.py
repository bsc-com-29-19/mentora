from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

from config import get_settings

settings = get_settings()


DB_URL = f'postgresql://{settings.DB_USERNAME}:{settings.DB_PASSWORD}@{settings.DB_HOST}/{settings.DB_NAME}'

engine = create_engine(DB_URL,pool_size=20, 
                          max_overflow=10, 
                          connect_args={'timeout': 300})

SessionLocal = sessionmaker(autoflush=False,autocommit = False ,bind=engine)

Base = declarative_base()