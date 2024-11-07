from fastapi import Depends, HTTPException
from database import SessionLocal
from app.auth.bearer import JWTBearer
from app.auth.models import User
from config import get_settings
import jwt


settings = get_settings()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def get_current_user(token:str = Depends(JWTBearer())) -> User:
    try:
        payload = jwt.decode(token, f'{settings.SECRET_KEY}', algorithms=['HS256'])
        user_id = payload.get('sub')
        db = SessionLocal()
        user = db.query(User).filter(User.id == user_id).first()

        if not user:
            raise HTTPException(status_code=404, detail="User not found")

        return user, token 
    
    except(jwt.PyJWTError, AttributeError):
        return  HTTPException(status_code="Invalid token")