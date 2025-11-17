import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/alert.dart';
import '../core/constants/constants.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  // Initialize notification service
  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    const androidChannel = AndroidNotificationChannel(
      AppConstants.notificationChannelId,
      AppConstants.notificationChannelName,
      description: AppConstants.notificationChannelDescription,
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    _initialized = true;
  }

  // Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    // TODO: Navigate to alerts screen
    print('Notification tapped: ${response.payload}');
  }

  // Show alert notification
  Future<void> showAlert(Alert alert) async {
    if (!_initialized) await initialize();

    final notificationId = alert.timestamp % 100000; // Use timestamp as ID

    AndroidNotificationDetails androidDetails;
    
    switch (alert.severity) {
      case AppConstants.severityEmergency:
        androidDetails = AndroidNotificationDetails(
          AppConstants.notificationChannelId,
          AppConstants.notificationChannelName,
          channelDescription: AppConstants.notificationChannelDescription,
          importance: Importance.max,
          priority: Priority.max,
          playSound: true,
          enableVibration: true,
          color: const Color(0xFFFF1744),
          colorized: true,
          ticker: 'EMERGENCY HEALTH ALERT',
        );
        break;
      case AppConstants.severityCritical:
        androidDetails = AndroidNotificationDetails(
          AppConstants.notificationChannelId,
          AppConstants.notificationChannelName,
          channelDescription: AppConstants.notificationChannelDescription,
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          color: const Color(0xFFFF9800),
          colorized: true,
        );
        break;
      default:
        androidDetails = const AndroidNotificationDetails(
          AppConstants.notificationChannelId,
          AppConstants.notificationChannelName,
          channelDescription: AppConstants.notificationChannelDescription,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        );
    }

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      notificationId,
      alert.message,
      alert.recommendation,
      details,
      payload: alert.id,
    );
  }

  // Show motivational notification
  Future<void> showMotivation(String title, String message) async {
    if (!_initialized) await initialize();

    const androidDetails = AndroidNotificationDetails(
      'healthtrack_motivation',
      'Motivation',
      channelDescription: 'Motivational messages and tips',
      importance: Importance.low,
      priority: Priority.low,
      playSound: false,
      color: const Color(0xFFFF2E78),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: false,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecond,
      title,
      message,
      details,
    );
  }

  // Schedule daily motivation
  Future<void> scheduleDailyMotivation(int hour, int minute, String message) async {
    if (!_initialized) await initialize();

    // TODO: Implement using workmanager or timezone package
    // This is a placeholder for scheduled notifications
    print('Scheduled notification at $hour:$minute - $message');
  }

  // Cancel all notifications
  Future<void> cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
