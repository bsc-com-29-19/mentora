import app.activities.db_connection
import json
import os
from dotenv import load_dotenv
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
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
from dependencies import get_db
# from app.auth.models import User
from app.auth.services import list_all_users_service
from app.journal.services import list_all_journals_service
# from fastapi import APIRouter, Depends
# from sqlalchemy.orm import Session
import ast
import logging
import random
# from pytz import UTC



load_dotenv()

DATABASE_URL = os.getenv('DATABASE_URL')

##### db = sql_database(DATABASE_URL)
db = SQLDatabase.from_uri(DATABASE_URL)
###### db = SQLDatabase.from_uri("postgresql://admin:password@postgres:5432/mentoradb")

print(f"DB: {db}")  # Print the database object (for debugging pub)

#### Initialize the model
model = ChatOpenAI(model="gpt-3.5-turbo")


# db_chain = SQLDatabaseChain.from_llm(model,db,verbose=True)  

def generate_activities_custom_for_all_users():

    db1 = next(get_db())  
    # List of mental health-improving activities with shortened titles
    # suggested_activities = [
    #     "Title: Go for a walk\nDescription: A 30-minute walk in nature can improve mood and reduce anxiety.",
    #     "Title: Meditate\nDescription: Spend 15 minutes focusing on your breath to relax your mind.",
    #     "Title: Read a book\nDescription: Reading can be a great escape and help reduce stress.",
    #     "Title: Gym exercise\nDescription: Physical activity boosts serotonin and can help alleviate depression.",
    #     "Title: Connect with a friend\nDescription: Socializing and spending time with friends improves emotional well-being.",
    #     "Title: Journal\nDescription: Writing about your feelings can help process emotions and clear your mind.",
    #     "Title: Listen to music\nDescription: Listening to uplifting music can improve mood and reduce stress.",
    #     "Title: Deep breathing\nDescription: Practicing deep breathing can reduce tension and improve focus.",
    #     "Title: Cook a meal\nDescription: Preparing healthy meals can increase feelings of accomplishment and improve health.",
    #     "Title: Yoga\nDescription: Yoga can enhance physical and mental flexibility while promoting relaxation.",
    #     "Title: Spend time with pets\nDescription: Interacting with animals can reduce stress and enhance emotional well-being.",
    #     "Title: Take a nap\nDescription: A short nap can recharge energy and improve mental clarity."
    # ]
    suggested_activities = [
        {"title": "Go for a walk", "description": "A 30-minute walk in nature can improve mood and reduce anxiety."},
        {"title": "Meditate", "description": "Spend 15 minutes focusing on your breath to relax your mind."},
        {"title": "Read a book", "description": "Reading can be a great escape and help reduce stress."},
        {"title": "Gym exercise", "description": "Physical activity boosts serotonin and can help alleviate depression."},
        {"title": "Connect with a friend", "description": "Socializing and spending time with friends improves emotional well-being."},
        {"title": "Journal", "description": "Writing about your feelings can help process emotions and clear your mind."},
        {"title": "Listen to music", "description": "Listening to uplifting music can improve mood and reduce stress."},
        {"title": "Deep breathing", "description": "Practicing deep breathing can reduce tension and improve focus."},
        {"title": "Cook a meal", "description": "Preparing healthy meals can increase feelings of accomplishment and improve health."},
        {"title": "Yoga", "description": "Yoga can enhance physical and mental flexibility while promoting relaxation."},
        {"title": "Spend time with pets", "description": "Interacting with animals can reduce stress and enhance emotional well-being."},
        {"title": "Take a nap", "description": "A short nap can recharge energy and improve mental clarity."}
    ]
    
    # Fetch all users from the database
    # users = db.query(User).all()  # Modify this query based on your DB library
    users = list_all_users_service(db1)

    print(f"Fetched user ---------------------- {users}")
    print("Fetched users ---------------------- :::::::::",users)
    print(f"Fetched user count: {len(users)}")

    # List to store all user activities
    all_user_activities = []
    
    # Iterate over each user and generate activities
    for user in users:
        # Randomly shuffle the activities and select 6
        random_activities = random.sample(suggested_activities, 6)

        # Process selected activities and save them for the user
        user_activities = []
        # for i in range(6):
        #     title = random_activities[i].split('\n')[0].replace("Title: ", "").strip()
        #     description = random_activities[i].split('\n')[1].replace("Description: ", "").strip()
        #     activity_data = Activity(title=title, description=description, status=ActivityStatus.NOT_DONE)
        for activity_info in random_activities:
            title = activity_info["title"]
            description = activity_info["description"]
            activity_data = Activity(title=title, description=description, status=ActivityStatus.NOT_DONE)
             
            
            activity = create_activity_service(activity_data, db1, user)
            user_activities.append(activity)

        all_user_activities.append(user_activities)
    
    return all_user_activities



