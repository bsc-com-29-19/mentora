# app/stats/routes.py

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from dependencies import get_db, get_current_user
from app.auth.models import User
from app.stats.services import get_stats_for_user
from app.stats.schemas import StatsResponse , WeeklyStatsResponse

stats_router = APIRouter()

@stats_router.get("/", response_model=StatsResponse)
def list_all_stats(db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    """Returns stats for all days and weekly trends."""
    try:
        stats = get_stats_for_user(db, user)
        return stats
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@stats_router.get("/weekly", response_model=WeeklyStatsResponse)
def list_weekly_trends(db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    """Returns trends for the past seven days, including completion percentage."""
    try:
        all_stats = get_stats_for_user(db, user)
        return all_stats.weekly_trends
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
