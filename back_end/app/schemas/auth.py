from pydantic import BaseModel, EmailStr
from typing import Optional

class SignupRequest(BaseModel):
    email: EmailStr
    password: str
    username: str
    full_name: str

class LoginRequest(BaseModel):
    email: EmailStr
    password: str

class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user_id: str
    email: str
    username: str

class RefreshTokenRequest(BaseModel):
    refresh_token: str
