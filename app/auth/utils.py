import jwt
import time
from config import get_settings
from .models import TokenBlacklist
from sqlalchemy.orm import Session
from datetime import datetime

settings = get_settings()

def decodeJWT(token:str)->dict:
    try:
        decoded_token = jwt.decode(token,f'{settings.SECRET_KEY}',algorithms=['HS256'])
        return decoded_token if decoded_token['exp'] >= time.time() else None
    except jwt.ExpiredSignatureError:
        return None  # Token has expired
    except jwt.InvalidTokenError:
        return None  # Token is invalid
    

def blacklist_token(token: str, db: Session, expires_at: datetime):
    blacklisted_token = TokenBlacklist(token=token, expires_at=expires_at)
    db.add(blacklisted_token)
    db.commit()