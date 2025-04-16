import 'package:flutter/material.dart';
import '../models/database_service.dart';

class NutritionService {
  static Future<List<dynamic>?> showNutritionDialog(BuildContext context, String prediction) async {
    try {
      final weightOptions = await DatabaseService.getWeightOptions(prediction);
      
      if (weightOptions.isEmpty) {
        throw Exception('No nutrition data found for $prediction');
      }

      double? selectedWeight = weightOptions.first;

      selectedWeight = await showDialog<double>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text('Select portion size for ${prediction.replaceAll('_', ' ')}'),
                content: DropdownButton<double>(
                  value: selectedWeight,
                  items: weightOptions.map((weight) {
                    return DropdownMenuItem<double>(
                      value: weight,
                      child: Text('${weight.toStringAsFixed(0)}g'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedWeight = value;
                    });
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, selectedWeight),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      );

      if (selectedWeight == null) {
        return null;
      }

      final nutritionData = await DatabaseService.getNutritionData(prediction.trim(), selectedWeight!);
      
      if (nutritionData.isEmpty) {
        throw Exception('Failed to get nutrition data');
      }

      final data = nutritionData.first;
      return [
        prediction,
        data['weight'],
        data['calories'],
        data['protein'],
        data['carbohydrates'],
        data['fats'],
        data['fiber'],
        data['sugars'],
        data['sodium'],
      ];
    } catch (e) {
      return null;
    }
  }
}