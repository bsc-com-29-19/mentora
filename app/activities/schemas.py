from pydantic import BaseModel
from uuid import UUID
from typing import Optional
from datetime import datetime
from enum import Enum

class ActivityStatus(str, Enum):
    NOT_DONE = "not_done"
    DONE = "done"

class ActivityBase(BaseModel):
    title: str
    description: Optional[str] = None
    status: ActivityStatus = ActivityStatus.NOT_DONE

class ActivityCreate(ActivityBase):
    pass

class ActivityUpdate(ActivityBase):
    pass

class ActivityResponse(ActivityBase):
    id: UUID
    user_id: UUID
    created_at: datetime
    updated_at: datetime

    class Config:
        orm_mode = True
