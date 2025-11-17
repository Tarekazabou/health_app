# ⚡ Quick Setup Guide

## Prerequisites Checklist
- [ ] Flutter SDK installed (v3.0+)
- [ ] Android Studio or VS Code
- [ ] Android SDK configured
- [ ] Device/Emulator ready

## 🚀 5-Minute Setup

### 1. Get Dependencies
```bash
cd mobile_app_3
flutter pub get
```

### 2. Download Fonts (REQUIRED)
Visit [Google Fonts](https://fonts.google.com/) and download:

**Poppins:**
- Regular, Medium, SemiBold, Bold

**Inter:**
- Regular, Medium, SemiBold

Place `.ttf` files in: `fonts/` directory

### 3. Run the App
```bash
flutter run
```

### 4. Test Login
Since database starts empty, tap "Sign Up" to create account:
- Username: `test_user`
- Email: `test@example.com`
- Password: `password123`

## 🎯 What Works Out of the Box

✅ **Working Features:**
- Login/Logout authentication
- Password hashing (SHA-256)
- SQLite database with all tables
- Mock sensor data generation (no hardware needed)
- Health alert engine with thresholds
- Local notifications
- Gradient UI components
- Custom themed widgets

✅ **Test Without Hardware:**
Mock mode is enabled by default. The app generates realistic:
- Heart rate (varies by time of day)
- SpO2 readings
- Temperature
- Motion data (accelerometer/gyro)

## 📱 Current Screens
- **Login Screen** - Full gradient design ✅
- Home Screen - TODO
- Other screens - TODO (see TODO.md)

## 🐛 Common First-Run Issues

### Error: "Font not found"
**Solution:** Download fonts and place in `fonts/` directory

### Error: "Database error"
**Solution:** App creates database automatically. If issues persist:
```bash
flutter clean
flutter pub get
flutter run
```

### Error: "Unhandled exception"
**Solution:** Most likely missing fonts. Check console for specific error.

## 🧪 Testing Mock Data

The app automatically uses mock data. To test specific scenarios:

```dart
// In any screen or service
final mockService = MockDataService();

// Start normal data stream
mockService.startGeneratingData();

// Or trigger specific test
mockService.generateCriticalHeartRate(); // HR > 180
mockService.generateLowSpO2();           // SpO2 < 90
mockService.generateHighFever();         // Temp > 39°C
```

## 📊 Database Inspection

To view database during development:

**Android:**
```bash
adb shell
cd /data/data/com.example.healthtrack_wearable/databases
sqlite3 healthtrack.db
```

**iOS:**
Use Xcode's App Container viewer

## 🔑 Test Credentials

After creating your first account, you can login with those credentials. The app supports:
- Login with username OR email
- Password validation
- Secure credential storage

## 🎨 Customization Points

Want to modify the design?

**Colors:** `lib/core/theme/app_colors.dart`
**Typography:** `lib/core/theme/text_styles.dart`
**Theme:** `lib/core/theme/app_theme.dart`
**Constants:** `lib/core/constants/constants.dart`

## 📁 Key Files to Understand

Start here:
1. `lib/main.dart` - App entry point
2. `lib/services/auth_service.dart` - Authentication logic
3. `lib/services/mock_data_service.dart` - Test data generation
4. `lib/services/database_service.dart` - Data persistence
5. `lib/screens/auth/login_screen.dart` - Example screen

## 🔄 Development Workflow

Recommended order:
1. ✅ Run the app (login works)
2. Create HomeScreen next (highest priority)
3. Add providers for state management
4. Connect mock data to UI
5. Build remaining screens one by one

See `TODO.md` for detailed implementation plan.

## 💡 Pro Tips

**Hot Reload Works:**
Press `r` in terminal for fast refresh while developing

**Debug Mode:**
Enable debug mode to see console logs:
```dart
// In services, look for print() statements
```

**Mock Data Patterns:**
Mock service simulates realistic daily patterns:
- Lower HR during sleep hours (10 PM - 6 AM)
- Higher HR during typical exercise times
- Gradual battery drain

## 🆘 Need Help?

1. Check `README.md` for full documentation
2. Review `TODO.md` for implementation guide
3. Check code comments in service files
4. Examine existing widgets for examples

## 📦 Dependencies Already Configured

All packages are in `pubspec.yaml`:
- Flutter Blue Plus (Bluetooth)
- Sqflite (Database)
- Provider (State management)
- FL Chart (Charts)
- Google Fonts (Typography)
- And more...

Just run `flutter pub get` and you're ready!

---

**First time with Flutter?**
Check out: https://docs.flutter.dev/get-started

**Ready to continue?**
Open `TODO.md` for next steps!
