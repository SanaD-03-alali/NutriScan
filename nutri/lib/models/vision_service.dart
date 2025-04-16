import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

class VisionService {
  static final model = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey: 'AIzaSyDd-VzY_kW3fJbG_yyzZXo_u3h1qPnRFTY',
  );

  static Future<bool> isFood(String imagePath) async {
    try {
      final file = File(imagePath);
      final bytes = await file.readAsBytes();
      
      const prompt = '''
        Is this image of food?
        Answer with only "yes" or "no".
        If you see any kind of food or beverage in the image, answer "yes".
        If there is no food or beverage at all, answer "no".
      ''';

      final response = await model.generateContent([
        Content.text(prompt),
        Content.data('image/jpeg', bytes),  
      ]);

      final text = response.text?.toLowerCase().trim() ?? 'no';
      return text == 'yes';

    } catch (e) {
      rethrow;
    }
  }
}