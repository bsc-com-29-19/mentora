from pydantic import BaseModel
from typing import Optional, List
from enum import Enum
from uuid import UUID



class Rating(int, Enum):
    awful = 1
    bad = 2
    ok = 3
    good = 4
    great = 5


class CreateUpdateJournal(BaseModel):
    most_important_task: str
    grateful_things: List[str]
    overall_day_rating: Rating
    overall_mood_rating: Rating
    completed_most_important_task: bool
    day_summary: str
    mood_tags: Optional[List[str]] = None


class UpdateJournal(CreateUpdateJournal):
    most_important_task: Optional[str] = None
    grateful_things: Optional[List[str]] = None
    overall_day_rating: Optional[Rating] = None
    overall_mood_rating: Optional[Rating] = None
    completed_most_important_task: Optional[bool] = None
    day_summary: Optional[str] = None
    mood_tags: Optional[List[str]] = None