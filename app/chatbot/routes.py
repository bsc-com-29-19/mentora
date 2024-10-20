from fastapi import APIRouter,Depends, WebSocket, WebSocketDisconnect
from .services import stream_chat_session,stream_chat_session_websocket
from dependencies import get_db,get_current_user
from sqlalchemy.orm import Session
from app.auth.models import User

chat_router = APIRouter()


@chat_router.post("/chat/{session_id}")
async def chatbot(session_id: str, user_message: str,db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    response_stream = stream_chat_session(session_id, user_message)
    response = "".join([token for token in response_stream])
    return {"response": response}


@chat_router.websocket("/ws/chat/{session_id}")
async def websocket_endpoint(websocket: WebSocket, session_id: str, db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    await websocket.accept()

    try:
        while True:
            user_message = await websocket.receive_text()
            response_stream = stream_chat_session_websocket(session_id, user_message)

            async for token in response_stream:
                await websocket.send_text(token)

    except WebSocketDisconnect:
        print(f"Client {session_id} disconnected")
