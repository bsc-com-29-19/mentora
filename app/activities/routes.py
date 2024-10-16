from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from .schemas import ActivityCreate, ActivityUpdate, ActivityResponse
from dependencies import get_db, get_current_user
from app.auth.models import User
from .services import create_activity_service, list_activities_service, get_activity_service, update_activity_service, delete_activity_service

activity_router = APIRouter()

# Todo : Seperate code to services and routes 

# Create a new activity
@activity_router.post("/", response_model=ActivityResponse)
def create_activity(activity_data: ActivityCreate, db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    activity = create_activity_service(activity_data, db, user)
    return activity



# List all activities
@activity_router.get("/", response_model=list[ActivityResponse])
def list_activities(db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    activities = list_activities_service(db, user)
    return activities



# Get a single activity by ID
@activity_router.get("/{activity_id}", response_model=ActivityResponse)
def get_activity(activity_id: str, db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    activity = get_activity_service(activity_id, db, user)
    return activity


# Update an existing activity
@activity_router.put("/{activity_id}", response_model=ActivityResponse)
def update_activity(activity_id: str, activity_data: ActivityUpdate, db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    activity = update_activity_service(activity_id, activity_data, db, user)
    return activity



# Delete an activity
@activity_router.delete("/{activity_id}")
def delete_activity(activity_id: str, db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    activity = delete_activity_service(activity_id, db, user)
    return {"message": f"Activity : {activity.title} deleted successfully"}


