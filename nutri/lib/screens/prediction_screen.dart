import 'dart:io';
import 'package:flutter/material.dart';
import '../models/classifier.dart';
import '../models/prediction_history.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PredictionScreen extends StatefulWidget {
  final String imagePath;

  const PredictionScreen({
    super.key,
    required this.imagePath,
  });

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  PredictionResult? _prediction;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _classifyImage();
  }

  Future<void> _classifyImage() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final result = await Classifier.classifyImage(widget.imagePath, context);

      if (!mounted) return;

      setState(() {
        _prediction = result;
        _isLoading = false;
      });
    } on NotFoodException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'An error occurred while processing the image';
        _isLoading = false;
      });
    }
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.circleExclamation,
              size: 60,
              color: Colors.red[400],
            ),
            const SizedBox(height: 20),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const FaIcon(
                FontAwesomeIcons.arrowLeft,
                size: 16,
              ),
              label: const Text('Try Another Image'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
  if (didPop) return;
  Navigator.pop(context, _prediction);
},

      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Results',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.green[800],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context, _prediction),
          ),
          actions: [
            if (!_isLoading)
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: _classifyImage,
              ),
          ],
        ),
        backgroundColor: Colors.green[50],
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image with gradient overlay
              Container(
                height: 300,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow:const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // Image
                      Image.file(
                        File(widget.imagePath),
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      // Gradient overlay
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Results Section
              if (_isLoading) ...[
                const SizedBox(height: 40),
                Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        color: Colors.green[700],
                        strokeWidth: 3,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Analyzing your food...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (_error != null) ...[
                _buildErrorWidget(_error!),
              ] else if (_prediction != null) ...[
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.green,
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Header section with gradient
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.green[700]!,
                              Colors.green[600]!,
                            ],
                          ),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Food Analysis Results',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(
                                  Icons.restaurant,
                                  color: Colors.white70,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _prediction!.prediction.replaceAll('_', ' '),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),                     
                          ],
                        ),
                      ),

                      // Nutrition Information
                      if (_prediction!.weight != null) ...[
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.scale,
                                    color: Colors.green[700],
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Nutritional Information (${_prediction!.weight!.toStringAsFixed(0)}g serving)',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[700],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildNutritionGrid(),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionGrid() {
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
          '${_prediction!.calories?.toStringAsFixed(0)} kcal',
          FontAwesomeIcons.fire,
          const Color(0xFFFFB74D),
          const Color(0xFFFFF3E0),
        ),
        _buildNutritionTile(
          'Protein',
          '${_prediction!.protein?.toStringAsFixed(1)}g',
          FontAwesomeIcons.dumbbell,
          const Color(0xFFEF5350),
          const Color(0xFFFFEBEE),
        ),
        _buildNutritionTile(
          'Carbs',
          '${_prediction!.carbs?.toStringAsFixed(1)}g',
          FontAwesomeIcons.wheatAwn,
          const Color(0xFF8D6E63),
          const Color(0xFFEFEBE9),
        ),
        _buildNutritionTile(
          'Fats',
          '${_prediction!.fats?.toStringAsFixed(1)}g',
          FontAwesomeIcons.droplet,
          const Color(0xFFFFB300),
          const Color(0xFFFFF8E1),
        ),
        _buildNutritionTile(
          'Fiber',
          '${_prediction!.fiber?.toStringAsFixed(1)}g',
          FontAwesomeIcons.leaf,
          const Color(0xFF66BB6A),
          const Color(0xFFE8F5E9),
        ),
        _buildNutritionTile(
          'Sugars',
          '${_prediction!.sugars?.toStringAsFixed(1)}g',
          FontAwesomeIcons.candyCane,
          const Color(0xFFEC407A),
          const Color(0xFFFCE4EC),
        ),
        _buildNutritionTile(
          'Sodium',
          '${_prediction!.sodium?.toStringAsFixed(0)}mg',
          FontAwesomeIcons.water,
          const Color(0xFF42A5F5),
          const Color(0xFFE3F2FD),
        ),
      ],
    );
  }

  Widget _buildNutritionTile(String label, String value, IconData icon, Color color, Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          FaIcon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
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
}
