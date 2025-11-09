import 'package:equatable/equatable.dart';

class ClientInfo extends Equatable {
  final String name;
  final String address;
  final String reference;

  const ClientInfo({
    this.name = '',
    this.address = '',
    this.reference = '',
  });

  ClientInfo copyWith({
    String? name,
    String? address,
    String? reference,
  }) {
    return ClientInfo(
      name: name ?? this.name,
      address: address ?? this.address,
      reference: reference ?? this.reference,
    );
  }

  @override
  List<Object> get props => [name, address, reference];
}