import 'package:intl/intl.dart';

class Helpers {
  // BMI Calculation
  static double calculateBMI(double weightKg, double heightCm) {
    final heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }

  static String getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  // Calorie Calculation (Harris-Benedict Equation)
  static int calculateDailyCalories({
    required double weightKg,
    required double heightCm,
    required int age,
    required String gender,
    required String activityLevel,
    required String goalType,
  }) {
    double bmr;
    
    // Calculate BMR
    if (gender.toLowerCase() == 'male') {
      bmr = 88.362 + (13.397 * weightKg) + (4.799 * heightCm) - (5.677 * age);
    } else {
      bmr = 447.593 + (9.247 * weightKg) + (3.098 * heightCm) - (4.330 * age);
    }
    
    // Activity multiplier
    double activityMultiplier;
    switch (activityLevel) {
      case 'sedentary':
        activityMultiplier = 1.2;
        break;
      case 'light':
        activityMultiplier = 1.375;
        break;
      case 'moderate':
        activityMultiplier = 1.55;
        break;
      case 'active':
        activityMultiplier = 1.725;
        break;
      case 'very_active':
        activityMultiplier = 1.9;
        break;
      default:
        activityMultiplier = 1.2;
    }
    
    double tdee = bmr * activityMultiplier;
    
    // Adjust for goal
    switch (goalType) {
      case 'lose':
        tdee -= 500; // 0.5kg/week deficit
        break;
      case 'gain':
        tdee += 500; // 0.5kg/week surplus
        break;
      default:
        // maintain weight
        break;
    }
    
    return tdee.round();
  }

  // Goal Timeline Calculation
  static DateTime calculateGoalDate({
    required double currentWeight,
    required double targetWeight,
    required double weeklyChangeRate,
  }) {
    final difference = (currentWeight - targetWeight).abs();
    final weeks = difference / weeklyChangeRate;
    final days = (weeks * 7).round();
    return DateTime.now().add(Duration(days: days));
  }

  // Date Formatting
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy • hh:mm a').format(dateTime);
  }

  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else {
      return formatDate(dateTime);
    }
  }

  // Duration Formatting
  static String formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
  }

  // Unit Conversions
  static double kgToLbs(double kg) => kg * 2.20462;
  static double lbsToKg(double lbs) => lbs / 2.20462;
  static double cmToFeet(double cm) => cm / 30.48;
  static double feetToCm(double feet) => feet * 30.48;
  static double kmToMiles(double km) => km * 0.621371;
  static double milesToKm(double miles) => miles / 0.621371;
  static double celsiusToFahrenheit(double celsius) => (celsius * 9 / 5) + 32;

  // Heart Rate Zones (based on max HR = 220 - age)
  static Map<String, Map<String, dynamic>> getHeartRateZones(int age) {
    final maxHR = 220 - age;
    return {
      'resting': {
        'min': 0,
        'max': (maxHR * 0.5).round(),
        'name': 'Resting',
        'color': 0xFF4CAF50,
      },
      'fat_burn': {
        'min': (maxHR * 0.5).round(),
        'max': (maxHR * 0.7).round(),
        'name': 'Fat Burn',
        'color': 0xFF2196F3,
      },
      'cardio': {
        'min': (maxHR * 0.7).round(),
        'max': (maxHR * 0.85).round(),
        'name': 'Cardio',
        'color': 0xFFFF9800,
      },
      'peak': {
        'min': (maxHR * 0.85).round(),
        'max': maxHR,
        'name': 'Peak',
        'color': 0xFFFF3344,
      },
    };
  }

  static String getHRZone(int heartRate, int age) {
    final zones = getHeartRateZones(age);
    if (heartRate < zones['fat_burn']!['min']) return 'Resting';
    if (heartRate < zones['cardio']!['min']) return 'Fat Burn';
    if (heartRate < zones['peak']!['min']) return 'Cardio';
    return 'Peak';
  }

  // Wellness Score Calculation
  static int calculateWellnessScore({
    required double sleepScore,
    required double activityScore,
    required double vitalsScore,
    required double nutritionScore,
  }) {
    return ((sleepScore * 0.25) +
            (activityScore * 0.25) +
            (vitalsScore * 0.25) +
            (nutritionScore * 0.25))
        .round();
  }

  // Stress Level Calculation (based on HRV)
  static String calculateStressLevel(double hrv, int restingHR, int currentHR) {
    // Simplified stress calculation
    // HRV: Higher is better (less stress)
    // HR difference: Higher current HR vs resting = more stress
    
    final hrDifference = currentHR - restingHR;
    
    if (hrv < 20 || hrDifference > 30) {
      return 'High';
    } else if (hrv < 50 || hrDifference > 15) {
      return 'Medium';
    } else {
      return 'Low';
    }
  }

  // Number Formatting
  static String formatNumber(num number) {
    return NumberFormat('#,###').format(number);
  }

  static String formatDecimal(double number, int decimals) {
    return number.toStringAsFixed(decimals);
  }

  // Validation Helpers
  static bool isValidHeartRate(int hr) => hr >= 30 && hr <= 220;
  static bool isValidSpO2(int spo2) => spo2 >= 70 && spo2 <= 100;
  static bool isValidTemperature(double temp) => temp >= 30.0 && temp <= 45.0;
}
