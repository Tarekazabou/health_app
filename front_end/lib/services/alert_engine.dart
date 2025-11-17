import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/alert.dart';
import '../models/vital_sign.dart';
import '../models/user.dart';
import '../core/constants/constants.dart';
import 'database_service.dart';
import 'notification_service.dart';

class AlertEngine {
  // Singleton pattern to ensure all providers share the same instance
  static AlertEngine? _instance;
  
  factory AlertEngine() {
    _instance ??= AlertEngine._internal();
    return _instance!;
  }
  
  AlertEngine._internal();

  final DatabaseService _db = DatabaseService();
  final NotificationService _notificationService = NotificationService();
  final Uuid _uuid = const Uuid();

  // Stream for notifying when new alerts are created
  final StreamController<Alert> _alertCreatedController = StreamController<Alert>.broadcast();
  Stream<Alert> get alertCreatedStream => _alertCreatedController.stream;

  // User age for context-aware alerts (should be fetched from profile)
  int _userAge = 30;
  String? _activityType = 'RESTING';
  
  // Track alert cooldown to avoid spam
  final Map<String, DateTime> _lastAlertTime = {};
  final Duration _alertCooldown = const Duration(minutes: 5);

  void setUserAge(int age) {
    _userAge = age;
  }

  void setActivityType(String type) {
    _activityType = type;
  }
  
  /// Check if alert should be triggered (considering cooldown)
  bool _shouldTriggerAlert(Alert alert) {
    final key = '${alert.vitalType}_${alert.severity}';
    final lastTime = _lastAlertTime[key];

    if (lastTime == null) return true;

    // For emergencies, always trigger
    if (alert.severity == AppConstants.severityEmergency) return true;

    // For others, respect cooldown
    return DateTime.now().difference(lastTime) >= _alertCooldown;
  }

  // Main function to check vitals and generate alerts
  Future<List<Alert>> checkVitals(VitalSign vitalSign, UserProfile? profile) async {
    final alerts = <Alert>[];

    if (profile != null && profile.age != null) {
      _userAge = profile.age!;
    }

    // Check heart rate
    if (vitalSign.heartRate != null) {
      final hrAlert = _checkHeartRate(vitalSign.heartRate!, vitalSign.userId);
      if (hrAlert != null) alerts.add(hrAlert);
    }

    // Check SpO2
    if (vitalSign.spo2 != null) {
      final spo2Alert = _checkSpO2(vitalSign.spo2!, vitalSign.userId);
      if (spo2Alert != null) alerts.add(spo2Alert);
    }

    // Check temperature
    if (vitalSign.temperature != null) {
      final tempAlert = _checkTemperature(vitalSign.temperature!, vitalSign.userId);
      if (tempAlert != null) alerts.add(tempAlert);
    }

    // Filter alerts by cooldown and save to database
    final triggeredAlerts = <Alert>[];
    for (final alert in alerts) {
      // Check if this alert should be triggered
      if (_shouldTriggerAlert(alert)) {
        await _db.insertAlert(alert);
        
        // Update last alert time
        final key = '${alert.vitalType}_${alert.severity}';
        _lastAlertTime[key] = DateTime.now();
        
        // Send notification for critical and emergency alerts
        if (alert.severity == AppConstants.severityEmergency || 
            alert.severity == AppConstants.severityCritical) {
          await _notificationService.showAlert(alert);
        }
        
        // Broadcast to listeners IMMEDIATELY after saving
        debugPrint('📡 AlertEngine: Broadcasting alert - ${alert.severity} ${alert.vitalType}');
        _alertCreatedController.add(alert);
        triggeredAlerts.add(alert);
      }
    }

    return triggeredAlerts;
  }
  
  /// Clear alert cooldowns (useful for testing or when starting new session)
  void clearAlertCooldowns() {
    _lastAlertTime.clear();
  }

