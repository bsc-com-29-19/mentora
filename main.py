import uvicorn
from fastapi import FastAPI, Response
from typing import Dict
from database import Base,engine
from app.auth.routes import user_router
from app.journal.routes import journal_router
from app.chatbot.routes import chat_router
from app.activities.routes import activity_router



# Mentora metadata
app =  FastAPI(
    title="Mentora Backend App",
    description="Backend of Mentora : An AI powered mental health companion app",

    summary="API endpoints for mental health journaling,therapist chatbot,activity generation,Statistics, and user management",
    contact={
        "name": "Tony Kanyamuka",
        "url": "https://www.Mentora.com",
        "email": "tonykanyamuka@icloud.com",
        "phone": "+265996008328"
    },
    license_info={
        "name": "MIT License",
        "url": "https://opensource.org/licenses/MIT"
    },
    version="v1"
)

Base.metadata.create_all(bind=engine)


# root endpoint
@app.get("/")
def mentora_root():
    return {
        "message": "Welcome to Mentora Backend App",
        "documentation": "add '/docs' to the url"
    }

# endpoint to check mentora health 
@app.get("/health/check")
def mentora_detailed_health_check():
    health_status = {
        "app": True,
        "database": check_database_connection(),
        "dependencies": check_dependencies()
    }
    
    if all(health_status.values()):
        return {"status": "healthy"}
    else:
        return Response(content={"status": "unhealthy"}, media_type="application/json", status_code=503)


# The routes for users,journals,chatbot,activities

app.include_router(user_router,prefix='/users',tags=["AUTH"])
app.include_router(journal_router,prefix="/journals",tags=["JOURNALS"])
app.include_router(chat_router,prefix="/chatbot",tags=["CHATBOT"])
app.include_router(activity_router,prefix="/activities",tags=["ACTIVITIES"])


# function to check database connection
def check_database_connection():
    # database connection check
    #
    return True


def check_dependencies():
    # dependency check
    return True




if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8400,reload=True)