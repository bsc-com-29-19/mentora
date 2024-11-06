# app/stats/services.py

from sqlalchemy.orm import Session
from sqlalchemy import and_
from app.activities.models import Activity, ActivityStatus
from app.journal.models import JournalEntryDB
from app.stats.schemas import StatsResponse, DailyStats, WeeklyStatsResponse
from app.auth.models import User
from datetime import datetime, timedelta
from typing import List
import calendar

def get_daily_stats(db: Session, user_id: str) -> List[DailyStats]:
    """Returns detailed stats per day."""
    daily_stats = []
    
    # Query activities and journal entries per day
    start_date = db.query(JournalEntryDB.entry_date).order_by(JournalEntryDB.entry_date).first()
    if not start_date:
        return daily_stats

    end_date = datetime.now().date()
    date_range = (end_date - start_date[0]).days + 1

    for i in range(date_range):
        day_date = start_date[0] + timedelta(days=i)
        day_name = calendar.day_name[day_date.weekday()]

        # Activities
        completed_activities = db.query(Activity).filter(
            Activity.user_id == user_id,
            Activity.status == ActivityStatus.DONE,
            # Activity.updated_at == day_date
            and_(
                Activity.updated_at >= datetime.combine(day_date, datetime.min.time()),
                Activity.updated_at < datetime.combine(day_date + timedelta(days=1), datetime.min.time())
            )
        ).count()

        total_activities = db.query(Activity).filter(
            Activity.user_id == user_id,
            # Activity.updated_at == day_date
            and_(
                Activity.updated_at >= datetime.combine(day_date, datetime.min.time()),
                Activity.updated_at < datetime.combine(day_date + timedelta(days=1), datetime.min.time())
            )

        ).count()

        incomplete_activities = total_activities - completed_activities

        # Journal Ratings
        rating_entry = db.query(JournalEntryDB).filter(
            JournalEntryDB.user_id == user_id,
            JournalEntryDB.entry_date == day_date
        ).first()
        average_day_rating = rating_entry.overall_day_rating if rating_entry else 0
        mood_rating = rating_entry.overall_mood_rating if rating_entry else 0

        daily_stats.append(DailyStats(
            date=str(day_date),
            day=day_name,
            completed_activities=completed_activities,
            incomplete_activities=incomplete_activities,
            average_day_rating=average_day_rating,
            mood_rating=mood_rating
        ))

    return daily_stats

def get_weekly_stats(daily_stats: List[DailyStats]) -> WeeklyStatsResponse:
    """Calculate weekly trends and completion percentage."""
    last_seven_days = daily_stats[-7:] if len(daily_stats) >= 7 else daily_stats
    total_completed = sum(day.completed_activities for day in last_seven_days)
    total_activities = sum(day.completed_activities + day.incomplete_activities for day in last_seven_days)
    completion_percentage = (total_completed / total_activities * 100) if total_activities > 0 else 0

    return WeeklyStatsResponse(
        daily_trends=last_seven_days,
        completion_percentage=completion_percentage
    )

def get_stats_for_user(db: Session, user: User) -> StatsResponse:
    """Fetch and return all days and weekly stats for the user."""
    daily_stats = get_daily_stats(db, user.id)
    weekly_stats = get_weekly_stats(daily_stats)

    return StatsResponse(
        all_days_trends=daily_stats,
        weekly_trends=weekly_stats
    )
