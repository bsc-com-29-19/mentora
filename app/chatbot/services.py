from dotenv import load_dotenv
from langchain_openai import ChatOpenAI
from langchain_core.messages import HumanMessage
from langchain_core.chat_history import BaseChatMessageHistory, InMemoryChatMessageHistory
from langchain_core.runnables.history import RunnableWithMessageHistory
from .prompts import prompt

load_dotenv()

# Initialize the model
model = ChatOpenAI(model="gpt-3.5-turbo")




# In-memory storage for session histories
store = {}

# Function to retrieve session history
def get_session_history(session_id: str) -> BaseChatMessageHistory:
    if session_id not in store:
        store[session_id] = InMemoryChatMessageHistory()
    return store[session_id]

# Initialize the chain
chain = prompt| model

# Function to handle chat session with message history
def stream_chat_session(session_id: str, user_message: str):
    config = {"configurable": {"session_id": session_id}}
    with_message_history = RunnableWithMessageHistory(
        chain, get_session_history, input_messages_key="messages"
    )
    
    # Stream the response token by token
    for r in with_message_history.stream(
        {
            "messages": [HumanMessage(content=user_message)],
            "language": "English",
        },
        config=config,
    ):
        yield r.content  # Yield the token to allow real-time streaming



async def stream_chat_session_websocket(session_id: str, user_message: str):
    config = {"configurable": {"session_id": session_id}}
    with_message_history = RunnableWithMessageHistory(
        chain, get_session_history, input_messages_key="messages"
    )
    
    async for r in with_message_history.stream(
        {
            "messages": [HumanMessage(content=user_message)],
            "language": "English",
        },
        config=config,
    ):
        yield r.content  # Yield the token for real-time streaming

