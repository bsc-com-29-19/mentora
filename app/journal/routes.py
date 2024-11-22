from datetime import date
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from dependencies import get_db, get_current_user
from app.auth.models import User
from .schema import CreateUpdateJournal, UpdateJournal
from .models import JournalEntryDB
from .dependency import get_journal_for_user
import json
from datetime import date,datetime,timezone

journal_router = APIRouter()


@journal_router.post('/')
def create_journal(
    journal_data: CreateUpdateJournal, 
    db: Session = Depends(get_db), 
    user: User = Depends(get_current_user)
):
    # Check if a journal entry already exists for today
    today = date.today()
    existing_journal = db.query(JournalEntryDB).filter(
        JournalEntryDB.user_id == user.id,
        JournalEntryDB.entry_date == today
    ).first()

    if existing_journal:
        raise HTTPException(
            status_code=409,
            detail={
                "message": "A journal entry for today already exists.",
                "journal_id": str(existing_journal.id)
            } 
            # detail="A journal entry for today already exists."
        )

    # Create the new journal entry
    journal_entry = JournalEntryDB(
        most_important_task=journal_data.most_important_task,
        grateful_things=journal_data.grateful_things,  
        overall_day_rating=journal_data.overall_day_rating,
        overall_mood_rating=journal_data.overall_mood_rating,
        completed_most_important_task=journal_data.completed_most_important_task,
        day_summary=journal_data.day_summary,
        mood_tags=journal_data.mood_tags if journal_data.mood_tags else None,
        user_id=user.id
    )

    db.add(journal_entry)
    db.commit()
    db.refresh(journal_entry)

    # Deserialize JSON fields for the response
    grateful_things = journal_entry.grateful_things
    mood_tags = journal_entry.mood_tags if journal_entry.mood_tags else None

    return {
        "data": {
            "id": str(journal_entry.id),
            "grateful_things": grateful_things,
            "completed_most_important_task": journal_entry.completed_most_important_task,
            "mood_tags": mood_tags,
            "entry_date": journal_entry.entry_date.isoformat(),
            "user_id": str(journal_entry.user_id),
            "most_important_task": journal_entry.most_important_task,
            "overall_day_rating": journal_entry.overall_day_rating,
            "overall_mood_rating": journal_entry.overall_mood_rating,
            "day_summary": journal_entry.day_summary,
            # "created_at": journal_entry.created_at.isoformat(),
            # "updated_at": journal_entry.updated_at.isoformat(),

        }
    }


