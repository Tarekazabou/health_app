# HealthTrack Backend API

FastAPI backend for HealthTrack multi-user health monitoring application with cloud sync capabilities.

## Features

- 🔐 **User Authentication**: JWT-based auth with Firebase
- 👤 **User Profiles**: Personal health information and goals
- 💓 **Vitals Tracking**: Heart rate, SpO2, temperature data
- 🏃 **Activity Monitoring**: Steps, distance, calories, sessions
- ⚠️ **Health Alerts**: Automated health warnings
- 🍎 **Nutrition Logging**: Meal tracking with macros
- ☁️ **Cloud Sync**: End-of-day data synchronization
- 📊 **Historical Data**: 7-day and 30-day analytics

## Architecture

### Data Flow
- **User Profile**: Fetched on login → Stored locally → Synced on changes
- **Today's Data**: Processed locally → Uploaded at 11:59 PM
- **Historical Data**: On-demand fetch → Cached locally → Used for analytics

### Tech Stack
- **Framework**: FastAPI 0.109.0
- **Database**: Firebase Firestore
- **Authentication**: JWT + Firebase Auth
- **Security**: bcrypt password hashing

## Setup

### 1. Install Dependencies

```bash
cd back_end
pip install -r requirements.txt
```

### 2. Configure Firebase

Option A: Use Service Account JSON
```bash
# Download serviceAccountKey.json from Firebase Console
# Place it in back_end/ directory
# Set path in .env:
FIREBASE_CREDENTIALS_PATH=serviceAccountKey.json
```

Option B: Use Environment Variables
```bash
# Copy .env.example to .env
cp .env.example .env

# Fill in Firebase credentials from Firebase Console > Project Settings
```

### 3. Run the Server

```bash
# Development mode
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

# Production mode
uvicorn app.main:app --host 0.0.0.0 --port 8000
```

### 4. Test the API

Visit: http://localhost:8000/docs for interactive API documentation

## API Endpoints

### Authentication
- `POST /api/v1/auth/signup` - Register new user
- `POST /api/v1/auth/login` - Login and get JWT token
- `POST /api/v1/auth/logout` - Logout (client-side)

### User Profile
- `GET /api/v1/users/me/profile` - Get user profile
- `PUT /api/v1/users/me/profile` - Update user profile
- `GET /api/v1/users/me` - Get basic user info

### Vitals
- `POST /api/v1/vitals/sync` - Sync daily vitals (end of day)
- `GET /api/v1/vitals/historical?days=7` - Get historical vitals
- `GET /api/v1/vitals/date/{date}` - Get vitals for specific date

### Activities
- `POST /api/v1/activities/sync` - Sync daily activity
- `GET /api/v1/activities/historical?days=7` - Get historical activity

### Sessions
- `POST /api/v1/sessions` - Create workout session
- `GET /api/v1/sessions?days=30` - Get recent sessions

### Alerts
- `POST /api/v1/alerts` - Create health alert
- `GET /api/v1/alerts?days=7` - Get recent alerts
- `POST /api/v1/alerts/{id}/acknowledge` - Acknowledge alert

### Nutrition
- `POST /api/v1/nutrition` - Log meal/snack
- `GET /api/v1/nutrition?days=30` - Get nutrition history
- `POST /api/v1/nutrition/analyze` - AI food analysis (coming soon)

## Authentication

All endpoints except `/auth/signup` and `/auth/login` require authentication.

Include JWT token in requests:
```
Authorization: Bearer <your_jwt_token>
```

## Firebase Firestore Structure

```
/users/{userId}
  - email, password_hash, username, full_name
  - created_at, last_login

/users/{userId}/profile/data
  - age, gender, weight_kg, height_cm
  - health conditions, goals, daily targets

/users/{userId}/daily_vitals/{date}
  - readings: [{timestamp, hr, spo2, temp, ...}]
  - summary: {avg_hr, steps, calories, wellness_score}

/users/{userId}/daily_activities/{date}
  - steps, distance_km, active_minutes, calories_burned
  - hourly_breakdown

/users/{userId}/sessions/{sessionId}
  - session_type, start_time, duration, vitals

/users/{userId}/alerts/{alertId}
  - timestamp, severity, vital_type, message

/users/{userId}/nutrition/{entryId}
  - timestamp, meal_type, calories, macros
```

## Demo Mode

The backend can run in **demo mode** without Firebase:
- Authentication uses mock data
- All API endpoints work but data isn't persisted
- Useful for development and testing

To enable demo mode: Leave Firebase credentials empty in `.env`

## Flutter Integration

See `front_end/lib/services/api_service.dart` for example integration.

### Login Flow
```dart
// 1. Login
final response = await apiService.login(email, password);

// 2. Store token
await storage.write(key: 'access_token', value: response['access_token']);

// 3. Fetch profile
final profile = await apiService.getMyProfile();

// 4. Store in local SQLite
await databaseService.syncProfileFromCloud(profile);
```

### End of Day Sync
```dart
// Scheduled at 11:59 PM
final todayData = await databaseService.getTodayVitalsForSync();
await apiService.syncDailyVitals(
  todayData['date'],
  todayData['readings'],
  todayData['summary']
);
```

## Development

### Project Structure
```
back_end/
├── app/
│   ├── api/v1/          # API route handlers
│   ├── models/          # Pydantic data models
│   ├── schemas/         # Request/response schemas
│   ├── services/        # Business logic
│   ├── middleware/      # Error handlers
│   ├── utils/           # Helper functions
│   ├── config.py        # Configuration
│   ├── dependencies.py  # Auth dependencies
│   └── main.py          # FastAPI app
├── tests/               # Unit tests
├── requirements.txt     # Python dependencies
├── .env                 # Environment variables
└── README.md           # This file
```

### Adding New Endpoints
1. Create schema in `app/schemas/`
2. Add business logic in `app/services/firebase_service.py`
3. Create route in `app/api/v1/`
4. Register router in `app/main.py`

## Deployment

### Docker
```bash
docker build -t healthtrack-api .
docker run -p 8000:8000 --env-file .env healthtrack-api
```

### Cloud Platforms
- Deploy to Google Cloud Run, AWS Lambda, Azure Functions
- Ensure Firebase credentials are set via environment variables
- Use production-grade SECRET_KEY

## Security Notes

⚠️ **Important**:
- Change `SECRET_KEY` in production
- Use strong passwords (enforced by validation)
- Enable HTTPS in production
- Store JWT tokens securely on client (flutter_secure_storage)
- Implement rate limiting for production
- Set proper CORS origins

## License

Private - HealthTrack Project

## Support

For issues or questions, contact the development team.
