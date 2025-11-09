import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quote_builder/features/quote_builder/models/client_info.dart';
import 'package:quote_builder/features/quote_builder/models/line_item.dart';
import 'package:uuid/uuid.dart';

part 'quote_builder_event.dart';
part 'quote_builder_state.dart';

class QuoteBuilderBloc extends Bloc<QuoteBuilderEvent, QuoteBuilderState> {
  final _uuid = const Uuid();

  QuoteBuilderBloc() : super(QuoteBuilderState.initial()) {
    on<ClientInfoChanged>(_onClientInfoChanged);
    on<LineItemAdded>(_onLineItemAdded);
    on<LineItemRemoved>(_onLineItemRemoved);
    on<TotalsCalculated>(_onTotalsCalculated);
  }

  void _onClientInfoChanged(ClientInfoChanged event, Emitter<QuoteBuilderState> emit) {
    emit(state.copyWith(
      clientInfo: state.clientInfo.copyWith(
        name: event.name,
        address: event.address,
        reference: event.reference,
      ),
    ));
  }

  void _onLineItemAdded(LineItemAdded event, Emitter<QuoteBuilderState> emit) {
    final newItem = LineItem(id: _uuid.v4());
    final updatedList = List<LineItem>.from(state.lineItems)..add(newItem);
    emit(state.copyWith(lineItems: updatedList));
  }

  void _onLineItemRemoved(LineItemRemoved event, Emitter<QuoteBuilderState> emit) {
    final updatedList = List<LineItem>.from(state.lineItems);
    final itemToRemove = updatedList.firstWhere((item) => item.id == event.itemId);

    // IMPORTANT: Dispose controllers to prevent memory leaks
    itemToRemove.dispose();

    updatedList.removeWhere((item) => item.id == event.itemId);
    emit(state.copyWith(lineItems: updatedList));

    // Recalculate totals after removing an item
    add(TotalsCalculated());
  }

  void _onTotalsCalculated(TotalsCalculated event, Emitter<QuoteBuilderState> emit) {
    double currentSubtotal = 0.0;

    for (final item in state.lineItems) {
      final double quantity = double.tryParse(item.quantityController.text) ?? 0;
      final double rate = double.tryParse(item.rateController.text) ?? 0;
      final double discount = double.tryParse(item.discountController.text) ?? 0;
      final double taxPercent = double.tryParse(item.taxController.text) ?? 0;

      // This is the calculation logic from the PDF
      // ((rate - discount) * quantity) + tax
      // We interpret "tax" as a percentage of the (rate-discount)*quantity
      final double basePrice = (rate - discount) * quantity;
      final double taxAmount = basePrice * (taxPercent / 100);
      final double lineTotal = basePrice + taxAmount;

      item.lineTotal = lineTotal; // Store the calculated total
      currentSubtotal += lineTotal;
    }

    emit(state.copyWith(
      subtotal: currentSubtotal,
      grandTotal: currentSubtotal, // Grand total is the same as subtotal for this task
    ));
  }

  // Override close to dispose all controllers when BLoC is closed
  @override
  Future<void> close() {
    for (final item in state.lineItems) {
      item.dispose();
    }
    return super.close();
  }
}