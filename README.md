# NutriScan

NutriScan is a mobile application that helps users identify food items and provides nutritional information. The app uses computer vision to recognize food from images and barcode scanning for packaged foods.

## Project Structure

- **nutri/**: Flutter mobile application
  - **lib/**: Main application code
    - **config/**: Configuration files
    - **models/**: Data models
    - **providers/**: State management
    - **screens/**: UI screens
    - **services/**: API and service integrations
    - **widgets/**: Reusable UI components
  - **assets/**: Images, fonts, and other static assets
  - **android/**, **ios/**, **web/**, **linux/**, **macos/**, **windows/**: Platform-specific code

- **Results_training/**: Contains results from model training experiments
  - **experiments.md**: Detailed information about each experiment
  - PNG files showing training results for each experiment

- **Food-101/**: Dataset used for training the food recognition model
- **nutrition.csv**: Nutritional information database for food items
- **food101_model.pth**: Trained model weights
- **model_train_test_20_(kaggle).ipynb**: Jupyter notebook for model training

## Models

Due to size limitations, the model files are not included in this repository. You will need to download them separately:

1. Food Recognition Model (`food101_model.pth`):
   - Place in the root directory
   - Used for training and evaluation
   - Size: ~90MB

2. Mobile Model (`food101_model_mobile.pt`):
   - Place in `nutri/assets/models/`
   - Optimized for mobile deployment
   - Size: ~90MB

You can download the models from [provide your preferred file sharing service link].

## Features

- **Food Recognition**: Upload images of food to identify them
- **Barcode Scanning**: Scan product barcodes to get nutritional information
- **Nutritional Information**: View detailed nutritional data for identified foods
- **History**: Keep track of previously scanned foods
- **Dark Theme**: Modern UI with a dark theme that aligns with the app's branding
- **Cross-platform**: Available on iOS and Android

## Model Training

The food recognition model was trained on the Food-101 dataset using ResNet architecture. Seven experiments were conducted to optimize the model's performance:

1. **Experiment 1**: Basic training with 256 batch size, 5 epochs, no regularization
2. **Experiment 2**: Increased epochs to 10, added L2 regularization (1e-3)
3. **Experiment 3**: Reduced batch size to 128, unfroze 2 layers (layer4, fc)
4. **Experiment 4**: Added dropout (50%), data augmentation, StepLR scheduler
5. **Experiment 5**: Adjusted dropout to 30%, unfroze 3 layers, modified augmentation
6. **Experiment 6**: Optimized hyperparameters for better performance
7. **Experiment 7**: Extended training to 20 epochs (best results)

For detailed information about each experiment, see [experiments.md](Results_training/experiments.md).

Best model results (Experiment 7):
- Training Accuracy: 93.8%
- Validation Accuracy: 88.2%

## Nutritional Data

The nutritional information is sourced from a comprehensive database (nutrition.csv) and is also available in Supabase for integration with the Flutter app. The database includes:

- Food labels
- Serving weights
- Calories
- Macronutrients (protein, carbohydrates, fats)
- Micronutrients (fiber, sugars, sodium)

## Getting Started

### Prerequisites

- Flutter SDK
- Android Studio / Xcode
- Python 3.8+ (for model training)
- PyTorch
- Supabase account (for backend integration)

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/SanaD-03-alali/NutriScan.git
   cd NutriScan
   ```

2. Download the model files and place them in their respective directories as described in the Models section.

3. Install Flutter dependencies:
   ```
   cd nutri
   flutter pub get
   ```

4. Run the app:
   ```
   flutter run
   ```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Food-101 dataset for food recognition training
- Flutter framework for mobile app development
- Supabase for backend services 