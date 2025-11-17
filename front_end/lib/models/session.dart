class Session {
  final String id;
  final String userId;
  final String sessionType;
  final int startTime;
  final int? endTime;
  final int? durationSeconds;
  final int? avgHeartRate;
  final int? maxHeartRate;
  final int? caloriesBurned;
  final int? avgSpo2;
  final String? notes;

  Session({
    required this.id,
    required this.userId,
    required this.sessionType,
    required this.startTime,
    this.endTime,
    this.durationSeconds,
    this.avgHeartRate,
    this.maxHeartRate,
    this.caloriesBurned,
    this.avgSpo2,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'session_type': sessionType,
      'start_time': startTime,
      'end_time': endTime,
      'duration_seconds': durationSeconds,
      'avg_heart_rate': avgHeartRate,
      'max_heart_rate': maxHeartRate,
      'calories_burned': caloriesBurned,
      'avg_spo2': avgSpo2,
      'notes': notes,
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      id: map['id'],
      userId: map['user_id'],
      sessionType: map['session_type'],
      startTime: map['start_time'],
      endTime: map['end_time'],
      durationSeconds: map['duration_seconds'],
      avgHeartRate: map['avg_heart_rate'],
      maxHeartRate: map['max_heart_rate'],
      caloriesBurned: map['calories_burned'],
      avgSpo2: map['avg_spo2'],
      notes: map['notes'],
    );
  }

  bool get isActive => endTime == null;

  String get formattedDuration {
    if (durationSeconds == null) return '--:--';
    final hours = durationSeconds! ~/ 3600;
    final minutes = (durationSeconds! % 3600) ~/ 60;
    final seconds = durationSeconds! % 60;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  Session copyWith({
    String? id,
    String? userId,
    String? sessionType,
    int? startTime,
    int? endTime,
    int? durationSeconds,
    int? avgHeartRate,
    int? maxHeartRate,
    int? caloriesBurned,
    int? avgSpo2,
    String? notes,
  }) {
    return Session(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      sessionType: sessionType ?? this.sessionType,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      avgHeartRate: avgHeartRate ?? this.avgHeartRate,
      maxHeartRate: maxHeartRate ?? this.maxHeartRate,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      avgSpo2: avgSpo2 ?? this.avgSpo2,
      notes: notes ?? this.notes,
    );
  }
}
