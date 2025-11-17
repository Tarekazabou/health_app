import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

enum AlertSeverity {
  emergency,
  critical,
  warning,
  info
}

class Alert {
  final String id;
  final String userId;
  final int timestamp;
  final String severity;
  final String vitalType;
  final String message;
  final String recommendation;
  final double? vitalValue;
  final bool acknowledged;
  final String? title;  // Added
  final bool isRead;    // Added

  Alert({
    required this.id,
    required this.userId,
    required this.timestamp,
    required this.severity,
    required this.vitalType,
    required this.message,
    required this.recommendation,
    this.vitalValue,
    this.acknowledged = false,
    this.title,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'timestamp': timestamp,
      'severity': severity,
      'vital_type': vitalType,
      'message': message,
      'recommendation': recommendation,
      'vital_value': vitalValue,
      'acknowledged': acknowledged ? 1 : 0,
      'title': title,
      'is_read': isRead ? 1 : 0,
    };
  }

  factory Alert.fromMap(Map<String, dynamic> map) {
    return Alert(
      id: map['id'],
      userId: map['user_id'],
      timestamp: map['timestamp'],
      severity: map['severity'],
      vitalType: map['vital_type'],
      message: map['message'],
      recommendation: map['recommendation'],
      vitalValue: map['vital_value'],
      acknowledged: map['acknowledged'] == 1,
      title: map['title'],
      isRead: map['is_read'] == 1,
    );
  }

  Alert copyWith({
    String? id,
    String? userId,
    int? timestamp,
    String? severity,
    String? vitalType,
    String? message,
    String? recommendation,
    double? vitalValue,
    bool? acknowledged,
    String? title,
    bool? isRead,
  }) {
    return Alert(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      timestamp: timestamp ?? this.timestamp,
      severity: severity ?? this.severity,
      vitalType: vitalType ?? this.vitalType,
      message: message ?? this.message,
      recommendation: recommendation ?? this.recommendation,
      vitalValue: vitalValue ?? this.vitalValue,
      acknowledged: acknowledged ?? this.acknowledged,
      title: title ?? this.title,
      isRead: isRead ?? this.isRead,
    );
  }

  // Returns Color value as int
  int getSeverityColor() {
    switch (severity) {
      case 'EMERGENCY':
      case 'CRITICAL':
        return AppColors.emergencyRed.value;
      case 'WARNING':
        return AppColors.warningOrange.value;
      case 'INFO':
        return AppColors.infoBlue.value;
      default:
        return AppColors.mediumGray.value;
    }
  }
  
  // Returns Color object directly
  Color getSeverityColorObj() {
    switch (severity) {
      case 'EMERGENCY':
      case 'CRITICAL':
        return AppColors.emergencyRed;
      case 'WARNING':
        return AppColors.warningOrange;
      case 'INFO':
        return AppColors.infoBlue;
      default:
        return AppColors.mediumGray;
    }
  }

  String getSeverityIcon() {
    switch (severity) {
      case 'EMERGENCY':
        return '🚨';
      case 'CRITICAL':
        return '⚠️';
      case 'WARNING':
        return '⚠️';
      case 'INFO':
        return 'ℹ️';
      default:
        return '•';
    }
  }
}
