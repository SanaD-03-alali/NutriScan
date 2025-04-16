import 'package:flutter/material.dart';
import '../services/barcode_service.dart';
import '../providers/saved_products_provider.dart';

class BarcodeResultScreen extends StatefulWidget {
  final String barcode;

  const BarcodeResultScreen({
    super.key,
    required this.barcode,
  });

  @override
  State<BarcodeResultScreen> createState() => _BarcodeResultScreenState();
}

class _BarcodeResultScreenState extends State<BarcodeResultScreen> {
  double _servingSize = 100.0;
  Map<String, dynamic>? _foodData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final data = await BarcodeService.fetchFoodData(widget.barcode);
    setState(() {
      _foodData = data;
      _isLoading = false;
    });
  }

  double _calculateValue(double? value) {
    if (value == null) return 0.0;
    return (value * _servingSize) / 100.0;
  }

  Map<String, dynamic> _getCurrentProductData() {
    return {
      'barcode': widget.barcode,
      'name': _foodData!['name'],
      'calories': _foodData!['calories'],
      'protein': _foodData!['protein'],
      'carbs': _foodData!['carbs'],
      'fats': _foodData!['fats'],
      'fiber': _foodData!['fiber'],
      'sugars': _foodData!['sugars'],
      'servingSize': _servingSize,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Information', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[800],
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _foodData == null
              ? const Center(child: Text('Product not found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _foodData!['name'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Serving Size: ${_servingSize.toStringAsFixed(0)}g',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Slider(
                        value: _servingSize,
                        min: 0,
                        max: 500,
                        divisions: 50,
                        label: '${_servingSize.round()}g',
                        onChanged: (value) {
                          setState(() {
                            _servingSize = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildNutritionGrid(),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final provider = SavedProductsProvider.of(context);
                            provider.addProduct(_getCurrentProductData());
                            
                            // Show snackbar and pop the screen
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Product saved successfully!'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 1),
                              ),
                            );
                            
                            // Navigate back to previous screen
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.save, color: Colors.white),
                          label: const Text(
                            'Save Product',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[800],
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildNutritionGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.7,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        _buildNutritionTile(
          'Calories',
          '${_calculateValue(_foodData!['calories']).toStringAsFixed(1)} kcal',
          Icons.local_fire_department,
          Colors.orange,
        ),
        _buildNutritionTile(
          'Protein',
          '${_calculateValue(_foodData!['protein']).toStringAsFixed(1)}g',
          Icons.fitness_center,
          Colors.red,
        ),
        _buildNutritionTile(
          'Carbs',
          '${_calculateValue(_foodData!['carbs']).toStringAsFixed(1)}g',
          Icons.grain,
          Colors.brown,
        ),
        _buildNutritionTile(
          'Fat',
          '${_calculateValue(_foodData!['fats']).toStringAsFixed(1)}g',
          Icons.opacity,
          Colors.yellow[700]!,
        ),
        _buildNutritionTile(
          'Fiber',
          '${_calculateValue(_foodData!['fiber']).toStringAsFixed(1)}g',
          Icons.eco,
          Colors.green,
        ),
        _buildNutritionTile(
          'Sugar',
          '${_calculateValue(_foodData!['sugars']).toStringAsFixed(1)}g',
          Icons.cake,
          Colors.pink,
        ),
      ],
    );
  }

  Widget _buildNutritionTile(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 