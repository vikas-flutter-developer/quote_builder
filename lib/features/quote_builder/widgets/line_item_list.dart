import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quote_builder/features/quote_builder/bloc/quote_builder_bloc.dart';
import 'package:quote_builder/features/quote_builder/widgets/line_item_row.dart';

// Class name changed from LineItemListView to LineItemList
class LineItemList extends StatelessWidget {
  const LineItemList({super.key});

  @override
  Widget build(BuildContext context) {
    // This widget only needs to read the list of items from the state
    final items = context.select((QuoteBuilderBloc bloc) => bloc.state.lineItems);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (items.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
            child: Text('Line Items', style: Theme.of(context).textTheme.titleLarge),
          ),
        // Build a list of LineItemRow widgets
        ListView.builder(
          itemCount: items.length,
          shrinkWrap: true, // Important inside a SingleChildScrollView
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final item = items[index];
            return LineItemRow(
              key: ValueKey(item.id), // Use a key for efficient list updates
              lineItem: item, // <-- FIX: Changed 'item' to 'lineItem'
            );
          },
        ),
      ],
    );
  }
}