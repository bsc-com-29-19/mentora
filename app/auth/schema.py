from pydantic import BaseModel, EmailStr
from datetime import datetime


class UserCreate(BaseModel):
    full_name: str
    username: str
    email: EmailStr
    password: str
    is_active: bool = True


class UserLogin(BaseModel):
    username: str
    password: str


class LoginResponse(BaseModel):
    user_id: str
    username: str
    access_token: str
    token_type: str




class UserResponse(BaseModel):
    id: str
    full_name:str
    username: str
    email: EmailStr
    is_active: bool
    created_at: datetime
    updated_at: datetime

