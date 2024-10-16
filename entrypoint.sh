#!/bin/sh

alembic upgrade head

python main.py

# uvicorn main:app --host 0.0.0.0 --port 8400 --reload


# if [ "$APP_ENV" = "dev" ]; then
#     # Use uvicorn with live reload for FastAPI in development
#     uvicorn main:app --host 0.0.0.0 --port 8400 --reload
# else
#     # For production, simply run the app without reloading
#     python main.py
# fi