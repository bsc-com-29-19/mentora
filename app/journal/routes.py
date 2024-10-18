from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from dependencies import get_db, get_current_user
from app.auth.models import User
from .schema import CreateUpdateJournal, UpdateJournal
from .models import JournalEntryDB
from .dependency import get_journal_for_user

journal_router = APIRouter()

# Create journal entry
#  Todo : separate to services and routes: the route should call the service
@journal_router.post('/')
def create_journal(journal_data: CreateUpdateJournal, db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    journal_entry = JournalEntryDB(
        most_important_task=journal_data.most_important_task,
        grateful_things=','.join(journal_data.grateful_things),  # Assuming grateful_things is stored as a string
        overall_day_rating=journal_data.overall_day_rating,
        overall_mood_rating=journal_data.overall_mood_rating,
        completed_most_important_task=journal_data.completed_most_important_task,
        day_summary=journal_data.day_summary,
        mood_tags=','.join(journal_data.mood_tags) if journal_data.mood_tags else None,
        user_id=user.id
    )
    db.add(journal_entry)
    db.commit()
    db.refresh(journal_entry)
    return {
        "data": journal_entry.__dict__
    }

# List all journal entries for the user
@journal_router.get('/')
def list_journals(db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    journals = db.query(JournalEntryDB).filter(JournalEntryDB.user_id == user.id).all()
    return {
        "data": [journal.__dict__ for journal in journals]
    }

# View a specific journal entry
@journal_router.get('/{journal_id}')
def view_journal(journal_id: str, db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    journal = db.query(JournalEntryDB).filter(JournalEntryDB.id == journal_id, JournalEntryDB.user_id == user.id).first()
    if not journal:
        raise HTTPException(status_code=404, detail="Journal entry not found")
    return {
        "data": journal.__dict__
    }

# Update a journal entry
@journal_router.put('/{journal_id}')
def edit_journal(journal_id: str, journal_data: UpdateJournal, journal: JournalEntryDB = Depends(get_journal_for_user), db: Session = Depends(get_db)):
    if journal_data.most_important_task:
        journal.most_important_task = journal_data.most_important_task
    if journal_data.grateful_things:
        journal.grateful_things = ','.join(journal_data.grateful_things)
    if journal_data.overall_day_rating:
        journal.overall_day_rating = journal_data.overall_day_rating
    if journal_data.overall_mood_rating:
        journal.overall_mood_rating = journal_data.overall_mood_rating
    if journal_data.completed_most_important_task is not None:
        journal.completed_most_important_task = journal_data.completed_most_important_task
    if journal_data.day_summary:
        journal.day_summary = journal_data.day_summary
    if journal_data.mood_tags is not None:
        journal.mood_tags = ','.join(journal_data.mood_tags)
    
    db.commit()
    db.refresh(journal)
    return {
        "data": journal.__dict__
    }

# Delete a journal entry
@journal_router.delete('/{journal_id}')
def delete_journal(journal: JournalEntryDB = Depends(get_journal_for_user), db: Session = Depends(get_db)):
    db.delete(journal)
    db.commit()
    return {
        "message": "Journal entry deleted successfully"
    }