# Create journal entry
#  Todo : separate to services and routes: the route should call the service
@journal_router.post('/keeps')
def create_journal_keeps(journal_data: CreateUpdateJournal, db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    journal_entry = JournalEntryDB(
        most_important_task=journal_data.most_important_task,
        grateful_things=journal_data.grateful_things,  
        # grateful_things=','.join(journal_data.grateful_things),  # Assuming grateful_things is stored as a string
        overall_day_rating=journal_data.overall_day_rating,
        overall_mood_rating=journal_data.overall_mood_rating,
        completed_most_important_task=journal_data.completed_most_important_task,
        day_summary=journal_data.day_summary,
        mood_tags=journal_data.mood_tags if journal_data.mood_tags else None,
        # mood_tags=','.join(journal_data.mood_tags) if journal_data.mood_tags else None,
        user_id=user.id
    )


    db.add(journal_entry)
    db.commit()
    db.refresh(journal_entry)
    # return {
    #     "data": journal_entry.__dict__

    # }
    grateful_things = json.loads(journal_entry.grateful_things)
    mood_tags = json.loads(journal_entry.mood_tags) if journal_entry.mood_tags else None

    return {
        "data": {
            "id": str(journal_entry.id),
            "grateful_things": grateful_things,
            "completed_most_important_task": journal_entry.completed_most_important_task,
            "mood_tags": mood_tags,
            "entry_date": journal_entry.entry_date.isoformat(),
            "user_id": str(journal_entry.user_id),
            "most_important_task": journal_entry.most_important_task,
            "overall_day_rating": journal_entry.overall_day_rating,
            "overall_mood_rating": journal_entry.overall_mood_rating,
            "day_summary": journal_entry.day_summary,
            # "created_at": journal_entry.created_at.isoformat(),
            # "updated_at": journal_entry.updated_at.isoformat(),

        }
    }


@journal_router.get('/today')
def fetch_today_journal(db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    today = date.today()
    # today = datetime.now().date()
    
    journal = db.query(JournalEntryDB).filter(
        JournalEntryDB.entry_date == today,
        JournalEntryDB.user_id == user.id
    ).first()

    if not journal:
        raise HTTPException(status_code=404, detail="No journal entry found for today")

    return {
        "data": {
            "id": str(journal.id),
            "user_id": str(journal.user_id),
            "entry_date": journal.entry_date.isoformat(),
            "most_important_task": journal.most_important_task,
            "grateful_things": json.loads(journal.grateful_things) if journal.grateful_things else None,
            "overall_day_rating": journal.overall_day_rating,
            "overall_mood_rating": journal.overall_mood_rating,
            "completed_most_important_task": journal.completed_most_important_task,
            "day_summary": journal.day_summary,
            "mood_tags": json.loads(journal.mood_tags) if journal.mood_tags else None,
            # "created_at": journal.created_at.isoformat(),
            # "updated_at": journal.updated_at.isoformat(),

        }
    }


# List all journal entries for the user
@journal_router.get('/')
def list_journals(db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    journals = db.query(JournalEntryDB).filter(JournalEntryDB.user_id == user.id).all()
    data = []

    for journal in journals:
        # Safely parse `grateful_things`
        try:
            grateful_things = json.loads(journal.grateful_things) if journal.grateful_things else None
        except json.JSONDecodeError:
            grateful_things = None

        # Safely parse `mood_tags`
        try:
            mood_tags = json.loads(journal.mood_tags) if journal.mood_tags else None
        except json.JSONDecodeError:
            mood_tags = None

        data.append({
            "id": str(journal.id),
            "user_id": str(journal.user_id),
            "entry_date": journal.entry_date.isoformat(),
            "most_important_task": journal.most_important_task,
            "grateful_things": grateful_things,
            "overall_day_rating": journal.overall_day_rating,
            "overall_mood_rating": journal.overall_mood_rating,
            "completed_most_important_task": journal.completed_most_important_task,
            "day_summary": journal.day_summary,
            "mood_tags": mood_tags,
        })

    return {
        "data": data
    }
    # journals = db.query(JournalEntryDB).filter(JournalEntryDB.user_id == user.id).all()
    # return {
    #     "data": [journal.__dict__ for journal in journals]
    # }

# View a specific journal entry
@journal_router.get('/{journal_id}')
def view_journal(journal_id: str, db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    journal = db.query(JournalEntryDB).filter(JournalEntryDB.id == journal_id, JournalEntryDB.user_id == user.id).first()
    if not journal:
        raise HTTPException(status_code=404, detail="Journal entry not found")

    return {
        "data": {
            "id": str(journal.id),
            "user_id": str(journal.user_id),
            "entry_date": journal.entry_date.isoformat(),
            "most_important_task": journal.most_important_task,
            "grateful_things": json.loads(journal.grateful_things) if journal.grateful_things else None,
            "overall_day_rating": journal.overall_day_rating,
            "overall_mood_rating": journal.overall_mood_rating,
            "completed_most_important_task": journal.completed_most_important_task,
            "day_summary": journal.day_summary,
            "mood_tags": json.loads(journal.mood_tags) if journal.mood_tags else None,
        }
    }
    # journal = db.query(JournalEntryDB).filter(JournalEntryDB.id == journal_id, JournalEntryDB.user_id == user.id).first()
    # if not journal:
    #     raise HTTPException(status_code=404, detail="Journal entry not found")
    # return {
    #     "data": journal.__dict__
    # }




# Update a journal entry
@journal_router.put('/{journal_id}')
def edit_journal(
    journal_id: str, 
    journal_data: UpdateJournal, 
    journal: JournalEntryDB = Depends(get_journal_for_user), 
    db: Session = Depends(get_db)
):
    # Update only the provided fields
    if journal_data.most_important_task:
        journal.most_important_task = journal_data.most_important_task
    if journal_data.grateful_things:
        journal.grateful_things = json.dumps(journal_data.grateful_things)  # Store as JSON string
    if journal_data.overall_day_rating:
        journal.overall_day_rating = journal_data.overall_day_rating
    if journal_data.overall_mood_rating:
        journal.overall_mood_rating = journal_data.overall_mood_rating
    if journal_data.completed_most_important_task is not None:
        journal.completed_most_important_task = journal_data.completed_most_important_task
    if journal_data.day_summary:
        journal.day_summary = journal_data.day_summary
    if journal_data.mood_tags is not None:
        journal.mood_tags = json.dumps(journal_data.mood_tags)  # Store as JSON string

    # Commit the changes
    db.commit()
    db.refresh(journal)

    # Deserialize JSON fields for response
    grateful_things = json.loads(journal.grateful_things) if journal.grateful_things else None
    mood_tags = json.loads(journal.mood_tags) if journal.mood_tags else None

    return {
        "data": {
            "id": str(journal.id),
            "grateful_things": grateful_things,
            "completed_most_important_task": journal.completed_most_important_task,
            "mood_tags": mood_tags,
            "entry_date": journal.entry_date.isoformat(),
            "user_id": str(journal.user_id),
            "most_important_task": journal.most_important_task,
            "overall_day_rating": journal.overall_day_rating,
            "overall_mood_rating": journal.overall_mood_rating,
            "day_summary": journal.day_summary,
        }
    }

# @journal_router.put('/{journal_id}')
# def edit_journal(journal_id: str, journal_data: UpdateJournal, journal: JournalEntryDB = Depends(get_journal_for_user), db: Session = Depends(get_db)):
#     if journal_data.most_important_task:
#         journal.most_important_task = journal_data.most_important_task
#     if journal_data.grateful_things:
#         journal.grateful_things = ','.join(journal_data.grateful_things)
#     if journal_data.overall_day_rating:
#         journal.overall_day_rating = journal_data.overall_day_rating
#     if journal_data.overall_mood_rating:
#         journal.overall_mood_rating = journal_data.overall_mood_rating
#     if journal_data.completed_most_important_task is not None:
#         journal.completed_most_important_task = journal_data.completed_most_important_task
#     if journal_data.day_summary:
#         journal.day_summary = journal_data.day_summary
#     if journal_data.mood_tags is not None:
#         journal.mood_tags = ','.join(journal_data.mood_tags)
    
#     db.commit()
#     db.refresh(journal)
#     return {
#         "data": journal.__dict__
#     }

# Delete a journal entry
@journal_router.delete('/{journal_id}')
def delete_journal(journal: JournalEntryDB = Depends(get_journal_for_user), db: Session = Depends(get_db)):
    db.delete(journal)
    db.commit()
    return {
        "message": "Journal entry deleted successfully"
    }
