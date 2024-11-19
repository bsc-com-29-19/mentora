from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.activities.models import ActivityStatus
from .schemas import ActivityCreate, ActivityUpdate, ActivityResponse,UpdateStatusRequest
from dependencies import get_db, get_current_user
from app.auth.models import User
from .services import create_activity_service, list_activities_service,list_activities_for_today_service, get_activity_service, update_activity_service, delete_activity_service, update_activity_status_service
from .db_connection import get_db_connection_check

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

@activity_router.get("/today", response_model=list[ActivityResponse])
def list_today_activities(db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    activities = list_activities_for_today_service(db, user)
    return activities



# Get a single activity by ID
@activity_router.get("/{activity_id}", response_model=ActivityResponse)
def get_activity(activity_id: str, db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    activity = get_activity_service(activity_id, db, user)
    return activity

# Update activity status
@activity_router.patch("/{activity_id}/status", response_model=ActivityResponse)
def update_activity_status(
    activity_id: str,
    status_update: UpdateStatusRequest,
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user)
):
    activity = update_activity_status_service(activity_id, status_update.status, db, user)
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