# def generate_activities_for_user(user, journals, db):
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
# def generate_daily_activities():
#     """
#     Function to generate six activities for each user based on their journal entries.
#     This function will be called daily at 23:00 CAT by the scheduler.
#     """
#     try:
#         # Query to fetch all users and their journal entries
#         # query = """
#         # SELECT users.id AS user_id, users.name, journals.content AS journal_content, journals.created_at
#         # FROM users
#         # JOIN journals ON users.id = journals.user_id
#         # ORDER BY users.id, journals.created_at;
#         # """
#         # query ="""
#         #         SELECT 
#         #             users.id AS user_id, 
#         #             users.full_name,
#         #             users.email,
#         #             journal_entries.entry_date, 
#         #             journal_entries.most_important_task, 
#         #             journal_entries.grateful_things, 
#         #             journal_entries.overall_day_rating, 
#         #             journal_entries.overall_mood_rating, 
#         #             journal_entries.completed_most_important_task, 
#         #             journal_entries.day_summary, 
#         #             journal_entries.mood_tags
#         #         FROM 
#         #             users
#         #         JOIN 
#         #             journal_entries ON users.id = journal_entries.user_id
#         #         ORDER BY 
#         #             users.id, journal_entries.entry_date;
#         #         """
#         # Fetch journal data
#         # query= ""
#         # users_journals = db_chain.invoke(list_all_journals_service(db))
#         chain_response = db_chain.invoke("list_all_journals_service(db)")


#         users_journals = chain_response.get('result')

#         if users_journals:
#             # Convert the string representation of list to an actual Python list
#             users_journals = ast.literal_eval(users_journals)
#         else:
#             print("No journal entries found.")
#             return
        
#         # Process each user's journal entries and generate activities
#         print(f"type ::::::::.........-----....::::: : {type(users_journals)}")  # Check the type
#         print(f"user journals .......... ------................: {users_journals}")  # Print the users_journals") 
#         for user_data in users_journals:
#             # user_data = user_data1['query']

#             print(f"User data:::---------::::::::::: {user_data}")

#             user = {"id": user_data['user_id'], "full_name": user_data['full_name'], "email": user_data['email']}
#             # journals = user_data['journals']

#             journals = []

#             logging.info("User :::: ",user)
#             print("User ::: ",user)
            

#             logging.info("user_data :::: ",user_data['journal_entries'])
#             print("User_data ::: ",user_data['journal_entries'])
#             # Prepare a list of journal entries for the user
#             for entry in user_data['journal_entries']:

#                 logging.info("Entry",entry)
#                 print("Entry",entry)
#                 journals.append({
#                     "journal_content": entry['day_summary'],  
#                     "mood": entry['overall_mood_rating'],
#                     "important_task": entry['most_important_task'],
#                     "completed_task": entry['completed_most_important_task'],
#                     "grateful_things": entry['grateful_things']
#                 })
#                 logging.info("journals",journals)
#                 print("Journals",journals)



#             generate_activities_for_user(user, journals, db)

