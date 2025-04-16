# NutriScan

NutriScan is a mobile application that helps users identify food items and provides nutritional information. The app uses image processing techniques to recognize food from images and barcode scanning for packaged foods.

## Demo
[Demo](https://github.com/SanaD-03-alali/NutriScan/blob/main/demo.mp4)

## Project Structure

- `nutri/`: Flutter mobile application
  - `lib/`: Main application code
    - `config/`: Configuration files
    - `models/`: Data models
    - `providers/`: State management
    - `screens/`: UI screens
    - `services/`: API and service integrations
    - `widgets/`: Reusable UI components
  - `assets/`: Images, fonts, and other static assets
  - `android/`, `ios/`, `web/`, `linux/`, `macos/`, `windows/`: Platform-specific code

- `Results_training/`: Contains results from model training experiments
  - [`experiments.md`](Results_training/experiments.md): Detailed information about each experiment
  - PNG files showing training results for each experiment

- `Food-101/`: Dataset used for training the food recognition model
- `nutrition.csv`: Nutritional information database for food items
- [`food101_model.pth`](food101_model.pth): Trained model weights
- [`model_train_test_20_(kaggle).ipynb`](model_train_test_20_(kaggle).ipynb): Jupyter notebook for model training

## Models

The model files are available in the repository:

1. Food Recognition Model ([`food101_model.pth`](food101_model.pth)):
   - Located in the root directory
   - Used for training and evaluation
   - Size: ~90MB

2. Mobile Model ([`food101_model_mobile.pt`](nutri/assets/models/food101_model_mobile.pt)):
   - Located in `nutri/assets/models/`
   - Optimized for mobile deployment
   - Size: ~90MB

## Model Training

For detailed information about the model training process and experiments conducted, see [`experiments.md`](Results_training/experiments.md).

## Nutritional Data

The nutritional information is sourced from a comprehensive database (`nutrition.csv`) and is also available in Supabase for integration with the Flutter app. The database includes:

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

2. Install Flutter dependencies:
   ```
   cd nutri
   flutter pub get
   ```

3. Run the app:
   ```
   flutter run
   ```

## Acknowledgments

- [Food-101 dataset](https://www.kaggle.com/datasets/kmader/food41) for food recognition training
- Flutter framework for mobile app development
- Supabase for backend services
