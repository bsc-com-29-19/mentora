from fastapi import Depends, HTTPException
from sqlalchemy.orm import Session
from dependencies import get_db, get_current_user
from app.auth.models import User
from .models import JournalEntryDB

def get_journal_for_user(journal_id: str, db: Session = Depends(get_db), user: User = Depends(get_current_user)) -> JournalEntryDB:
    journal = db.query(JournalEntryDB).filter(JournalEntryDB.id == journal_id).first()
    
    if not journal:
        raise HTTPException(status_code=404, detail="Journal entry not found")
    
    if journal.user_id != user.id:
        raise HTTPException(status_code=403, detail="You don't have permission to modify this journal entry")
    
    return journal
