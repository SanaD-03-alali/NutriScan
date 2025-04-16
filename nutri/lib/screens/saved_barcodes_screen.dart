import 'package:flutter/material.dart';

class SavedBarcodesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> savedBarcodes;

  const SavedBarcodesScreen({
    super.key,
    required this.savedBarcodes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text('Saved Products',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green[800],
      ),
      body: savedBarcodes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_basket_outlined,
                      size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No saved products yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: savedBarcodes.length,
              itemBuilder: (context, index) {
                final product = savedBarcodes[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.fastfood, color: Colors.green[800]),
                            const SizedBox(width: 8),
                            Text(
                              product['name'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Nutritional Information (${product['servingSize'].toStringAsFixed(0)}g serving):',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildNutritionGrid(product),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildNutritionGrid(Map<String, dynamic> product) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 1.6,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: [
        _buildNutritionTile(
          'Calories',
          '${product['calories']} kcal',
          Colors.orange[100]!,
          Colors.orange,
        ),
        _buildNutritionTile(
          'Protein',
          '${product['protein']}g',
          Colors.red[100]!,
          Colors.red,
        ),
        _buildNutritionTile(
          'Carbs',
          '${product['carbs']}g',
          Colors.grey[300]!,
          Colors.grey[700]!,
        ),
        _buildNutritionTile(
          'Fats',
          '${product['fats']}g',
          Colors.yellow[100]!,
          Colors.orange[700]!,
        ),
        _buildNutritionTile(
          'Fiber',
          '${product['fiber']}g',
          Colors.green[100]!,
          Colors.green,
        ),
        _buildNutritionTile(
          'Sugars',
          '${product['sugars']}g',
          Colors.pink[100]!,
          Colors.pink,
        ),
      ],
    );
  }

  Widget _buildNutritionTile(
      String label, String value, Color bgColor, Color textColor) {
    IconData getIconForLabel() {
      switch (label) {
        case 'Calories':
          return Icons.local_fire_department;
        case 'Protein':
          return Icons.fitness_center;
        case 'Carbs':
          return Icons.grain;
        case 'Fats':
          return Icons.opacity;
        case 'Fiber':
          return Icons.eco;
        case 'Sugars':
          return Icons.cake;
        default:
          return Icons.info;
      }
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            getIconForLabel(),
            color: textColor,
            size: 18,
          ),
          const SizedBox(height: 1),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w500,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 1),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
