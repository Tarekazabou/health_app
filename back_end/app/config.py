from pydantic_settings import BaseSettings
from functools import lru_cache
from typing import List

class Settings(BaseSettings):
    # App
    APP_NAME: str = "HealthTrack API"
    VERSION: str = "1.0.0"
    DEBUG: bool = True
    
    # Security
    SECRET_KEY: str = "your-secret-key-change-in-production"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 7  # 7 days
    
    # Firebase
    FIREBASE_PROJECT_ID: str = ""
    FIREBASE_PRIVATE_KEY_ID: str = ""
    FIREBASE_PRIVATE_KEY: str = ""
    FIREBASE_CLIENT_EMAIL: str = ""
    FIREBASE_CLIENT_ID: str = ""
    FIREBASE_AUTH_URI: str = "https://accounts.google.com/o/oauth2/auth"
    FIREBASE_TOKEN_URI: str = "https://oauth2.googleapis.com/token"
    FIREBASE_CREDENTIALS_PATH: str = ""  # Path to service account JSON file
    
    # CORS - Allow all origins for development
    ALLOWED_ORIGINS: str = "*"
    
    class Config:
        env_file = ".env"
        extra = "allow"

@lru_cache()
def get_settings():
    return Settings()
