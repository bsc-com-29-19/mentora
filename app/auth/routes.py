import random
from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session

from app.activities.models import Activity, ActivityStatus
from app.activities.services import create_activity_service
from .models import User
from .schema import UserCreate, UserLogin, LoginResponse ,UserResponse
from dependencies import get_db,get_current_user
from .utils import blacklist_token
import jwt
from config import get_settings
from datetime import datetime, timedelta


user_router = APIRouter()

settings = get_settings()

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
    db.refresh(user)


    # Generate six activities for the new user
    suggested_activities = [
        {"title": "Go for a walk", "description": "A 30-minute walk in nature can improve mood and reduce anxiety."},
        {"title": "Meditate", "description": "Spend 15 minutes focusing on your breath to relax your mind."},
        {"title": "Read a book", "description": "Reading can be a great escape and help reduce stress."},
        {"title": "Gym exercise", "description": "Physical activity boosts serotonin and can help alleviate depression."},
        {"title": "Connect with a friend", "description": "Socializing and spending time with friends improves emotional well-being."},
        {"title": "Journal", "description": "Writing about your feelings can help process emotions and clear your mind."},
        {"title": "Listen to music", "description": "Listening to uplifting music can improve mood and reduce stress."},
        {"title": "Deep breathing", "description": "Practicing deep breathing can reduce tension and improve focus."},
        {"title": "Cook a meal", "description": "Preparing healthy meals can increase feelings of accomplishment and improve health."},
        {"title": "Yoga", "description": "Yoga can enhance physical and mental flexibility while promoting relaxation."},
        {"title": "Spend time with pets", "description": "Interacting with animals can reduce stress and enhance emotional well-being."},
        {"title": "Take a nap", "description": "A short nap can recharge energy and improve mental clarity."}
    ]

    # Select six random activities
    random_activities = random.sample(suggested_activities, 6)

    # Create activities for the new user
    for activity_info in random_activities:
        create_activity_service(
            activity_data=Activity(
                title=activity_info["title"], 
                description=activity_info["description"], 
                status=ActivityStatus.NOT_DONE
            ),
            db=db,
            user=user
        )

    return {"message": "User has been Created"}


# Login
# todo : separate code to services and routes
@user_router.post("/login")
def login(user_data: UserLogin, db: Session = Depends(get_db)):
    user = db.query(User).filter((User.username == user_data.usernameoremail) | (User.email == user_data.usernameoremail)).first()

    if user is None or not user.verify_password(user_data.password):
        raise HTTPException(status_code=401, detail="Unknown Username/Email or Password")
    token = user.generate_token()
    return LoginResponse(access_token=token, token_type="Bearer", user_id=str(user.id),username=user.username, full_name=user.full_name, email=user.email)


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

# @user_router.post("/logout")
# def logout(user: User = Depends(get_current_user)):
#     user.hashed_password = None
#     return {"message": "User has been logged out"}

@user_router.post("/logout")
def logout(user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    # Extract token and expiration time
    token = user.token  # Assumes token is attached to the user in get_current_user
    decoded_token = jwt.decode(token, f"{settings.SECRET_KEY}", algorithms=["HS256"])
    expires_at = datetime.utcfromtimestamp(decoded_token["exp"])

    # Blacklist the token in the database
    blacklist_token(token, db, expires_at)
    return {"message": "User has been logged out"}
