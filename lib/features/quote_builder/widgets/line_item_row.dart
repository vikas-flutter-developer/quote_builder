import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quote_builder/features/quote_builder/bloc/quote_builder_bloc.dart';
import 'package:quote_builder/features/quote_builder/models/line_item.dart';

class LineItemRow extends StatelessWidget {
  final LineItem lineItem;
  // final int index; // <-- 1. REMOVE THIS

  const LineItemRow({
    super.key,
    required this.lineItem,
    // required this.index, // <-- 2. REMOVE THIS
  });

  @override
  Widget build(BuildContext context) {
    // A helper to dispatch the calculate event
    void calculateTotals() {
      context.read<QuoteBuilderBloc>().add(TotalsCalculated());
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // --- Top Row: Name and Remove Button ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: lineItem.nameController,
                    decoration: const InputDecoration(
                      labelText: 'Product/Service Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline,
                      color: Theme.of(context).colorScheme.error),
                  tooltip: 'Remove Item',
                  onPressed: () {
                    context
                        .read<QuoteBuilderBloc>()
                        .add(LineItemRemoved(lineItem.id)); // <-- 3. FIX: Pass lineItem.id (String)
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            // --- Bottom Row: Numeric Inputs ---
            // Using Wrap for better responsiveness on small screens
            Wrap(
              runSpacing: 12.0,
              spacing: 12.0,
              children: [
                // 1. Quantity Field
                SizedBox(
                  width: 80, // Fixed width for smaller fields
                  child: TextFormField(
                    controller: lineItem.quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Qty',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (_) => calculateTotals(),
                  ),
                ),

                // 2. Rate Field
                SizedBox(
                  width: 120,
                  child: TextFormField(
                    controller: lineItem.rateController,
                    decoration: const InputDecoration(
                      labelText: 'Rate (₹)', // <-- FIXED: Changed $ to ₹
                    ),
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                    ],
                    onChanged: (_) => calculateTotals(),
                  ),
                ),

                // 3. Discount Field
                SizedBox(
                  width: 120,
                  child: TextFormField(
                    controller: lineItem.discountController,
                    decoration: const InputDecoration(
                      labelText: 'Discount (₹)', // <-- FIXED: Changed $ to ₹
                    ),
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                    ],
                    onChanged: (_) => calculateTotals(),
                  ),
                ),

                // 4. Tax % Field
                SizedBox(
                  width: 80,
                  child: TextFormField(
                    controller: lineItem.taxController,
                    decoration: const InputDecoration(
                      labelText: 'Tax %',
                    ),
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                    ],
                    onChanged: (_) => calculateTotals(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}