import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

// This model holds the controllers for a single row.
// This is key for performance, so the BLoC doesn't rebuild on every keystroke.
class LineItem {
  final String id;
  final TextEditingController nameController;
  final TextEditingController quantityController;
  final TextEditingController rateController;
  final TextEditingController discountController;
  final TextEditingController taxController;
  double lineTotal;

  LineItem({
    required this.id,
    double initialTotal = 0.0,
  })  : nameController = TextEditingController(),
        quantityController = TextEditingController(),
        rateController = TextEditingController(),
        discountController = TextEditingController(),
        taxController = TextEditingController(),
        lineTotal = initialTotal;

  // Helper to dispose all controllers when an item is removed
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    rateController.dispose();
    discountController.dispose();
    taxController.dispose();
  }
}