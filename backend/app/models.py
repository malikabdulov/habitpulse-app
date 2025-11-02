from datetime import datetime

from sqlalchemy import Boolean, Column, DateTime, Integer, Text

from .db import Base


class Habit(Base):
    __tablename__ = "habits"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(Text, nullable=False)
    description = Column(Text, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    completed_today = Column(Boolean, default=False, nullable=False)