  // Heart Rate Alert Logic
  Alert? _checkHeartRate(int heartRate, String userId) {
    String severity;
    String message;
    String recommendation;

    // EMERGENCY
    if (heartRate > AppConstants.emergencyHRHigh || heartRate < AppConstants.emergencyHRLow) {
      severity = AppConstants.severityEmergency;
      message = '🚨 EMERGENCY: Critical heart rate at $heartRate bpm';
      recommendation = 'CALL EMERGENCY SERVICES IMMEDIATELY. Stop all activity.';
    }
    // CRITICAL
    else if (heartRate > AppConstants.criticalHRHigh || heartRate < AppConstants.criticalHRLow) {
      severity = AppConstants.severityCritical;
      message = '⚠️ CRITICAL: Dangerous heart rate at $heartRate bpm';
      recommendation = 'Stop activity immediately. Rest and monitor. Seek medical attention if persistent.';
    }
    // WARNING (context-aware)
    else if (_activityType == 'RESTING' && heartRate > (AppConstants.warningRestingHRHigh - (_userAge ~/ 10))) {
      severity = AppConstants.severityWarning;
      message = '⚠️ Elevated resting heart rate: $heartRate bpm';
      recommendation = 'Your resting heart rate is higher than normal. Consider relaxation techniques.';
    }
    // No alert
    else {
      return null;
    }

    return Alert(
      id: _uuid.v4(),
      userId: userId,
      timestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      severity: severity,
      vitalType: 'heart_rate',
      message: message,
      recommendation: recommendation,
      vitalValue: heartRate.toDouble(),
    );
  }

  // SpO2 Alert Logic
  Alert? _checkSpO2(int spo2, String userId) {
    String severity;
    String message;
    String recommendation;

    if (spo2 < AppConstants.emergencySpO2) {
      severity = AppConstants.severityEmergency;
      message = '🚨 EMERGENCY: Critical oxygen level at $spo2%';
      recommendation = 'CALL 911 IMMEDIATELY. Sit upright and breathe slowly.';
    } else if (spo2 < AppConstants.criticalSpO2) {
      severity = AppConstants.severityCritical;
      message = '⚠️ CRITICAL: Low oxygen at $spo2%';
      recommendation = 'Stop all activity. Breathe deeply. Contact healthcare provider immediately.';
    } else if (spo2 < AppConstants.warningSpO2) {
      severity = AppConstants.severityWarning;
      message = '⚠️ Low oxygen saturation: $spo2%';
      recommendation = 'Rest and monitor. Contact doctor if symptoms persist.';
    } else {
      return null;
    }

    return Alert(
      id: _uuid.v4(),
      userId: userId,
      timestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      severity: severity,
      vitalType: 'spo2',
      message: message,
      recommendation: recommendation,
      vitalValue: spo2.toDouble(),
    );
  }

  // Temperature Alert Logic
  Alert? _checkTemperature(double temperature, String userId) {
    String severity;
    String message;
    String recommendation;

    if (temperature > AppConstants.criticalTempHigh) {
      severity = AppConstants.severityCritical;
      message = '🌡️ High fever detected: ${temperature.toStringAsFixed(1)}°C';
      recommendation = 'High fever. Take fever reducer and consult doctor.';
    } else if (temperature > AppConstants.warningTempHigh) {
      severity = AppConstants.severityWarning;
      message = '🌡️ Mild fever: ${temperature.toStringAsFixed(1)}°C';
      recommendation = 'Monitor temperature. Stay hydrated.';
    } else if (temperature < AppConstants.warningTempLow) {
      severity = AppConstants.severityWarning;
      message = '❄️ Low body temperature: ${temperature.toStringAsFixed(1)}°C';
      recommendation = 'Possible hypothermia. Warm up gradually.';
    } else {
      return null;
    }

    return Alert(
      id: _uuid.v4(),
      userId: userId,
      timestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      severity: severity,
      vitalType: 'temperature',
      message: message,
      recommendation: recommendation,
      vitalValue: temperature,
    );
  }

  // Get wellness alert (motivational) - not subject to cooldown
  Alert? generateMotivationalAlert(String userId, Map<String, dynamic> metrics) {
    // Check if user reached goals
    final steps = metrics['steps'] as int? ?? 0;
    final caloriesBurned = metrics['calories_burned'] as int? ?? 0;
    
    if (steps >= AppConstants.defaultStepGoal) {
      return Alert(
        id: _uuid.v4(),
        userId: userId,
        timestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        severity: AppConstants.severityInfo,
        vitalType: 'achievement',
        message: '🎯 Daily Step Goal Achieved!',
        recommendation: 'Amazing work! You hit your $steps step goal today! Keep it up! 💪',
      );
    }

    if (caloriesBurned >= AppConstants.defaultCalorieGoal) {
      return Alert(
        id: _uuid.v4(),
        userId: userId,
        timestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        severity: AppConstants.severityInfo,
        vitalType: 'achievement',
        message: '🔥 Calorie Goal Crushed!',
        recommendation: 'You burned $caloriesBurned calories today! Fantastic! 🎉',
      );
    }

    return null;
  }

  void dispose() {
    if (!_alertCreatedController.isClosed) {
      _alertCreatedController.close();
    }
  }
}
