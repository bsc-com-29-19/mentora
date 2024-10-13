from pydantic import BaseModel
from typing import Optional, List
from enum import Enum
from sqlalchemy import Column, Integer, String, Boolean, Date,ForeignKey, Enum as SqlEnum
from sqlalchemy.dialects.postgresql import UUID
from  sqlalchemy.orm import relationship
from database  import Base
import uuid
from datetime import date


class Rating(int, Enum):
    awful = 1
    bad = 2
    ok = 3
    good = 4
    great = 5

class JournalEntryBase(BaseModel):
    most_important_task: str
    grateful_things: List[str]
    overall_day_rating: Rating
    overall_mood_rating: Rating
    completed_most_important_task: bool
    day_summary: str
    mood_tags: Optional[List[str]]

class JournalEntry(JournalEntryBase):
    id: UUID
    user_id: UUID
    entry_date: str

    class Config:
        from_attributes = True
        arbitrary_types_allowed = True

class JournalEntryDB(Base):
    __tablename__ = "journal_entries"

    id = Column(UUID(as_uuid=True), primary_key=True,default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    entry_date = Column(Date, nullable=False,default=date.today)
    most_important_task = Column(String, nullable=False)
    grateful_things = Column(String, nullable=False)
    overall_day_rating = Column(SqlEnum(Rating), nullable=False)
    overall_mood_rating = Column(SqlEnum(Rating), nullable=False)
    completed_most_important_task = Column(Boolean, nullable=False)
    day_summary = Column(String, nullable=False)
    mood_tags = Column(String, nullable=True)
    creator = relationship("User",backref="journal_entries")
