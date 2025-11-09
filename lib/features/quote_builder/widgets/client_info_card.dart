import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Make sure this import path is correct for your project
import 'package:quote_builder/features/quote_builder/bloc/quote_builder_bloc.dart';

class ClientInfoCard extends StatefulWidget {
  const ClientInfoCard({super.key});

  @override
  State<ClientInfoCard> createState() => _ClientInfoCardState();
}

class _ClientInfoCardState extends State<ClientInfoCard> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _referenceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onClientInfoChanged);
    _addressController.addListener(_onClientInfoChanged);
    _referenceController.addListener(_onClientInfoChanged);
  }

  void _onClientInfoChanged() {
    // Make sure your BLoC is provided higher up in the widget tree
    // (e.g., in your main.dart or the screen holding this card)
    context.read<QuoteBuilderBloc>().add(ClientInfoChanged(
      name: _nameController.text,
      address: _addressController.text,
      reference: _referenceController.text,
    ));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // --- MODIFICATION: Removed outer Padding ---
    // The SizedBox now forces the Card to fill the width of its parent
    return SizedBox(
      width: double.infinity,
      child: Card(
        // Set margin to zero horizontally, but keep the vertical space.
        // This makes the card go edge-to-edge.
        margin: const EdgeInsets.symmetric(vertical: 8.0),

        // --- ADD THIS LINE ---
        // By default, Card has a rounded shape. Set shape to
        // RectangleBorder to make it a sharp rectangle.
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        // --- End Add ---

        child: Padding(
          padding: const EdgeInsets.all(16.0), // This is the *internal* padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Client Information',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Client Name'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Client Address'),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                minLines: 1,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _referenceController,
                decoration: const InputDecoration(
                    labelText: 'Reference (e.g., INV-057)'),
                textInputAction: TextInputAction.done,
              ),
            ],
          ),
        ),
      ),
    );
    // --- End Modification ---
  }
}