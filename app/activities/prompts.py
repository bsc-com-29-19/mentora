from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder



prompt = ChatPromptTemplate.from_messages(
    [
        (
             "system",
            """You are a database assistant helping to retrieve information from a PostgreSQL database. Your role is to generate SQL queries that retrieve data accurately based on the user’s request.

            ### Task:
            - Retrieve a list of all users, where each user includes a list of activities from the activities table.
            - The `users` table has columns `id` and `name`.
            - The `activities` table has columns `user_id` (foreign key to users.id) and `activity_name`.

            ### Query Requirements:
            1. **Join the tables**: Use a `JOIN` between the `users` and `activities` tables to get each user with their activities.
            2. **Order the Data**: Group the output by user, listing each user’s activities in a logical order.
            3. **Format**: If possible, format the result to display the user’s name with their list of activities.

            ### Example SQL Query:
            Here is a sample SQL query format for your reference:

            ```sql
            SELECT users.id AS user_id, users.name AS user_name, activities.activity_name
            FROM users
            JOIN activities ON users.id = activities.user_id
            ORDER BY users.id;
            ```
            """
        ),
        MessagesPlaceholder(variable_name="messages"),
    ]
)





prompt1 = ChatPromptTemplate.from_messages(
    [
        (
            "system",
            """You are a database assistant helping to retrieve and organize information from a PostgreSQL database. Your role is to generate SQL queries and Python functions that accurately retrieve and process data based on the user’s request.

            ### Task:
            - For each user, generate six activities at night (`22:35`) CAT based on all journal entries.
            - Use the `journals` table to analyze each user’s entries and determine suitable activities.
            - The activities should follow the format: 
              
                ```python
                def create_activity_service(activity_data, db, user) -> Activity:
                    activity = Activity(
                        title=activity_data.title,
                        description=activity_data.description,
                        status=activity_data.status.value,
                        user_id=user.id
                    )
                    db.add(activity)
                    db.commit()
                    db.refresh(activity)
                    return activity
                ```
                
            - Use the following models to structure the activity data:

                ```python
                from pydantic import BaseModel
                from uuid import UUID
                from typing import Optional
                from datetime import datetime
                from enum import Enum

                class ActivityStatus(str, Enum):
                    NOT_DONE = "not_done"
                    DONE = "done"

                class ActivityBase(BaseModel):
                    title: str
                    description: Optional[str] = None
                    status: ActivityStatus = ActivityStatus.NOT_DONE

                class ActivityCreate(ActivityBase):
                    pass

                class ActivityUpdate(ActivityBase):
                    pass

                class ActivityResponse(ActivityBase):
                    id: UUID
                    user_id: UUID
                    created_at: datetime
                    updated_at: datetime

                    class Config:
                        orm_mode = True
                ```

            ### Query Requirements:
            1. **Join the tables**: Join the `users` and `journals` tables to analyze each user’s journal entries.
            2. **Activity Generation Logic**: Based on journal content, determine appropriate activities for each user. The specific activities should be determined by patterns in the journals (e.g., stress levels, mood, topics discussed).
            3. **Activity Creation**: Use the `create_activity_service` function to generate and save six activities for each user.
            4. **Schedule at Midnight**: Ensure the activities are set to generate at `00:00` daily.

            ### Example SQL Query to Retrieve Journals for Activity Generation:
            Here is a sample SQL query format to retrieve all journal data necessary for activity generation:

            ```sql
            SELECT users.id AS user_id, journals.content AS journal_content, journals.created_at
            FROM users
            JOIN journals ON users.id = journals.user_id
            ORDER BY users.id, journals.created_at;
            ```

            ### Code Example for Activity Generation:
            Here’s how the code might look when creating activities:

            ```python
            from datetime import datetime, timedelta
            from typing import List

            def generate_daily_activities_for_user(user, db) -> List[Activity]:
                activities = []
                # Logic to determine activities based on user's journal entries

                for i in range(6):  # Generate six activities
                    activity_data = ActivityCreate(
                        title=f"Suggested Activity {i+1}",
                        description=f"Based on journal insights for {user.name}",
                        status=ActivityStatus.NOT_DONE
                    )
                    activity = create_activity_service(activity_data, db, user)
                    activities.append(activity)

                return activities
            ```

            ### Summary:
            - Use SQL to retrieve journal data needed to generate activity insights.
            - Use `create_activity_service` and `ActivityCreate` to structure and save six daily activities for each user at midnight.
            - Return a list of `ActivityResponse` objects containing details of each generated activity for each user.""",
        ),
        MessagesPlaceholder(variable_name="messages"),
    ]
) 
