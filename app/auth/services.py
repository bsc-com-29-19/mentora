from fastapi import  HTTPException
from .models import User

def list_all_users_service(db) -> list[User]:
    users = db.query(User).all()
    return users 