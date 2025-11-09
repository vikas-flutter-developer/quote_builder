import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quote_builder/features/quote_builder/bloc/quote_builder_bloc.dart';
import 'package:quote_builder/features/quote_builder/screens/quote_preview_screen.dart';
import 'package:quote_builder/features/quote_builder/widgets/client_info_card.dart';
import 'package:quote_builder/features/quote_builder/widgets/line_item_list.dart';
import 'package:quote_builder/features/quote_builder/widgets/totals_summary.dart';

class QuoteFormScreen extends StatelessWidget {
  const QuoteFormScreen({super.key});

  // Helper method to navigate to the preview screen
  void _navigateToPreview(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<QuoteBuilderBloc>(context),
        child: const QuotePreviewScreen(),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Quote'),
        actions: [
          // Button to navigate to the Preview Screen (Eye Icon)
          IconButton(
            icon: const Icon(Icons.visibility),
            tooltip: 'Preview Quote',
            onPressed: () => _navigateToPreview(context),
          ),
        ],
      ),
      body: BlocBuilder<QuoteBuilderBloc, QuoteBuilderState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Client Info Form
                const ClientInfoCard(),
                const SizedBox(height: 24),

                // 2. Line Items List
                const LineItemList(),
                const SizedBox(height: 16),

                // 3. Add Item Button
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Line Item'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    context.read<QuoteBuilderBloc>().add(LineItemAdded());
                  },
                ),
                const SizedBox(height: 24),

                // 4. Totals Display
                TotalsSummary(
                  subtotal: state.subtotal,
                  grandTotal: state.grandTotal,
                ),
                const SizedBox(height: 40),

                // 5. Create Invoice Button (New Requirement)
                ElevatedButton.icon(
                  icon: const Icon(Icons.receipt),
                  label: const Text('Create Invoice'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Theme.of(context).primaryColor, // Use primary color for main action
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => _navigateToPreview(context), // Same navigation logic as the eye button
                ),
                const SizedBox(height: 20), // Add some spacing at the very bottom
              ],
            ),
          );
        },
      ),
    );
  }
}