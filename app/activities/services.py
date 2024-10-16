from fastapi import  HTTPException
from .models import Activity


def create_activity_service(activity_data, db, user) -> Activity:
    activity = Activity(title=activity_data.title, description=activity_data.description, status=activity_data.status.value, user_id=user.id)
    db.add(activity)
    db.commit()
    db.refresh(activity)
    return activity



def list_activities_service(db, user) -> list[Activity]:
    activities = db.query(Activity).filter(Activity.user_id == user.id).all()
    return activities




def get_activity_service(activity_id: str, db, user) -> Activity:
    activity = db.query(Activity).filter(Activity.id == activity_id, Activity.user_id == user.id).first()
    if not activity:
        raise HTTPException(status_code=404, detail="Activity not found")
    return activity



def update_activity_service(activity_id: str, activity_data, db, user) -> Activity:
    activity = db.query(Activity).filter(Activity.id == activity_id, Activity.user_id == user.id).first()
    if not activity:
        raise HTTPException(status_code=404, detail="Activity not found")
    
    activity.title = activity_data.title
    activity.description = activity_data.description
    activity.status = activity_data.status.value
    db.commit()
    db.refresh(activity)
    return activity




def delete_activity_service(activity_id: str, db, user) -> Activity:
    activity = db.query(Activity).filter(Activity.id == activity_id, Activity.user_id == user.id).first()
    if not activity:
        raise HTTPException(status_code=404, detail="Activity not found")
    
    db.delete(activity)
    db.commit()
    return activity