class AppConstants {
  // App Info
  static const String appName = 'HealthTrack Wearable';
  static const String appVersion = '1.0.0';
  static const String userName = 'CHAABEN-Chahin';
  static const String projectChallenge = 'IEEE CSTAM2.0 Technical Challenge';

  // BLE Configuration
  static const String bleServiceUuid = '4fafc201-1fb5-459e-8fcc-c5c9c331914b';
  static const String bleCharacteristicUuid = 'beb5483e-36e1-4688-b7f5-ea07361b26a8';
  static const Duration bleScanTimeout = Duration(seconds: 10);
  static const Duration bleConnectionTimeout = Duration(seconds: 15);

  // Data Sync
  static const Duration defaultSyncInterval = Duration(seconds: 5);
  static const Duration cloudSyncInterval = Duration(minutes: 15);
  static const int maxOfflineRecords = 10000;

  // Health Thresholds
  static const int emergencyHRHigh = 200;
  static const int emergencyHRLow = 30;
  static const int criticalHRHigh = 180;
  static const int criticalHRLow = 40;
  static const int warningRestingHRHigh = 100;

  static const int emergencySpO2 = 80;
  static const int criticalSpO2 = 90;
  static const int warningSpO2 = 95;

  static const double criticalTempHigh = 39.0;
  static const double warningTempHigh = 37.5;
  static const double warningTempLow = 35.0;

  // Goals
  static const int defaultCalorieGoal = 2000;
  static const int defaultStepGoal = 10000;
  static const double defaultDistanceGoalKm = 8.0;
  static const int defaultActiveMinutesGoal = 30;

  // BMI Categories
  static const double bmiUnderweight = 18.5;
  static const double bmiNormal = 24.9;
  static const double bmiOverweight = 29.9;
  // Above 29.9 is obese

  // Weight Change Rates (kg/week)
  static const double weightChangeMild = 0.25;
  static const double weightChangeNormal = 0.5;
  static const double weightChangeExtreme = 1.0;

  // UI Constants
  static const double cardBorderRadius = 20.0;
  static const double buttonBorderRadius = 16.0;
  static const double cardPadding = 20.0;
  static const double screenPadding = 16.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Notification Channel
  static const String notificationChannelId = 'healthtrack_alerts';
  static const String notificationChannelName = 'Health Alerts';
  static const String notificationChannelDescription = 'Critical health notifications';

  // Storage Keys
  static const String keyAuthToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyUsername = 'username';
  static const String keyLastSync = 'last_sync';
  static const String keyMockMode = 'mock_mode';
  static const String keySyncInterval = 'sync_interval';
  static const String keyUnitsMetric = 'units_metric';
  
  // Session Types
  static const String sessionCardio = 'Cardio';
  static const String sessionStrength = 'Strength';
  static const String sessionYoga = 'Yoga';
  static const String sessionCustom = 'Custom';

  // Alert Severity
  static const String severityEmergency = 'EMERGENCY';
  static const String severityCritical = 'CRITICAL';
  static const String severityWarning = 'WARNING';
  static const String severityInfo = 'INFO';

  // Activity Levels
  static const String activitySedentary = 'sedentary';
  static const String activityLight = 'light';
  static const String activityModerate = 'moderate';
  static const String activityActive = 'active';
  static const String activityVeryActive = 'very_active';

  // Goal Types
  static const String goalMaintain = 'maintain';
  static const String goalLose = 'lose';
  static const String goalGain = 'gain';

  // Meal Types
  static const String mealBreakfast = 'breakfast';
  static const String mealLunch = 'lunch';
  static const String mealDinner = 'dinner';
  static const String mealSnack = 'snack';
}
