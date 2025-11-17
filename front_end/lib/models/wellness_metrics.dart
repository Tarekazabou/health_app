class WellnessMetrics {
  final int? id;
  final String userId;
  final String date;
  final double? hrv;
  final String? stressLevel;
  final int? steps;
  final double? distanceKm;
  final int? activeMinutes;
  final int? caloriesBurned;
  final int? restingHR;
  final int? avgHR;
  final int? maxHR;
  final int? avgSpo2;
  final double? sleepHours;
  final int? wellnessScore;

  WellnessMetrics({
    this.id,
    required this.userId,
    required this.date,
    this.hrv,
    this.stressLevel,
    this.steps,
    this.distanceKm,
    this.activeMinutes,
    this.caloriesBurned,
    this.restingHR,
    this.avgHR,
    this.maxHR,
    this.avgSpo2,
    this.sleepHours,
    this.wellnessScore,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'date': date,
      'hrv': hrv,
      'stress_level': stressLevel,
      'steps': steps,
      'distance_km': distanceKm,
      'active_minutes': activeMinutes,
      'calories_burned': caloriesBurned,
      'resting_hr': restingHR,
      'avg_hr': avgHR,
      'max_hr': maxHR,
      'avg_spo2': avgSpo2,
      'sleep_hours': sleepHours,
      'wellness_score': wellnessScore,
    };
  }

  factory WellnessMetrics.fromMap(Map<String, dynamic> map) {
    return WellnessMetrics(
      id: map['id'],
      userId: map['user_id'],
      date: map['date'],
      hrv: map['hrv'],
      stressLevel: map['stress_level'],
      steps: map['steps'],
      distanceKm: map['distance_km'],
      activeMinutes: map['active_minutes'],
      caloriesBurned: map['calories_burned'],
      restingHR: map['resting_hr'],
      avgHR: map['avg_hr'],
      maxHR: map['max_hr'],
      avgSpo2: map['avg_spo2'],
      sleepHours: map['sleep_hours'],
      wellnessScore: map['wellness_score'],
    );
  }

  WellnessMetrics copyWith({
    int? id,
    String? userId,
    String? date,
    double? hrv,
    String? stressLevel,
    int? steps,
    double? distanceKm,
    int? activeMinutes,
    int? caloriesBurned,
    int? restingHR,
    int? avgHR,
    int? maxHR,
    int? avgSpo2,
    double? sleepHours,
    int? wellnessScore,
  }) {
    return WellnessMetrics(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      hrv: hrv ?? this.hrv,
      stressLevel: stressLevel ?? this.stressLevel,
      steps: steps ?? this.steps,
      distanceKm: distanceKm ?? this.distanceKm,
      activeMinutes: activeMinutes ?? this.activeMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      restingHR: restingHR ?? this.restingHR,
      avgHR: avgHR ?? this.avgHR,
      maxHR: maxHR ?? this.maxHR,
      avgSpo2: avgSpo2 ?? this.avgSpo2,
      sleepHours: sleepHours ?? this.sleepHours,
      wellnessScore: wellnessScore ?? this.wellnessScore,
    );
  }
}
