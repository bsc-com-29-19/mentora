import os
from dotenv import load_dotenv
from langchain_openai import ChatOpenAI
##### from langchain import sql_database
from langchain_community.utilities.sql_database import SQLDatabase
##### from langchain_community.utilities import SQLDatabaseChain
from langchain_experimental.sql import SQLDatabaseChain
from apscheduler.schedulers.background import BackgroundScheduler
from datetime import datetime
from typing import List
from .prompts import prompt1
from .services import create_activity_service
from .models import  Activity,ActivityStatus
from app.journal.services import list_all_journals_service
import ast



load_dotenv()

DATABASE_URL = os.getenv('DATABASE_URL')

##### db = sql_database(DATABASE_URL)
db = SQLDatabase.from_uri(DATABASE_URL)
###### db = SQLDatabase.from_uri("postgresql://admin:password@postgres:5432/mentoradb")

print(f"DB: {db}")  # Print the database object (for debugging pub)

#### Initialize the model
model = ChatOpenAI(model="gpt-3.5-turbo")


db_chain = SQLDatabaseChain.from_llm(model,db,verbose=True)  



def generate_activities_for_user(user, journals, db):
    activities = []

    # Combine journal entries into one prompt for the AI
    # journal_text = "\n".join([entry['journal_content'] for entry in journals])

    # journal_text = "\n".join([f"Date: {entry['entry_date']}\nSummary: {entry['day_summary']}\nMood: {entry['mood']}\nMost Important Task: {entry['important_task']}\nGrateful Things: {', '.join(entry['grateful_things'])}\nCompleted: {entry['completed_task']}\n" for entry in journals])


    # # AI prompt to analyze journals and suggest activities
    # prompt = f"""
    # Based on the following journal entries from user '{user['full_name']}', suggest six personalized activities to support their mental and emotional well-being:
    # Journals:
    # {journal_text}

    # Generate activities in the format:
    # - Title: <activity title>
    # - Description: <brief description>
    # """
    if not journals:
        prompt = f"""
        User '{user['full_name']}' has no journal entries. Please suggest six general activities to support their mental and emotional well-being based on best practices for mental health:
        Generate activities in the format:
        - Title: <activity title>
        - Description: <brief description>
        """
    else:
        # Combine journal entries into one prompt for the AI
        journal_text = "\n".join([f"Date: {entry['entry_date']}\nSummary: {entry['day_summary']}\nMood: {entry['mood']}\nMost Important Task: {entry['important_task']}\nGrateful Things: {', '.join(entry['grateful_things'])}\nCompleted: {entry['completed_task']}\n" for entry in journals])

        # AI prompt to analyze journals and suggest activities
        prompt = f"""
        Based on the following journal entries from user '{user['full_name']}', suggest six personalized activities to support their mental and emotional well-being:
        Journals:
        {journal_text}

        Generate activities in the format:
        - Title: <activity title>
        - Description: <brief description>
        """

    # Get AI-generated suggestions
    response = model(prompt)
    suggested_activities = response.splitlines()

    # Convert AI response to structured Activity objects
    for i in range(6):
        activity_data = Activity(
            title=suggested_activities[i*2].replace("Title: ", "").strip(),
            description=suggested_activities[i*2 + 1].replace("Description: ", "").strip(),
            status=ActivityStatus.NOT_DONE
        )
        activity = create_activity_service(activity_data, db, user)
        activities.append(activity)

    return activities



# db_chain.invoke("How many users have signed up with their name")
# db_chain.invoke("show all activities")
def generate_daily_activities():
    """
    Function to generate six activities for each user based on their journal entries.
    This function will be called daily at 23:00 CAT by the scheduler.
    """
    try:
        # Query to fetch all users and their journal entries
        # query = """
        # SELECT users.id AS user_id, users.name, journals.content AS journal_content, journals.created_at
        # FROM users
        # JOIN journals ON users.id = journals.user_id
        # ORDER BY users.id, journals.created_at;
        # """
        # query ="""
        #         SELECT 
        #             users.id AS user_id, 
        #             users.full_name,
        #             users.email,
        #             journal_entries.entry_date, 
        #             journal_entries.most_important_task, 
        #             journal_entries.grateful_things, 
        #             journal_entries.overall_day_rating, 
        #             journal_entries.overall_mood_rating, 
        #             journal_entries.completed_most_important_task, 
        #             journal_entries.day_summary, 
        #             journal_entries.mood_tags
        #         FROM 
        #             users
        #         JOIN 
        #             journal_entries ON users.id = journal_entries.user_id
        #         ORDER BY 
        #             users.id, journal_entries.entry_date;
        #         """
        # Fetch journal data
        # query= ""
        # users_journals = db_chain.invoke(list_all_journals_service(db))
        chain_response = db_chain.invoke("list_all_journals_service(db)")


        users_journals = chain_response.get('result')

        if users_journals:
            # Convert the string representation of list to an actual Python list
            users_journals = ast.literal_eval(users_journals)
        else:
            print("No journal entries found.")
            return
        
        # Process each user's journal entries and generate activities
        print(f"type ::::::::.........-----....::::: : {type(users_journals)}")  # Check the type
        print(f"user journals .......... ------................: {users_journals}")  # Print the users_journals") 
        for user_data in users_journals:
            # user_data = user_data1['query']

            print(f"User data:::---------::::::::::: {user_data}")

            user = {"id": user_data['user_id'], "full_name": user_data['full_name'], "email": user_data['email']}
            # journals = user_data['journals']

            journals = []
            
            # Prepare a list of journal entries for the user
            for entry in user_data['journal_entries']:
                journals.append({
                    "journal_content": entry['day_summary'],  
                    "mood": entry['overall_mood_rating'],
                    "important_task": entry['most_important_task'],
                    "completed_task": entry['completed_most_important_task'],
                    "grateful_things": entry['grateful_things']
                })



            generate_activities_for_user(user, journals, db)

        print(f"Generated activities at {datetime.now()}")
    except Exception as e:
        print(f"Error generating daily activities: {e}")


scheduler = BackgroundScheduler()
scheduler.add_job(generate_daily_activities, 'cron', hour=21, minute=30)
scheduler.start()



def shutdown_scheduler():
    scheduler.shutdown()


def get_db_connection_check():
    # query = "How many users have signed up show  their username and email and list of activities for every user"
    query= "show all activities"
    result = db_chain.invoke(query)

    return {"status": "success", "data": result}

