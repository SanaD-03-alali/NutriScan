import 'package:flutter/material.dart';
import 'dart:io';
import '../models/prediction_history.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../models/database_service.dart';

class HistoryScreen extends StatelessWidget {
  final List<PredictionResult> predictions;

  const HistoryScreen({
    super.key,
    required this.predictions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'History',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.green[800],
        elevation: 0,
      ),
      backgroundColor: Colors.green[50],
      body: SafeArea(
        child: predictions.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.utensils,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No predictions yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: predictions.length,
                itemBuilder: (context, index) {
                  final prediction = predictions[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 4,
                    shadowColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image with gradient overlay
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                              child: Image.file(
                                File(prediction.imagePath),
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 80,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black87,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.burger,
                                        size: 20,
                                        color: Colors.green[700],
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        prediction.prediction.replaceAll('_', ' ').toTitleCase(),
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green[900],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green[100],
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.green.shade300,
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.green.withValues(alpha: 0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.chartLine,
                                          size: 12,
                                          color: Colors.green[800],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Confidence: ${prediction.confidence.toStringAsFixed(1)}%',
                                          style: TextStyle(
                                            color: Colors.green[800],
                                            fontWeight: FontWeight.w800,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (prediction.weight != null) ...[
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.weightScale,
                                        size: 14,
                                        color: Colors.green[700],
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Nutritional Information (${prediction.weight!.toStringAsFixed(0)}g serving):',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.green[900],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildNutritionGrid(prediction),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.clock,
                                        size: 12,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        DateFormat('MMM d, y • h:mm a').format(prediction.timestamp),
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildNutritionTile(String label, String value, IconData icon, Color color) {
    final backgroundColor = color.withValues(alpha: 0.2);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.greenAccent.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: FaIcon(
              icon,
              size: 16,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionGrid(PredictionResult prediction) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      // Get nutrition data from database for this prediction
      future: DatabaseService.getNutritionData(prediction.prediction, prediction.weight ?? 0),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final nutritionData = snapshot.data!.first;
          return GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _buildNutritionTile(
                'Calories',
                '${nutritionData['calories']?.toStringAsFixed(0)} kcal',
                FontAwesomeIcons.fire,
                const Color(0xFFFFB74D),
              ),
              _buildNutritionTile(
                'Protein',
                '${nutritionData['protein']?.toStringAsFixed(1)}g',
                FontAwesomeIcons.dumbbell,
                const Color(0xFFEF5350),
              ),
              _buildNutritionTile(
                'Carbs',
                '${nutritionData['carbohydrates']?.toStringAsFixed(1)}g',
                FontAwesomeIcons.wheatAwn,
                const Color(0xFF8D6E63),
              ),
              _buildNutritionTile(
                'Fats',
                '${nutritionData['fats']?.toStringAsFixed(1)}g',
                FontAwesomeIcons.droplet,
                const Color(0xFFFFB300),
              ),
              _buildNutritionTile(
                'Fiber',
                '${nutritionData['fiber']?.toStringAsFixed(1)}g',
                FontAwesomeIcons.leaf,
                const Color(0xFF66BB6A),
              ),
              _buildNutritionTile(
                'Sugars',
                '${nutritionData['sugars']?.toStringAsFixed(1)}g',
                FontAwesomeIcons.candyCane,
                const Color(0xFFEC407A),
              ),
              _buildNutritionTile(
                'Sodium',
                '${nutritionData['sodium']?.toStringAsFixed(0)}mg',
                FontAwesomeIcons.water,
                const Color(0xFF42A5F5),
              ),
            ],
          );
        }
        // Show loading or error state
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

extension StringExtension on String {
  String toTitleCase() {
    return split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}