#         print(f"Generated activities at {datetime.now()}")
#     except Exception as e:
#         print(f"Error generating daily activities: {e}")
# def generate_daily_activities():
    try:
        # ...
        # query = list_all_journals_service(db)
        # # chain_response = db_chain.invoke(query)
        # chain_response = db_chain.invoke("list_all_journals_service(db)")
        # users_journals = chain_response.get('result')

        # all_journals = list_all_journals_service(db)

        # chain_response = db_chain.invoke(f" display content in {all_journals}")
        # users_journals = chain_response.get('result')
        # query = "SELECT * FROM journal_entries"
        # query ="""
        #     SELECT 
        #         journal_entries.id AS journal_id,
        #         journal_entries.user_id,
        #         journal_entries.entry_date,
        #         journal_entries.most_important_task,
        #         journal_entries.grateful_things,
        #         journal_entries.overall_day_rating,
        #         users.full_name,
        #         users.email
        #     FROM 
        #         journal_entries
        #     JOIN 
        #         users ON journal_entries.user_id = users.id;
        #     """
        # chain_response = db_chain.invoke(query)
        # users_journals = ast.literal_eval(chain_response.get('SQLResult'))
        # # users_journals = chain_response.get('result')

        # print("ALL journals : ",users_journals)

        # # if users_journals:
        # #     # Convert the string representation of list to an actual Python list
        # #     users_journals = ast.literal_eval(users_journals)
        # # else:
        # #     print("No journal entries found.")
        # #     return
        
        # print("ALL ALL ::::: jOurnals :: ",users_journals)
        
        # # Process each user's journal entries and generate activities
        # for user_data in users_journals:
        #     user = {
        #         "id": user_data[1], 
        #         "full_name": "",  # You need to fetch full_name from users table
        #         "email": ""  # You need to fetch email from users table
        #     }
        #     journals = []
            
        #     # Prepare a list of journal entries for the user
        #     for entry in user_data[3:]:
        #         journals.append({
        #             "journal_content": entry[0],  
        #             "mood": entry[1],
        #             "important_task": entry[2],
        #             "completed_task": entry[3],
        #             "grateful_things": entry[4]
        #         })

        query = """
        SELECT 
            users.id AS user_id,
            users.full_name,
            users.email,
            json_agg(journal_entries.*) AS journals
        FROM 
            users
        LEFT JOIN 
            journal_entries ON users.id = journal_entries.user_id
        GROUP BY 
            users.id;
        """
        chain_response = db_chain.invoke(query)
        users_journals = ast.literal_eval(chain_response.get('SQLResult'))

        if not users_journals:
            print("No journal entries found.")
            return
        print("ALL ALL ::::: jOurnals :: ",users_journals)

        for user_data in users_journals:
            user_id, full_name, email, journals = user_data
            user = {
                "id": user_data['user_id'],
                "full_name": user_data['full_name'],
                "email": user_data['email']
            }
  
            # journals = user_data.get('journals', [])
            journals = journals or []
            print("Journals -------------------------------- ",journals)
            print("user data -------------------------------",user_data)
            print("users ----------------------------------",user)
            logging.info("journals------------------------- %s",journals)
            logging.info("user data------------------------ %s",user_data)
            logging.info("user ---------------------------- %s",user)
            activities = generate_activities_for_user(user, journals, db)
            print(f"Generated activities for user {user['full_name']}: {activities}")

        print(f"Generated activities at {datetime.now()}")
            
            # generate_activities_for_user(user, journals, db)
        
        # print(f"Generated activities at {datetime.now()}")
    except Exception as e:
        print(f"Error generating daily activities: {e}")


