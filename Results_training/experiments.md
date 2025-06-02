# Model Training Experiments

This document details the hyperparameters and results of the seven experiments conducted to train the food recognition model on the Food-101 dataset. Each experiment is presented in table format for clarity.

---

## Experiment 1: Basic Training

| Hyperparameter      | Value                      |
|---------------------|----------------------------|
| Model               | ResNet50 (pretrained)      |
| Batch Size          | 256                        |
| Epochs              | 5                          |
| Learning Rate       | 0.001                      |
| Optimizer           | Adam                       |
| Loss Function       | Cross Entropy              |
| Regularization      | None                       |
| Data Augmentation   | None                       |
| Frozen Layers       | All except final layer     |
| Training / Val Acc  | **61.29% / 65.52%**        |
| Training / Val Loss | **1.6 / 1.45**             |

---

## Experiment 2: Increased Epochs and L2 Regularization

| Hyperparameter      | Value                      |
|---------------------|----------------------------|
| Model               | ResNet50 (pretrained)      |
| Batch Size          | 256                        |
| Epochs              | 10                         |
| Learning Rate       | 0.001                      |
| Optimizer           | Adam (weight_decay=1e-3)   |
| Loss Function       | Cross Entropy              |
| Regularization      | L2 (weight_decay=1e-3)     |
| Data Augmentation   | None                       |
| Frozen Layers       | All except final layer     |
| Training / Val Acc  | **60.20% / 63.96%**        |
| Training / Val Loss | **1.8 / 1.65**             |

---

## Experiment 3: Reduced Batch Size and Layer Unfreezing

| Hyperparameter      | Value                          |
|---------------------|--------------------------------|
| Model               | ResNet50 (pretrained)          |
| Batch Size          | 128                            |
| Epochs              | 10                             |
| Learning Rate       | 0.001                          |
| Optimizer           | Adam (weight_decay=1e-3)       |
| Loss Function       | Cross Entropy                  |
| Regularization      | L2 (weight_decay=1e-3)         |
| Data Augmentation   | None                           |
| Frozen Layers       | All except layer4 and fc       |
| Training / Val Acc  | **94.47% / 82.00%**            |
| Training / Val Loss | **0.18 / 0.75**                |

---

## Experiment 4: Dropout and Data Augmentation

| Hyperparameter      | Value                                      |
|---------------------|--------------------------------------------|
| Model               | ResNet50 (pretrained)                      |
| Batch Size          | 128                                        |
| Epochs              | 10                                         |
| Learning Rate       | 0.001                                      |
| Optimizer           | Adam (weight_decay=1e-3)                   |
| Loss Function       | Cross Entropy                              |
| Regularization      | L2 (1e-3), Dropout (0.5)                   |
| Data Augmentation   | Horizontal Flip, ±15° Rotation, Color Jitter |
| LR Scheduler        | StepLR (step_size=3, gamma=0.1)            |
| Frozen Layers       | All except layer4 and fc                   |
| Training / Val Acc  | **76.94% / 83.37%**                        |
| Training / Val Loss | **0.85 / 0.6**                             |

---

## Experiment 5: Adjusted Dropout and Layer Unfreezing

| Hyperparameter      | Value                                           |
|---------------------|-------------------------------------------------|
| Model               | ResNet50 (pretrained)                           |
| Batch Size          | 128                                             |
| Epochs              | 10                                              |
| Learning Rate       | 0.001                                           |
| Optimizer           | Adam (weight_decay=1e-3)                        |
| Loss Function       | Cross Entropy                                   |
| Regularization      | L2 (1e-3), Dropout (0.3)                        |
| Data Augmentation   | Flip, ±10° Rotation, Color Jitter, Resized Crop |
| LR Scheduler        | StepLR (step_size=3, gamma=0.1)                 |
| Frozen Layers       | All except layer3, layer4, and fc              |
| Training / Val Acc  | **67.97% / 76.03%**                             |
| Training / Val Loss | **1.3 / 0.5**                                   |

---

## Experiment 6: Optimized Hyperparameters

| Hyperparameter      | Value                                           |
|---------------------|-------------------------------------------------|
| Model               | ResNet50 (pretrained)                           |
| Batch Size          | 256                                             |
| Epochs              | 15                                              |
| Learning Rate       | 0.0005                                          |
| Optimizer           | Adam (weight_decay=5e-4)                        |
| Loss Function       | Cross Entropy                                   |
| Regularization      | L2 (5e-4), Dropout (0.3)                        |
| Data Augmentation   | Flip, Rotation, Color Jitter, Crop, Erasing     |
| LR Scheduler        | ReduceLROnPlateau (patience=2, factor=0.5)      |
| Frozen Layers       | All except layer3, layer4, and fc              |
| Training / Val Acc  | **86.50% / 85.08%**                             |
| Training / Val Loss | **0.45 / 0.5**                                  |

---

## Experiment 7: Extended Training (Best Results)

| Hyperparameter      | Value                                           |
|---------------------|-------------------------------------------------|
| Model               | ResNet50 (pretrained)                           |
| Batch Size          | 256                                              |
| Epochs              | 20                                              |
| Learning Rate       | 0.0005                                          |
| Optimizer           | Adam (weight_decay=5e-4)                        |
| Loss Function       | Cross Entropy                                   |
| Regularization      | L2 (5e-4), Dropout (0.3)                        |
| Data Augmentation   | Flip, Rotation, Color Jitter, Crop, Erasing     |
| LR Scheduler        | StepLR (step_size=5, gamma=0.2)                 |
| Frozen Layers       | All except layer3, layer4, and fc              |
| Training / Val Acc  | **88.17% / 85.55%**                             |
| Training / Val Loss | **0.3 / 0.5**                                   |

---

## Conclusion

Experiment 7 produced the best results with the highest validation accuracy of **85.55%**. The key factors that contributed to this success were:

1. Extended training to 20 epochs  
2. Smaller batch size (64) for better generalization  
3. Lower learning rate (0.0005) with StepLR scheduler  
4. Balanced regularization with L2 and Dropout  
5. Comprehensive data augmentation strategy  
6. Selective layer unfreezing (layer3, layer4, and fc)

The final model from Experiment 7 was saved as `food101_model.pth` and is used in the **NutriScan** application for food recognition.
