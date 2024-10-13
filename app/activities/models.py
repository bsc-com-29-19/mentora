from sqlalchemy import Column, String, DateTime, ForeignKey, Enum
from sqlalchemy.orm import relationship
from sqlalchemy.dialects.postgresql import UUID
from datetime import datetime, timedelta, timezone
from database import Base
from enum import Enum as PyEnum
import uuid


class ActivityStatus(str, PyEnum):
    NOT_DONE = "not_done"
    DONE = "done"



class Activity(Base):
    __tablename__ = "activities"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    title = Column(String, nullable=False)
    description = Column(String, nullable=True)
    status = Column(Enum(ActivityStatus), default=ActivityStatus.NOT_DONE, nullable=False)  # Set default to NOT_DONE
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False)
    created_at = Column(DateTime, default=datetime.now(timezone.utc) )
    updated_at = Column(DateTime, default=datetime.now(timezone.utc) , onupdate=datetime.now(timezone.utc) )

    creator = relationship("User", backref="activities")


