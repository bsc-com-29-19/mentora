from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session
from .models import User
from .schema import UserCreate, UserLogin, LoginResponse ,UserResponse
from dependencies import get_db,get_current_user


user_router = APIRouter()

# Todo : extract code to routes and services function

# Register a new user
# todo : separate code to service and route 
@user_router.post("/register")
def signup(user_data: UserCreate, db: Session = Depends(get_db)):
    # Check if username or email already exists
    if db.query(User).filter(User.username == user_data.username).first() or db.query(User).filter(User.email == user_data.email).first():
        raise HTTPException(status_code=400, detail="Username or email already exists")

    #create a new user
    user = User(full_name=user_data.full_name,username=user_data.username, email=user_data.email)
    user.hash_password(user_data.password)

    db.add(user)
    db.commit()
    return {"message": "User has been Created"}


# Login
# todo : separate code to services and routes
@user_router.post("/login")
def login(user_data: UserLogin, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.username == user_data.username).first()

    if user is None or not user.verify_password(user_data.password):
        raise HTTPException(status_code=401, detail="Unknown Username or Password")
    token = user.generate_token()
    return LoginResponse(access_token=token, token_type="Bearer", user_id=str(user.id),username=user.username)


# Get user profile
# todo : separate code to services and routes
@user_router.get("/profile", response_model=UserResponse)
def get_profile(user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    return UserResponse(
        id=str(user.id), 
        full_name=user.full_name,
        username=user.username,
        email=user.email,
        is_active=user.is_active,
        created_at=user.created_at,
        updated_at=user.updated_at
        )

@user_router.post("/logout")
def logout(user: User = Depends(get_current_user)):
    user.hashed_password = None
    return {"message": "User has been logged out"}
