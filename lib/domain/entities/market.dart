import 'package:equatable/equatable.dart';

/// Market Entity
class Market extends Equatable {
  final String id;
  final String name;
  final String? address;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Market({
    required this.id,
    required this.name,
    this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  Market copyWith({
    String? id,
    String? name,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Market(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, name, address, createdAt, updatedAt];
}
