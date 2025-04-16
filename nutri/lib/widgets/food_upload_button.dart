import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../screens/prediction_screen.dart';
import '../models/prediction_history.dart';

class FoodUploadButton extends StatelessWidget {
  final Function(PredictionResult) onNewPrediction;

  const FoodUploadButton({
    super.key,
    required this.onNewPrediction,
  });

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null && context.mounted) {
        // Navigate to PredictionScreen and wait for result
        final prediction = await Navigator.push<PredictionResult>(
          context,
          MaterialPageRoute(
            builder: (context) => PredictionScreen(imagePath: image.path),
          ),
        );
        
        // If we got a prediction back, add it to history
        if (prediction != null && context.mounted) {
          onNewPrediction(prediction);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2C7D4C), // Lighter green
            Color(0xFF0F3517), // Darker green
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _pickImage(context),
          borderRadius: BorderRadius.circular(22),
          splashColor: Colors.greenAccent.withOpacity(0.2),
          highlightColor: Colors.greenAccent.withOpacity(0.1),
          child: Row(
            children: [
              const SizedBox(width: 20),
              // Left side icon in circle
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A1C0E), // Very dark green
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.greenAccent.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.restaurant_menu,
                  size: 36,
                  color: Colors.greenAccent,
                ),
              ),
              const SizedBox(width: 20),
              // Right side text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Upload Food Image',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            color: Colors.black45,
                            offset: Offset(1, 1),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap to select from gallery',
                      style: TextStyle(
                        color: Colors.greenAccent.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }
}