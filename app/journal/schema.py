from pydantic import BaseModel
from typing import Optional, List
from enum import Enum
from uuid import UUID



class MoodRating(str, Enum):
    awful = "awful"
    bad = "bad"
    ok = "ok"
    good = "good"
    great = "great"


class CreateUpdateJournal(BaseModel):
    most_important_task: str
    grateful_things: List[str]
    overall_day_rating: MoodRating
    overall_mood_rating: MoodRating
    completed_most_important_task: bool
    day_summary: str
    mood_tags: Optional[List[str]] = None


class UpdateJournal(CreateUpdateJournal):
    most_important_task: Optional[str] = None
    grateful_things: Optional[List[str]] = None
    overall_day_rating: Optional[MoodRating] = None
    overall_mood_rating: Optional[MoodRating] = None
    completed_most_important_task: Optional[bool] = None
    day_summary: Optional[str] = None
    mood_tags: Optional[List[str]] = None