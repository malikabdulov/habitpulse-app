from typing import List

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import func
from sqlalchemy.orm import Session

from .. import models, schemas
from ..db import get_db
from ..metrics import habit_total_gauge

router = APIRouter(prefix="/habits", tags=["habits"])


def _update_habit_metrics(db: Session) -> None:
    total = db.query(func.count(models.Habit.id)).scalar() or 0
    habit_total_gauge.set(total)


@router.get("", response_model=List[schemas.Habit])
def list_habits(db: Session = Depends(get_db)):
    habits = db.query(models.Habit).order_by(models.Habit.created_at.desc()).all()
    habit_total_gauge.set(len(habits))
    return habits


@router.post("", response_model=schemas.Habit, status_code=status.HTTP_201_CREATED)
def create_habit(payload: schemas.HabitCreate, db: Session = Depends(get_db)):
    habit = models.Habit(**payload.dict())
    db.add(habit)
    db.commit()
    db.refresh(habit)
    _update_habit_metrics(db)
    return habit


@router.put("/{habit_id}", response_model=schemas.Habit)
def update_habit(habit_id: int, payload: schemas.HabitUpdate, db: Session = Depends(get_db)):
    habit = db.query(models.Habit).filter(models.Habit.id == habit_id).first()
    if not habit:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Habit not found")

    update_data = payload.dict(exclude_unset=True)
    for key, value in update_data.items():
        setattr(habit, key, value)

    db.commit()
    db.refresh(habit)
    _update_habit_metrics(db)
    return habit


@router.delete("/{habit_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_habit(habit_id: int, db: Session = Depends(get_db)):
    habit = db.query(models.Habit).filter(models.Habit.id == habit_id).first()
    if not habit:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Habit not found")

    db.delete(habit)
    db.commit()
    _update_habit_metrics(db)
    return None
