import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/database_config.dart';

class DatabaseService {
  static final supabase = Supabase.instance.client;

  /// Initialize Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: DatabaseConfig.supabaseUrl,
      anonKey: DatabaseConfig.supabaseKey,
    );
  }

  /// Fetches weight options for a given food and returns as a JSON list.
  static Future<List<double>> getWeightOptions(String foodName) async {
    try {
      final response = await supabase
          .from(DatabaseConfig.tableName)
          .select('weight')
          .eq('label', foodName);

      if (response.isEmpty) {
        throw Exception("No nutrition data found for $foodName");
      }

      final weights = response
          .map<double>((row) => double.parse(row['weight'].toString()))
          .toList();

      return weights;
    } catch (e) {
      rethrow;
    }
  }

  /// Fetches detailed nutrition data and returns as a JSON array.
  static Future<List<Map<String, dynamic>>> getNutritionData(
      String foodName, double weight) async {
    try {
      final response = await supabase
          .from(DatabaseConfig.tableName)
          .select()
          .eq('label', foodName)
          .order('weight', ascending: true);

      if (response.isEmpty) {
        throw Exception(
            'No nutrition data found for $foodName with weight $weight');
      }

      // Find closest weight to requested weight
      double minDiff = double.infinity;
      Map<String, dynamic>? closestRow;

      for (final row in response) {
        final rowWeight = double.parse(row['weight'].toString());
        final diff = (rowWeight - weight).abs();
        if (diff < minDiff) {
          minDiff = diff;
          closestRow = row;
        }
      }

      if (closestRow == null) {
        throw Exception('Failed to find closest weight match');
      }

      final jsonData = [
        {
          'label': closestRow['label'],
          'weight': double.parse(closestRow['weight'].toString()),
          'calories': double.parse(closestRow['calories'].toString()),
          'protein': double.parse(closestRow['protein'].toString()),
          'carbohydrates': double.parse(closestRow['carbohydrates'].toString()),
          'fats': double.parse(closestRow['fats'].toString()),
          'fiber': double.parse(closestRow['fiber'].toString()),
          'sugars': double.parse(closestRow['sugars'].toString()),
          'sodium': double.parse(closestRow['sodium'].toString()),
        }
      ];

      return jsonData;
    } catch (e) {
      rethrow;
    }
  }
}
