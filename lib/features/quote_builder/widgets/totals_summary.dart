import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Class name changed from TotalsDisplay to TotalsSummary
class TotalsSummary extends StatelessWidget {
  final double subtotal;
  final double grandTotal;

  const TotalsSummary({
    super.key,
    required this.subtotal,
    required this.grandTotal,
  });

  @override
  Widget build(BuildContext context) {
    // Use the intl package for clean currency formatting
    final currencyFormat = NumberFormat.simpleCurrency(locale: 'en_IN');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTotalRow(
              context: context,
              title: 'Subtotal',
              amount: currencyFormat.format(subtotal),
            ),
            const SizedBox(height: 8),
            _buildTotalRow(
              context: context,
              title: 'Grand Total',
              amount: currencyFormat.format(grandTotal),
              isGrandTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow({
    required BuildContext context,
    required String title,
    required String amount,
    bool isGrandTotal = false,
  }) {
    final textStyle = isGrandTotal
        ? Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
        : Theme.of(context).textTheme.titleMedium;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: textStyle),
        Text(amount, style: textStyle),
      ],
    );
  }
}