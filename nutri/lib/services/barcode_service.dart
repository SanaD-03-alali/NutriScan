import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:openfoodfacts/openfoodfacts.dart';

class BarcodeService {
  static Future<Map<String, dynamic>?> fetchFoodData(String barcode) async {
    try {
      // Initialize OpenFoodFacts
      OpenFoodAPIConfiguration.userAgent = UserAgent(
        name: 'nutri',
      );

      // Search for product using the package
      final parameters = ProductSearchQueryConfiguration(
        parametersList: [
          BarcodeParameter(barcode),
        ],
        language: OpenFoodFactsLanguage.ENGLISH,
        fields: [
          ProductField.NAME,
          ProductField.NUTRIMENTS,
          ProductField.GENERIC_NAME,
        ],
        version: ProductQueryVersion.v3,
      );

      final result = await OpenFoodAPIClient.searchProducts(
        const User(userId: '', password: ''),  // Anonymous user
        parameters,
      );


      if (result.products != null && result.products!.isNotEmpty) {
        final product = result.products!.first;
        final nutriments = product.nutriments;

        if (nutriments != null) {
          // Check if product has any of the required nutrients
          final nutrients = ['energy-kcal', 'proteins', 'carbohydrates', 'fat', 'fiber', 'sugars'];
          final Map<String, dynamic> nutrimentMap = nutriments.toJson();
          bool hasNutrients = nutrients.any((nutrient) => nutrimentMap[nutrient] != null);

          if (hasNutrients) {
            return {
              'name': product.productName ?? 
                     product.genericName ?? 
                     'Unknown Product',
              'calories': (nutrimentMap['energy-kcal'] ?? 0).toDouble(),
              'protein': (nutrimentMap['proteins'] ?? 0).toDouble(),
              'carbs': (nutrimentMap['carbohydrates'] ?? 0).toDouble(),
              'fats': (nutrimentMap['fat'] ?? 0).toDouble(),
              'fiber': (nutrimentMap['fiber'] ?? 0).toDouble(),
              'sugars': (nutrimentMap['sugars'] ?? 0).toDouble(),
            };
          }
        }
      }

      // If official package fails, try direct API as fallback
      final response = await http.get(
        Uri.parse('https://world.openfoodfacts.org/api/v0/product/$barcode')
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 1 && data['product'] != null) {
          final product = data['product'];
          final nutriments = product['nutriments'];
          
          if (nutriments != null) {
            // Check if product has any of the required nutrients
            final nutrients = ['energy-kcal', 'proteins', 'carbohydrates', 'fat', 'fiber', 'sugars'];
            bool hasNutrients = nutrients.any((nutrient) => nutriments[nutrient] != null);

            if (hasNutrients) {
              return {
                'name': product['product_name'] ?? 'Unknown Product',
                'calories': (nutriments['energy-kcal'] ?? 0).toDouble(),
                'protein': (nutriments['proteins'] ?? 0).toDouble(),
                'carbs': (nutriments['carbohydrates'] ?? 0).toDouble(),
                'fats': (nutriments['fat'] ?? 0).toDouble(),
                'fiber': (nutriments['fiber'] ?? 0).toDouble(),
                'sugars': (nutriments['sugars'] ?? 0).toDouble(),
              };
            }
          }
        }
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }
} 