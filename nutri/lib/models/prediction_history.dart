class PredictionResult {
  final String imagePath;
  final String prediction;
  final double confidence;
  final DateTime timestamp;
  final double? weight;
  final double? calories;
  final double? protein;
  final double? carbs;
  final double? fats;
  final double? fiber;
  final double? sugars;
  final double? sodium;
  

  PredictionResult({
    required this.imagePath,
    required this.prediction,
    required this.confidence,
    required this.timestamp,
    this.weight,
    this.calories,
    this.protein,
    this.carbs,
    this.fats,
    this.fiber,
    this.sugars,
    this.sodium,
  });

  // Factory constructor to create PredictionResult from JSON data
  factory PredictionResult.fromJson(Map<String, dynamic> json, {
    required String imagePath,
    required String prediction,
    required double confidence,
    required DateTime timestamp,
  }) {
    return PredictionResult(
      imagePath: imagePath,
      prediction: prediction,
      confidence: confidence,
      timestamp: timestamp,
      weight: json['weight']?.toDouble(),
      calories: json['calories']?.toDouble(),
      protein: json['protein']?.toDouble(),
      carbs: json['carbohydrates']?.toDouble(),  // Note: matches DB field name
      fats: json['fats']?.toDouble(),
      fiber: json['fiber']?.toDouble(),
      sugars: json['sugars']?.toDouble(),
      sodium: json['sodium']?.toDouble(),
    );
  }

  // Method to update nutrition data
  PredictionResult copyWithNutritionData(Map<String, dynamic> nutritionData) {
    return PredictionResult(
      imagePath: imagePath,
      prediction: prediction,
      confidence: confidence,
      timestamp: timestamp,
      weight: nutritionData['weight']?.toDouble(),
      calories: nutritionData['calories']?.toDouble(),
      protein: nutritionData['protein']?.toDouble(),
      carbs: nutritionData['carbohydrates']?.toDouble(),
      fats: nutritionData['fats']?.toDouble(),
      fiber: nutritionData['fiber']?.toDouble(),
      sugars: nutritionData['sugars']?.toDouble(),
      sodium: nutritionData['sodium']?.toDouble(),
    );
  }
}