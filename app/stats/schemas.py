# app/stats/schemas.py

from pydantic import BaseModel
from typing import List, Optional
from datetime import date
from enum import Enum

class DailyStats(BaseModel):
    date: str
    day: str
    completed_activities: int
    incomplete_activities: int
    average_day_rating: Optional[float] = 0
    mood_rating: Optional[int] = 0  # Assuming mood rating is an integer from 1 to 5

class WeeklyStatsResponse(BaseModel):
    daily_trends: List[DailyStats]
    completion_percentage: float  # percentage of completed activities over the week

class StatsResponse(BaseModel):
    all_days_trends: List[DailyStats]
    weekly_trends: WeeklyStatsResponse
