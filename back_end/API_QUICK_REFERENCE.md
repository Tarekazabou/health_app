# Quick Reference - API Endpoints

Base URL: `http://localhost:8000/api/v1`

## Authentication (No Token Required)

### Signup
```bash
POST /auth/signup
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "SecurePass123",
  "username": "johndoe",
  "full_name": "John Doe"
}

Response: {
  "access_token": "eyJ0eXAiOiJKV1...",
  "token_type": "bearer",
  "user_id": "abc123",
  "email": "user@example.com",
  "username": "johndoe"
}
```

### Login
```bash
POST /auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "SecurePass123"
}

Response: Same as signup
```

## Authenticated Endpoints (Add Token Header)

```bash
Authorization: Bearer <your_access_token>
```

### Get User Profile
```bash
GET /users/me/profile

Response: {
  "user_id": "abc123",
  "age": 30,
  "gender": "male",
  "weight_kg": 75.5,
  "height_cm": 180,
  "daily_calorie_goal": 2000,
  "daily_step_goal": 10000,
  ...
}
```

### Update Profile
```bash
PUT /users/me/profile
Content-Type: application/json

{
  "age": 31,
  "weight_kg": 74.0,
  "daily_step_goal": 12000
}
```

### Sync Daily Vitals
```bash
POST /vitals/sync
Content-Type: application/json

{
  "date": "2025-11-17",
  "readings": [
    {
      "timestamp": 1700222400,
      "heart_rate": 72,
      "spo2": 98,
      "temperature": 36.6
    }
  ],
  "summary": {
    "avg_heart_rate": 75.2,
    "steps": 8543,
    "calories": 2100
  }
}
```

### Get Historical Vitals
```bash
GET /vitals/historical?days=7

Response: {
  "data": [
    {
      "date": "2025-11-17",
      "readings": [...],
      "summary": {...}
    }
  ],
  "days": 7,
  "start_date": "2025-11-11",
  "end_date": "2025-11-17"
}
```

### Sync Activity
```bash
POST /activities/sync

{
  "date": "2025-11-17",
  "steps": 10543,
  "distance_km": 7.2,
  "active_minutes": 45,
  "calories_burned": 450
}
```

### Create Session
```bash
POST /sessions

{
  "session_type": "running",
  "start_time": 1700222400,
  "end_time": 1700224200,
  "duration_seconds": 1800,
  "avg_heart_rate": 145,
  "calories_burned": 300
}
```

### Get Sessions
```bash
GET /sessions?days=30&limit=50
```

### Create Alert
```bash
POST /alerts

{
  "timestamp": 1700222400,
  "severity": "warning",
  "vital_type": "heart_rate",
  "message": "Heart rate above normal range",
  "vital_value": 125
}
```

### Get Alerts
```bash
GET /alerts?days=7
```

### Log Nutrition
```bash
POST /nutrition

{
  "timestamp": 1700222400,
  "meal_type": "breakfast",
  "calories": 450,
  "protein_g": 25,
  "carbs_g": 50,
  "fats_g": 15
}
```

## Flutter Integration Examples

### Initialize API Service
```dart
final apiService = ApiService();
```

### Login
```dart
try {
  final response = await apiService.login(
    'user@example.com',
    'SecurePass123',
  );
  print('Logged in: ${response['user_id']}');
} catch (e) {
  print('Error: $e');
}
```

### Get Profile
```dart
final profile = await apiService.getMyProfile();
await databaseService.syncProfileFromCloud(profile);
```

### Sync Vitals
```dart
final todayData = await databaseService.getTodayVitalsForSync();
await apiService.syncDailyVitals(
  date: todayData['date'],
  readings: todayData['readings'],
  summary: todayData['summary'],
);
```

### Get Historical Data
```dart
final vitals = await apiService.getHistoricalVitals(7);
// Store in local cache
for (var dayData in vitals) {
  await databaseService.cacheHistoricalVitals(dayData);
}
```

## Test with curl

```bash
# Signup
curl -X POST http://localhost:8000/api/v1/auth/signup \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"Test1234","username":"test","full_name":"Test User"}'

# Login
curl -X POST http://localhost:8000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"Test1234"}'

# Get Profile (replace TOKEN)
curl -X GET http://localhost:8000/api/v1/users/me/profile \
  -H "Authorization: Bearer TOKEN"
```

## Error Responses

```json
{
  "success": false,
  "error": "Error message here",
  "detail": "Additional details"
}
```

Common status codes:
- 200: Success
- 201: Created
- 400: Bad request
- 401: Unauthorized (invalid token)
- 404: Not found
- 422: Validation error
- 500: Server error

## Interactive Documentation

Visit: http://localhost:8000/docs

Try all endpoints with built-in Swagger UI!
