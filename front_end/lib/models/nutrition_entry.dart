class NutritionEntry {
  final String id;
  final String userId;
  final int timestamp;
  final String mealType;
  final String? imagePath;
  final int? calories;
  final double? proteinG;
  final double? carbsG;
  final double? fatsG;
  final String? description;

  NutritionEntry({
    required this.id,
    required this.userId,
    required this.timestamp,
    required this.mealType,
    this.imagePath,
    this.calories,
    this.proteinG,
    this.carbsG,
    this.fatsG,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'timestamp': timestamp,
      'meal_type': mealType,
      'image_path': imagePath,
      'calories': calories,
      'protein_g': proteinG,
      'carbs_g': carbsG,
      'fats_g': fatsG,
      'description': description,
    };
  }

  factory NutritionEntry.fromMap(Map<String, dynamic> map) {
    return NutritionEntry(
      id: map['id'],
      userId: map['user_id'],
      timestamp: map['timestamp'],
      mealType: map['meal_type'],
      imagePath: map['image_path'],
      calories: map['calories'],
      proteinG: map['protein_g'],
      carbsG: map['carbs_g'],
      fatsG: map['fats_g'],
      description: map['description'],
    );
  }

  NutritionEntry copyWith({
    String? id,
    String? userId,
    int? timestamp,
    String? mealType,
    String? imagePath,
    int? calories,
    double? proteinG,
    double? carbsG,
    double? fatsG,
    String? description,
  }) {
    return NutritionEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      timestamp: timestamp ?? this.timestamp,
      mealType: mealType ?? this.mealType,
      imagePath: imagePath ?? this.imagePath,
      calories: calories ?? this.calories,
      proteinG: proteinG ?? this.proteinG,
      carbsG: carbsG ?? this.carbsG,
      fatsG: fatsG ?? this.fatsG,
      description: description ?? this.description,
    );
  }
}
