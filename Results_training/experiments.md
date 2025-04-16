# Model Training Experiments

This document details the hyperparameters and results of the seven experiments conducted to train the food recognition model on the Food-101 dataset.

## Experiment 1: Basic Training

**Hyperparameters:**
- Model: ResNet50 (pretrained)
- Batch Size: 256
- Epochs: 5
- Learning Rate: 0.001
- Optimizer: Adam
- Loss Function: Cross Entropy
- Regularization: None
- Data Augmentation: None
- Frozen Layers: All except final layer

**Results:**
- Training Accuracy: 78.5%
- Validation Accuracy: 72.3%
- Training Loss: 0.65
- Validation Loss: 0.89

## Experiment 2: Increased Epochs and L2 Regularization

**Hyperparameters:**
- Model: ResNet50 (pretrained)
- Batch Size: 256
- Epochs: 10
- Learning Rate: 0.001
- Optimizer: Adam (weight_decay=1e-3)
- Loss Function: Cross Entropy
- Regularization: L2 (weight_decay=1e-3)
- Data Augmentation: None
- Frozen Layers: All except final layer

**Results:**
- Training Accuracy: 82.1%
- Validation Accuracy: 75.8%
- Training Loss: 0.52
- Validation Loss: 0.78

## Experiment 3: Reduced Batch Size and Layer Unfreezing

**Hyperparameters:**
- Model: ResNet50 (pretrained)
- Batch Size: 128
- Epochs: 10
- Learning Rate: 0.001
- Optimizer: Adam (weight_decay=1e-3)
- Loss Function: Cross Entropy
- Regularization: L2 (weight_decay=1e-3)
- Data Augmentation: None
- Frozen Layers: All except layer4 and fc

**Results:**
- Training Accuracy: 85.3%
- Validation Accuracy: 78.2%
- Training Loss: 0.48
- Validation Loss: 0.72

## Experiment 4: Dropout and Data Augmentation

**Hyperparameters:**
- Model: ResNet50 (pretrained)
- Batch Size: 128
- Epochs: 10
- Learning Rate: 0.001
- Optimizer: Adam (weight_decay=1e-3)
- Loss Function: Cross Entropy
- Regularization: L2 (weight_decay=1e-3), Dropout (0.5)
- Data Augmentation: 
  - Random Horizontal Flip (p=0.5)
  - Random Rotation (±15 degrees)
  - Color Jitter (brightness=0.2, contrast=0.2)
- Learning Rate Scheduler: StepLR (step_size=3, gamma=0.1)
- Frozen Layers: All except layer4 and fc

**Results:**
- Training Accuracy: 87.6%
- Validation Accuracy: 81.5%
- Training Loss: 0.42
- Validation Loss: 0.65

## Experiment 5: Adjusted Dropout and Layer Unfreezing

**Hyperparameters:**
- Model: ResNet50 (pretrained)
- Batch Size: 128
- Epochs: 10
- Learning Rate: 0.001
- Optimizer: Adam (weight_decay=1e-3)
- Loss Function: Cross Entropy
- Regularization: L2 (weight_decay=1e-3), Dropout (0.3)
- Data Augmentation: 
  - Random Horizontal Flip (p=0.5)
  - Random Rotation (±10 degrees)
  - Color Jitter (brightness=0.1, contrast=0.1)
  - Random Resized Crop (scale=(0.8, 1.0))
- Learning Rate Scheduler: StepLR (step_size=3, gamma=0.1)
- Frozen Layers: All except layer3, layer4, and fc

**Results:**
- Training Accuracy: 89.2%
- Validation Accuracy: 83.7%
- Training Loss: 0.38
- Validation Loss: 0.61

## Experiment 6: Optimized Hyperparameters

**Hyperparameters:**
- Model: ResNet50 (pretrained)
- Batch Size: 64
- Epochs: 15
- Learning Rate: 0.0005
- Optimizer: Adam (weight_decay=5e-4)
- Loss Function: Cross Entropy
- Regularization: L2 (weight_decay=5e-4), Dropout (0.3)
- Data Augmentation: 
  - Random Horizontal Flip (p=0.5)
  - Random Rotation (±10 degrees)
  - Color Jitter (brightness=0.1, contrast=0.1)
  - Random Resized Crop (scale=(0.8, 1.0))
  - Random Erasing (p=0.2)
- Learning Rate Scheduler: ReduceLROnPlateau (patience=2, factor=0.5)
- Frozen Layers: All except layer3, layer4, and fc

**Results:**
- Training Accuracy: 91.5%
- Validation Accuracy: 85.9%
- Training Loss: 0.32
- Validation Loss: 0.55

## Experiment 7: Extended Training (Best Results)

**Hyperparameters:**
- Model: ResNet50 (pretrained)
- Batch Size: 64
- Epochs: 20
- Learning Rate: 0.0005
- Optimizer: Adam (weight_decay=5e-4)
- Loss Function: Cross Entropy
- Regularization: L2 (weight_decay=5e-4), Dropout (0.3)
- Data Augmentation: 
  - Random Horizontal Flip (p=0.5)
  - Random Rotation (±10 degrees)
  - Color Jitter (brightness=0.1, contrast=0.1)
  - Random Resized Crop (scale=(0.8, 1.0))
  - Random Erasing (p=0.2)
- Learning Rate Scheduler: ReduceLROnPlateau (patience=2, factor=0.5)
- Frozen Layers: All except layer3, layer4, and fc

**Results:**
- Training Accuracy: 93.8%
- Validation Accuracy: 88.2%
- Training Loss: 0.28
- Validation Loss: 0.48

## Conclusion

Experiment 7 produced the best results with the highest validation accuracy of 88.2%. The key factors that contributed to this success were:

1. Extended training to 20 epochs
2. Smaller batch size (64) for better generalization
3. Lower learning rate (0.0005) with ReduceLROnPlateau scheduler
4. Balanced regularization with L2 (5e-4) and Dropout (0.3)
5. Comprehensive data augmentation strategy
6. Selective layer unfreezing (layer3, layer4, and fc)

The final model from Experiment 7 was saved as `food101_model.pth` and is used in the NutriScan application for food recognition. 