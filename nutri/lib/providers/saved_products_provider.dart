import 'package:flutter/material.dart';

class SavedProductsProvider extends InheritedWidget {
  final List<Map<String, dynamic>> savedProducts;
  final Function(Map<String, dynamic>) addProduct;
  final Function(String) removeProduct;

  const SavedProductsProvider({
    super.key,
    required this.savedProducts,
    required this.addProduct,
    required this.removeProduct,
    required super.child,
  });

  static SavedProductsProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SavedProductsProvider>();
  }

  static SavedProductsProvider of(BuildContext context) {
    final SavedProductsProvider? result = maybeOf(context);
    assert(result != null, 'No SavedProductsProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(SavedProductsProvider oldWidget) {
    return savedProducts != oldWidget.savedProducts;
  }
} 