# HealthTrack - Full Stack Setup Guide

Complete health monitoring system with Flutter frontend and FastAPI backend.

## 📁 Project Structure

```
full_project/
├── front_end/          # Flutter mobile app (existing, fully functional)
│   └── lib/
│       ├── services/
│       │   ├── database_service.dart    # Local SQLite
│       │   └── api_service.dart         # NEW: Cloud API client
│       └── ...
│
├── back_end/           # FastAPI backend (NEW)
│   ├── app/
│   │   ├── api/v1/     # REST endpoints
│   │   ├── models/     # Data models
│   │   ├── services/   # Business logic
│   │   └── main.py     # App entry
│   ├── requirements.txt
│   ├── .env            # Configuration
│   └── start.bat       # Quick start script
│
└── README.md           # This file
```

## 🚀 Quick Start

### Backend Setup (5 minutes)

1. **Install Python dependencies:**
   ```bash
   cd back_end
   pip install -r requirements.txt
   ```

2. **Configure environment (optional):**
   ```bash
   # Backend works in demo mode without Firebase
   # To enable Firebase, edit .env with your credentials
   ```

3. **Start the API server:**
   ```bash
   # Windows
   start.bat
   
   # Mac/Linux
   chmod +x start.sh
   ./start.sh
   ```

4. **Verify API is running:**
   - Open: http://localhost:8000/docs
   - You should see interactive API documentation

### Frontend Setup (Already Working)

The Flutter app is already fully functional with local SQLite. No changes needed to run it locally.

**To add cloud sync:**
1. Open `lib/services/api_service.dart` (already created)
2. Update `baseUrl` if needed (default: `http://localhost:8000/api/v1`)
3. Implement login screen integration (see below)

## 🔄 Data Flow Architecture

### Current State (Local Only)
```
Wearable → BLE → Flutter → SQLite → UI
```

### New State (With Cloud Sync)
```
1. Login:
   Flutter → API → Get Profile → Store in SQLite

2. Real-time (Today):
   Wearable → BLE → Flutter → SQLite → UI
   (Everything stays local)

3. End of Day (11:59 PM):
   SQLite → API → Firebase
   (Background sync of today's data)

4. Historical (7-day/30-day):
   User Request → API → Firebase → Cache in SQLite → Display
```

## 🔐 Authentication Flow

### 1. Signup
```dart
// In signup_screen.dart
final apiService = ApiService();

try {
  final response = await apiService.signup(
    email: emailController.text,
    password: passwordController.text,
    username: usernameController.text,
    fullName: fullNameController.text,
  );
  
  // Token is automatically stored
  // Fetch and cache profile
  final profile = await apiService.getMyProfile();
  await databaseService.syncProfileFromCloud(profile);
  
  Navigator.pushReplacementNamed(context, '/home');
} catch (e) {
  // Show error
  showSnackBar(e.toString());
}
```

### 2. Login
```dart
// In login_screen.dart
try {
  final response = await apiService.login(
    emailController.text,
    passwordController.text,
  );
  
  // Fetch profile
  final profile = await apiService.getMyProfile();
  await databaseService.syncProfileFromCloud(profile);
  
  Navigator.pushReplacementNamed(context, '/home');
} catch (e) {
  showSnackBar('Invalid email or password');
}
```

## 📊 Cloud Sync Implementation

### Add to database_service.dart

```dart
// Store profile from cloud after login
Future<void> syncProfileFromCloud(Map<String, dynamic> profileData) async {
  final db = await database;
  
  await db.insert(
    'user_profile',
    {
      'id': 1,
      'age': profileData['age'],
      'gender': profileData['gender'],
      'weight_kg': profileData['weight_kg'],
      'height_cm': profileData['height_cm'],
      'daily_calorie_goal': profileData['daily_calorie_goal'],
      'daily_step_goal': profileData['daily_step_goal'],
      'daily_distance_goal': profileData['daily_distance_goal'],
      'daily_active_minutes_goal': profileData['daily_active_minutes_goal'],
      'daily_protein_goal': profileData['daily_protein_goal'],
      'daily_carbs_goal': profileData['daily_carbs_goal'],
      'daily_fats_goal': profileData['daily_fats_goal'],
      // ... other fields
    },
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

// Prepare today's data for end-of-day sync
Future<Map<String, dynamic>> getTodayVitalsForSync() async {
  final db = await database;
  String today = DateTime.now().toIso8601String().split('T')[0];
  
  // Get all vitals from today
  final vitals = await db.query(
    'vital_signs',
    where: 'DATE(timestamp/1000, "unixepoch") = ?',
    whereArgs: [today],
  );
  
  // Calculate summary
  int totalHR = 0, countHR = 0;
  int steps = 0; // Get from wellness_metrics
  
  for (var v in vitals) {
    if (v['heart_rate'] != null) {
      totalHR += v['heart_rate'] as int;
      countHR++;
    }
  }
  
  return {
    'date': today,
    'readings': vitals.map((v) => {
      'timestamp': v['timestamp'],
      'heart_rate': v['heart_rate'],
      'spo2': v['spo2'],
      'temperature': v['temperature'],
      // ... other fields
    }).toList(),
    'summary': {
      'avg_heart_rate': countHR > 0 ? totalHR / countHR : null,
      'steps': steps,
      'calories': 0, // Calculate from metrics
      // ... other summary fields
    }
  };
}
```

