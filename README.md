## <a name="description">Project Overview: Mentora AI-Powered Mental Health Companion</a>

An AI-driven Backend application using FastAPI, Postgres, Redis, and Docker, featuring:
Mental health journaling,
Therapist chatbot,
Resource library,
Activity generation,
Ensuring secure and scalable mental wellness management.

## <a name="tech-stack">Tech Stack</a>

- FastAPI (Backend)
- Postgres (Database)
- Redis (Caching)
- Docker (Containerization)
- Langchain
- ChromaDB
- Custom JWT Authentication

## <a name="features">Features</a>

- Mental Health Journaling
- Therapist Chatbot
- Activity Generation
- Mood Tracking
- Reflection and Insights Statistics

## <a name="endpoints">API EndPoints</a>

### Journal Endpoints

- POST /journals - Create a new journal entry
- GET /journals - Retrieve all journal entries
- GET /journals/{id} - Retrieve a journal entry by ID
- PATCH /journals/{id} - Update a journal entry

### Therapist Chatbot Endpoints

- POST /chat - Initiate a chat session
- GET /chat/{id} - Retrieve chat session history
- POST /chat/{id}/message - Send a message to the therapist chatbot

### Activity Endpoints

- GET /activities - Retrieve AI-generated activities
- POST /activities - Create a new activity log
- PATCH /activities/{id} - Update an existing activity log

### Stats Endpoints

- GET /stats - Retrieve user's comprehensive statistics (mood, reflections, trends, and insights)

### User Endpoints

- POST /register - Register a new user
- POST /login - Login a user
- GET /profile - Retrieve user profile
- PATCH /profile - Update user profile
- POST /password/reset - Reset password

## License

- This Project is Lincensed under MIT <a href="https://opensource.org/licenses/MIT">License</a>
