import firebase_admin
from firebase_admin import credentials
from app.config import get_settings
import json
import os

settings = get_settings()

def initialize_firebase():
    """Initialize Firebase Admin SDK"""
    if firebase_admin._apps:
        return  # Already initialized
    
    try:
        # Try to load from credentials file if path provided
        if settings.FIREBASE_CREDENTIALS_PATH and os.path.exists(settings.FIREBASE_CREDENTIALS_PATH):
            cred = credentials.Certificate(settings.FIREBASE_CREDENTIALS_PATH)
        else:
            # Use environment variables to construct credentials
            cred_dict = {
                "type": "service_account",
                "project_id": settings.FIREBASE_PROJECT_ID,
                "private_key_id": settings.FIREBASE_PRIVATE_KEY_ID,
                "private_key": settings.FIREBASE_PRIVATE_KEY.replace('\\n', '\n') if settings.FIREBASE_PRIVATE_KEY else "",
                "client_email": settings.FIREBASE_CLIENT_EMAIL,
                "client_id": settings.FIREBASE_CLIENT_ID,
                "auth_uri": settings.FIREBASE_AUTH_URI,
                "token_uri": settings.FIREBASE_TOKEN_URI,
            }
            cred = credentials.Certificate(cred_dict)
        
        firebase_admin.initialize_app(cred)
        print("✅ Firebase initialized successfully")
    except Exception as e:
        print(f"⚠️  Firebase initialization skipped: {e}")
        print("   App will work in demo mode without Firebase")
