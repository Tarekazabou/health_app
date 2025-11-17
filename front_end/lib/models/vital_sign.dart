class VitalSign {
  final int? id;
  final String userId;
  final int timestamp;
  final int? heartRate;
  final int? spo2;
  final double? temperature;
  final double? accelX;
  final double? accelY;
  final double? accelZ;
  final double? gyroX;
  final double? gyroY;
  final double? gyroZ;
  final int? battery;
  final bool synced;
  final String? activityState;
  final Map<String, dynamic>? rawData; // Store raw sensor data for debugging

  VitalSign({
    this.id,
    required this.userId,
    required this.timestamp,
    this.heartRate,
    this.spo2,
    this.temperature,
    this.accelX,
    this.accelY,
    this.accelZ,
    this.gyroX,
    this.gyroY,
    this.gyroZ,
    this.battery,
    this.synced = false,
    this.activityState,
    this.rawData,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'timestamp': timestamp,
      'heart_rate': heartRate,
      'spo2': spo2,
      'temperature': temperature,
      'accel_x': accelX,
      'accel_y': accelY,
      'accel_z': accelZ,
      'gyro_x': gyroX,
      'gyro_y': gyroY,
      'gyro_z': gyroZ,
      'battery': battery,
      'synced': synced ? 1 : 0,
    };
  }

  factory VitalSign.fromMap(Map<String, dynamic> map) {
    return VitalSign(
      id: map['id'],
      userId: map['user_id'],
      timestamp: map['timestamp'],
      heartRate: map['heart_rate'],
      spo2: map['spo2'],
      temperature: map['temperature'],
      accelX: map['accel_x'],
      accelY: map['accel_y'],
      accelZ: map['accel_z'],
      gyroX: map['gyro_x'],
      gyroY: map['gyro_y'],
      gyroZ: map['gyro_z'],
      battery: map['battery'],
      synced: map['synced'] == 1,
    );
  }

  factory VitalSign.fromJson(Map<String, dynamic> json, String userId) {
    return VitalSign(
      userId: userId,
      timestamp: json['timestamp'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
      heartRate: json['heart_rate'],
      spo2: json['spo2'],
      temperature: json['temperature']?.toDouble(),
      accelX: json['accel_x']?.toDouble(),
      accelY: json['accel_y']?.toDouble(),
      accelZ: json['accel_z']?.toDouble(),
      gyroX: json['gyro_x']?.toDouble(),
      gyroY: json['gyro_y']?.toDouble(),
      gyroZ: json['gyro_z']?.toDouble(),
      battery: json['battery'],
      activityState: json['activity_state'],
      rawData: json, // Store complete raw data
    );
  }

  VitalSign copyWith({
    int? id,
    String? userId,
    int? timestamp,
    int? heartRate,
    int? spo2,
    double? temperature,
    double? accelX,
    double? accelY,
    double? accelZ,
    double? gyroX,
    double? gyroY,
    double? gyroZ,
    int? battery,
    bool? synced,
    String? activityState,
    Map<String, dynamic>? rawData,
  }) {
    return VitalSign(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      timestamp: timestamp ?? this.timestamp,
      heartRate: heartRate ?? this.heartRate,
      spo2: spo2 ?? this.spo2,
      temperature: temperature ?? this.temperature,
      accelX: accelX ?? this.accelX,
      accelY: accelY ?? this.accelY,
      accelZ: accelZ ?? this.accelZ,
      gyroX: gyroX ?? this.gyroX,
      gyroY: gyroY ?? this.gyroY,
      gyroZ: gyroZ ?? this.gyroZ,
      battery: battery ?? this.battery,
      synced: synced ?? this.synced,
      activityState: activityState ?? this.activityState,
      rawData: rawData ?? this.rawData,
    );
  }
}
