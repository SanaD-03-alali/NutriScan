import 'dart:io';
import 'dart:math' show exp;
import 'package:flutter/material.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'vision_service.dart';
import 'prediction_history.dart';
import 'nutrition_service.dart';

class Classifier {
  static ClassificationModel? _imageModel;

  static Future<void> loadModel() async {
    String pathImageModel = "assets/models/food101_model_mobile.pt";
    try {
      _imageModel = await PytorchLite.loadClassificationModel(
          pathImageModel, 224, 224, 101,
          labelPath: "assets/labels.txt");
    } catch (e) {
      rethrow;
    }
  }

  static Future<PredictionResult> classifyImage(String imagePath, BuildContext context) async {
    try {
      final isFood = await VisionService.isFood(imagePath);
      
      if (!isFood) {
        throw const NotFoodException('No food detected in the image');
      }

      if (_imageModel == null) {
        await loadModel();
      }

      final imageBytes = await File(imagePath).readAsBytes();
      final List<double?> logits = await _imageModel!.getImagePredictionList(
        imageBytes,
        mean: [0.485, 0.456, 0.406],
        std: [0.229, 0.224, 0.225],
      );

      if (logits.isEmpty) {
        throw const NotFoodException('Failed to process the image');
      }

      double maxLogit = logits.reduce((curr, next) => 
        (curr ?? double.negativeInfinity) > (next ?? double.negativeInfinity) 
          ? curr! 
          : next!) as double;
      
      List<double> expValues = logits
          .map((logit) => exp((logit ?? 0) - maxLogit))
          .toList();
      
      double sumExp = expValues.reduce((a, b) => a + b);
      List<double> probabilities = expValues
          .map((expValue) => expValue / sumExp)
          .toList();

      int maxIndex = 0;
      double maxProb = probabilities[0];
      
      for (int i = 0; i < probabilities.length; i++) {
        if (probabilities[i] > maxProb) {
          maxProb = probabilities[i];
          maxIndex = i;
        }
      }

      final prediction = _imageModel!.labels[maxIndex].trim();
      
      // Get nutrition info based on user selection
      final selectedNutrition = await NutritionService.showNutritionDialog(context, prediction);

      final result = PredictionResult(
        imagePath: imagePath,
        prediction: prediction,
        confidence: maxProb * 100,
        timestamp: DateTime.now(),
        weight: selectedNutrition?[1],
        calories: selectedNutrition?[2],
        protein: selectedNutrition?[3],
        carbs: selectedNutrition?[4],
        fats: selectedNutrition?[5],
        fiber: selectedNutrition?[6],
        sugars: selectedNutrition?[7],
        sodium: selectedNutrition?[8],
      );

      return result;
    } catch (e) {
      rethrow;
    }
  }
}

class NotFoodException implements Exception {
  final String message;
  const NotFoodException(this.message);

  @override
  String toString() => message;
}