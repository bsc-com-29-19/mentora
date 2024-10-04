from app.auth.models import User


def test_create_user():
    user = User(username= "user",email="user@email.com",hashed_password="password")
    assert user.username == "user"
    assert user.email == "user@email.com"
    assert user.hash_password == "password"
    