### Background Sync Job

Add to `pubspec.yaml` (already has workmanager):
```yaml
dependencies:
  workmanager: ^0.5.2
```

Create `lib/services/sync_service.dart`:
```dart
import 'package:workmanager/workmanager.dart';
import 'api_service.dart';
import 'database_service.dart';

class SyncService {
  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher);
    
    // Schedule daily sync at 11:59 PM
    await Workmanager().registerPeriodicTask(
      "daily-sync",
      "syncDailyData",
      frequency: const Duration(hours: 24),
      initialDelay: _calculateDelayUntilMidnight(),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }
  
  static Duration _calculateDelayUntilMidnight() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day, 23, 59);
    return midnight.difference(now);
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == "syncDailyData") {
      try {
        final apiService = ApiService();
        final dbService = DatabaseService();
        
        // Get today's data
        final vitalsData = await dbService.getTodayVitalsForSync();
        
        // Upload to cloud
        await apiService.syncDailyVitals(
          date: vitalsData['date'],
          readings: vitalsData['readings'],
          summary: vitalsData['summary'],
        );
        
        return Future.value(true);
      } catch (e) {
        print('Sync failed: $e');
        return Future.value(false);
      }
    }
    return Future.value(true);
  });
}
```

Initialize in `main.dart`:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize background sync
  await SyncService.initialize();
  
  runApp(MyApp());
}
```

## 🔍 Testing the Integration

### 1. Start Backend
```bash
cd back_end
start.bat
```

### 2. Test API (Postman/curl)
```bash
# Signup
curl -X POST http://localhost:8000/api/v1/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "Test1234",
    "username": "testuser",
    "full_name": "Test User"
  }'

# Login
curl -X POST http://localhost:8000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "Test1234"
  }'

# Get Profile (use token from login)
curl -X GET http://localhost:8000/api/v1/users/me/profile \
  -H "Authorization: Bearer <your_token>"
```

### 3. Test from Flutter
- Add login screen
- Call API on login
- Verify profile stored in SQLite
- Check data syncs at midnight

## 📝 API Endpoints

All endpoints available at: http://localhost:8000/docs

### Authentication
- `POST /api/v1/auth/signup` - Register
- `POST /api/v1/auth/login` - Login

### User
- `GET /api/v1/users/me/profile` - Get profile
- `PUT /api/v1/users/me/profile` - Update profile

### Vitals
- `POST /api/v1/vitals/sync` - Upload day's data
- `GET /api/v1/vitals/historical?days=7` - Get history

### Activities
- `POST /api/v1/activities/sync` - Upload activity
- `GET /api/v1/activities/historical?days=7` - Get history

### Sessions
- `POST /api/v1/sessions` - Log workout
- `GET /api/v1/sessions?days=30` - Get workouts

### Alerts
- `POST /api/v1/alerts` - Create alert
- `GET /api/v1/alerts?days=7` - Get alerts

### Nutrition
- `POST /api/v1/nutrition` - Log meal
- `GET /api/v1/nutrition?days=30` - Get entries

## 🔧 Configuration

### Backend (.env file)
```env
SECRET_KEY=your-secret-key
FIREBASE_PROJECT_ID=your-project-id
# ... (see .env.example for all options)
```

### Frontend (api_service.dart)
```dart
static const String baseUrl = 'http://localhost:8000/api/v1';
// For deployed backend: 'https://your-api.com/api/v1'
```

## 🚨 Important Notes

✅ **Demo Mode**: Backend works without Firebase (uses mock data)
✅ **Local First**: App works fully offline with local SQLite
✅ **Cloud Sync**: Optional feature for multi-user support
✅ **Security**: JWT tokens stored in flutter_secure_storage
✅ **Background Jobs**: Workmanager handles end-of-day sync

## 🎯 Next Steps

1. ✅ Backend is ready (demo mode)
2. ✅ API service is created
3. 🔲 Add login/signup screens to Flutter
4. 🔲 Implement profile sync after login
5. 🔲 Add background sync job
6. 🔲 Test full flow
7. 🔲 Setup Firebase for production
8. 🔲 Deploy backend to cloud

## 📚 Documentation

- Backend API: http://localhost:8000/docs
- Backend README: `back_end/README.md`
- Flutter services: `front_end/lib/services/`

## 🆘 Troubleshooting

**Backend won't start:**
- Check Python installed: `python --version`
- Install dependencies: `pip install -r requirements.txt`
- Check port 8000 is free

**Flutter can't connect:**
- Check backend is running at http://localhost:8000
- Update baseUrl in api_service.dart
- Check network permissions

**Firebase errors:**
- Backend works in demo mode without Firebase
- Add credentials to .env to enable Firebase

## 📞 Support

Check logs:
- Backend: Terminal output
- Flutter: Android Studio/VS Code console

The system is designed to work locally first, with cloud sync as an optional enhancement!
