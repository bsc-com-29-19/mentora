from app.journal.models import JournalEntry
from app.auth.models import User
from datetime import date


def test_create_journal_entry():
    user = User(username="user", email="user@gmail.com", hashed_password="password")
    journal_entry = JournalEntry(
        user=user,
        most_important_task="Task 1",
        grateful_things=["Thing 1", "Thing 2","Thing 3"],
        overall_day_rating="good",
        overall_mood_rating="bad",
        completed_most_important_task=True,
        day_summary="Summary",
        mood_tags=["Tag 1", "Tag 2"]
    )

    assert journal_entry.user == user
    assert journal_entry.most_important_task == "Task 1"
    assert journal_entry.grateful_things == ["Thing 1", "Thing 2"]
    assert journal_entry.overall_day_rating == "good"
    assert journal_entry.overall_mood_rating == "bad"
    assert journal_entry.completed_most_important_task == True
    assert journal_entry.day_summary == "Summary"
    assert journal_entry.mood_tags == ["Tag 1", "Tag 2"]


def test_user_journal_entries_relationship():
    user = User(username="user", email="user@gmail.com", hashed_password="password")
    journal_entry = JournalEntry(
        user=user,
        most_important_task="Task 1",
        grateful_things=["Thing 1", "Thing 2"],
        overall_day_rating="good",
        overall_mood_rating="bad",
        completed_most_important_task=True,
        day_summary="Summary",
        mood_tags=["Tag 1", "Tag 2"]
    )
    assert journal_entry.user == user
    assert user.journal_entries == [journal_entry]


def test_journal_entry_default_values():
    user = User(username="user", email="user@gmail.com", hashed_password="password")
    journal_entry = JournalEntry(
        user=user,
        most_important_task="Task 1",
        grateful_things=["Thing 1", "Thing 2"],
        overall_day_rating="good",
        overall_mood_rating="bad",
        completed_most_important_task=True,
        day_summary="Summary",
        mood_tags=["Tag 1", "Tag 2"]
    )
    assert journal_entry.entry_date == date.today()


def test_journal_entry_attributes():
    user = User(username="user", email="user@gmail.com", hashed_password="password")
    journal_entry = JournalEntry(
        user=user,
        most_important_task="Task 1",
        grateful_things=["Thing 1", "Thing 2"],
        overall_day_rating="good",
         overall_mood_rating="bad",
        completed_most_important_task=True,
        day_summary="Summary",
        mood_tags=["Tag 1", "Tag 2"]
    )
    assert journal_entry.most_important_task == "Task 1"
    assert journal_entry.grateful_things == ["Thing 1", "Thing 2"]
    assert journal_entry.overall_day_rating == "good"
    assert journal_entry.overall_mood_rating == "bad"
    assert journal_entry.completed_most_important_task == True
    assert journal_entry.day_summary == "Summary"
    assert journal_entry.mood_tags == ["Tag 1", "Tag 2"]