from pydantic import BaseModel
from uuid import UUID
from typing import Optional
from datetime import datetime

class ActivityBase(BaseModel):
    title: str
    description: Optional[str] = None

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
