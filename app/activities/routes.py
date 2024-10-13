from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from .models import Activity
from .schemas import ActivityCreate, ActivityUpdate, ActivityResponse
from dependencies import get_db, get_current_user
from app.auth.models import User

activity_router = APIRouter()

# Todo : Seperate code to services and routes 

# Create a new activity
@activity_router.post("/", response_model=ActivityResponse)
def create_activity(activity_data: ActivityCreate, db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    activity = Activity(title=activity_data.title, description=activity_data.description, status=activity_data.status.value, user_id=user.id)
    db.add(activity)
    db.commit()
    db.refresh(activity)
    return activity

# List all activities
@activity_router.get("/", response_model=list[ActivityResponse])
def list_activities(db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    activities = db.query(Activity).filter(Activity.user_id == user.id).all()
    return activities

# Get a single activity by ID
@activity_router.get("/{activity_id}", response_model=ActivityResponse)
def get_activity(activity_id: str, db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    activity = db.query(Activity).filter(Activity.id == activity_id, Activity.user_id == user.id).first()
    if not activity:
        raise HTTPException(status_code=404, detail="Activity not found")
    return activity

# Update an existing activity
@activity_router.put("/{activity_id}", response_model=ActivityResponse)
def update_activity(activity_id: str, activity_data: ActivityUpdate, db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    activity = db.query(Activity).filter(Activity.id == activity_id, Activity.user_id == user.id).first()
    if not activity:
        raise HTTPException(status_code=404, detail="Activity not found")
    
    activity.title = activity_data.title
    activity.description = activity_data.description
    activity.status = activity_data.status.value
    db.commit()
    db.refresh(activity)
    return activity

# Delete an activity
@activity_router.delete("/{activity_id}")
def delete_activity(activity_id: str, db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    activity = db.query(Activity).filter(Activity.id == activity_id, Activity.user_id == user.id).first()
    if not activity:
        raise HTTPException(status_code=404, detail="Activity not found")
    
    db.delete(activity)
    db.commit()
    return {"message": "Activity deleted successfully"}
