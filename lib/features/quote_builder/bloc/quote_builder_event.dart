part of 'quote_builder_bloc.dart';

abstract class QuoteBuilderEvent extends Equatable {
  const QuoteBuilderEvent();
  @override
  List<Object> get props => [];
}

// Event for when client info is typed
class ClientInfoChanged extends QuoteBuilderEvent {
  final String name;
  final String address;
  final String reference;
  const ClientInfoChanged({required this.name, required this.address, required this.reference});
  @override
  List<Object> get props => [name, address, reference];
}

// Event to add a new, empty line item row
class LineItemAdded extends QuoteBuilderEvent {}

// Event to remove a specific line item row
class LineItemRemoved extends QuoteBuilderEvent {
  final String itemId;
  const LineItemRemoved(this.itemId);
  @override
  List<Object> get props => [itemId];
}

// Event to trigger calculation. Fired when numeric fields change.
class TotalsCalculated extends QuoteBuilderEvent {}