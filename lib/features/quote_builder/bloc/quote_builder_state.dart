part of 'quote_builder_bloc.dart';

class QuoteBuilderState extends Equatable {
  final ClientInfo clientInfo;
  final List<LineItem> lineItems;
  final double subtotal;
  final double grandTotal;

  const QuoteBuilderState({
    required this.clientInfo,
    required this.lineItems,
    this.subtotal = 0.0,
    this.grandTotal = 0.0,
  });

  factory QuoteBuilderState.initial() {
    return const QuoteBuilderState(
      clientInfo: ClientInfo(),
      lineItems: [],
    );
  }

  QuoteBuilderState copyWith({
    ClientInfo? clientInfo,
    List<LineItem>? lineItems,
    double? subtotal,
    double? grandTotal,
  }) {
    return QuoteBuilderState(
      clientInfo: clientInfo ?? this.clientInfo,
      lineItems: lineItems ?? this.lineItems,
      subtotal: subtotal ?? this.subtotal,
      grandTotal: grandTotal ?? this.grandTotal,
    );
  }

  @override
  List<Object> get props => [clientInfo, lineItems, subtotal, grandTotal];
}