# def generate_activities_for_all_users():
    activities_for_all_users = []
    
    try:
        # Query to retrieve users and their journal entries
        query = """
        SELECT 
            users.id AS user_id,
            users.full_name,
            users.email,
            json_agg(journal_entries.*) AS journals
        FROM 
            users
        LEFT JOIN 
            journal_entries ON users.id = journal_entries.user_id
        GROUP BY 
            users.id;
        """
        chain_response = db_chain.invoke(query)
        # users_data = json.loads(chain_response.get('SQLResult'))  # Parse the SQLResult

        # sql_result = chain_response.get('SQLResult')
        sql_result = chain_response

        if not sql_result:
            print("No SQLResult found in chain response.")
            return []
        # Parse SQLResult
        # try:
        #     users_data = json.loads(sql_result)
        # except json.JSONDecodeError as e:
        #     print(f"Error parsing SQLResult JSON: {e}")
        #     return []
        # users_data = ast.literal_eval(sql_result)
        users_data = sql_result

        if not users_data:
            print("No users found in the database.")
            return []
        
        for user_data in users_data:
            user = {
                "id": user_data[0],  # user_id
                "full_name": user_data[1] or "Unknown User",  # full_name
                "email": user_data[2]  # email
            }

            print(f"Processing user data ---==========================: {user}")

            
            # journals = user_data[3] or []  # Journals for the user
            # journals = user_data[3] if user_data[3] and user_data[3] != [None] else []
            
            # if not journals:
            #     prompt = f"""
            #     User '{user['full_name']}' has no journal entries. Please suggest six general activities to support their mental and emotional well-being based on best practices for mental health:
            #     Generate activities in the format:
            #     - Title: <activity title>
            #     - Description: <brief description>
            #     """
            # else:
            #     journal_text = "\n".join([
            #         f"Date: {entry['entry_date']}\nSummary: {entry['day_summary']}\nMood: {entry['overall_mood_rating']}\nMost Important Task: {entry['most_important_task']}\nGrateful Things: {entry['grateful_things']}\nCompleted: {entry['completed_most_important_task']}\n"
            #         for entry in journals
            #     ])
            #     prompt = f"""
            #     Based on the following journal entries from user '{user['full_name']}', suggest six personalized activities to support their mental and emotional well-being:
            #     Journals:
            #     {journal_text}
                
            #     Generate activities in the format:
            #     - Title: <activity title>
            #     - Description: <brief description>
            #     """
            raw_journals = user_data[3] or []
            journals = [entry for entry in raw_journals if isinstance(entry, dict)]  # Filter out invalid entries

            if not journals:
                prompt = f"""
                User '{user['full_name']}' has no journal entries. Please suggest six general activities to support their mental and emotional well-being:
                Generate activities in the format:
                - Title: <activity title>
                - Description: <brief description>
                """
            else:
                journal_text = "\n".join([
                    f"Date: {entry.get('entry_date', 'N/A')}\nSummary: {entry.get('day_summary', 'N/A')}\nMood: {entry.get('overall_mood_rating', 'N/A')}\nMost Important Task: {entry.get('most_important_task', 'N/A')}\nGrateful Things: {entry.get('grateful_things', 'N/A')}\nCompleted: {entry.get('completed_most_important_task', 'N/A')}\n"
                    for entry in journals
                ])
                prompt = f"""
                Based on the following journal entries from user '{user['full_name']}', suggest six personalized activities to support their mental and emotional well-being:
                Journals:
                {journal_text}
                
                Generate activities in the format:
                - Title: <activity title>
                - Description: <brief description>
                """
            
            # # Get AI-generated suggestions
            # response = model(prompt)
            # suggested_activities = response.splitlines()

            # # Process activities
            # user_activities = []
            # for i in range(6):
            #     activity_data = Activity(
            #         title=suggested_activities[i * 2].replace("Title: ", "").strip(),
            #         description=suggested_activities[i * 2 + 1].replace("Description: ", "").strip(),
            #         status=ActivityStatus.NOT_DONE
            #     )
            #     activity = create_activity_service(activity_data, db, user)
            #     user_activities.append(activity)
            
            # # Add user activities to the result
            # activities_for_all_users.append({
            #     "user_id": user["id"],
            #     "full_name": user["full_name"],
            #     "activities": user_activities
            # })
            # Get AI-generated suggestions
            try:
                response = model(prompt)
                if hasattr(response, "content"):
                     response_text = response.content
                elif isinstance(response, str):
                    response_text = response
                else:
                    print(f"Unexpected response type: {type(response)}")
                    continue 

                suggested_activities = response_text.splitlines()
                user_activities = []

                for i in range(6):
                    title = suggested_activities[i * 2].replace("Title: ", "").strip()
                    description = suggested_activities[i * 2 + 1].replace("Description: ", "").strip()
                    activity_data = Activity(title=title, description=description, status=ActivityStatus.NOT_DONE)
                    activity = create_activity_service(activity_data, db, user)
                    user_activities.append(activity)

                activities_for_all_users.append({
                    "user_id": user["id"],
                    "full_name": user["full_name"],
                    "activities": user_activities
                })

                print(f"Generated activities for all users at {datetime.now()}")
            except Exception as e:
                print(f"Error processing user {user['user_id']}: {e}")
        
        
        return activities_for_all_users
    
    except Exception as e:
        print(f"Error generating activities: {e}")
        return []


# scheduler = BackgroundScheduler()
# scheduler.add_job(generate_activities_custom_for_all_users, 'cron', hour=0, minute=0)
# scheduler.start()

def start_scheduler():
    scheduler = BackgroundScheduler(timezone="UTC")
    scheduler.add_job(generate_activities_custom_for_all_users, 'cron', hour=0, minute=0)
    scheduler.start()


# def shutdown_scheduler():
#     scheduler.shutdown()


def get_db_connection_check():
    # query = "How many users have signed up show  their username and email and list of activities for every user"
    query= "show all activities"
    result = db_chain.invoke(query)

    return {"status": "success", "data": result}

