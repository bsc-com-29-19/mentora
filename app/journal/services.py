from fastapi import APIRouter, Depends, HTTPException
from .models import JournalEntry
from sqlalchemy.orm import Session
from datetime import datetime, timedelta
from dependencies import get_db




def list_all_journals_service(db: Session = Depends(get_db)) -> list[JournalEntry]:
    journals = db.query(JournalEntry).all()
    return journals