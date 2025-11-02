from datetime import datetime
from typing import Optional

from pydantic import BaseModel, Field


class HabitBase(BaseModel):
    name: str = Field(..., min_length=1, max_length=255)
    description: Optional[str] = None
    completed_today: bool = False


class HabitCreate(HabitBase):
    pass


class HabitUpdate(BaseModel):
    name: Optional[str] = Field(None, min_length=1, max_length=255)
    description: Optional[str] = None
    completed_today: Optional[bool] = None


class Habit(HabitBase):
    id: int
    created_at: datetime

    class Config:
        orm_mode = True
