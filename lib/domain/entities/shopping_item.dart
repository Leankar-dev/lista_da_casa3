import 'package:equatable/equatable.dart';

class ShoppingItem extends Equatable {
  final String id;
  final String name;
  final int quantity;
  final double price;
  final String? category;
  final String? observations;
  final bool isPurchased;
  final String shoppingListId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ShoppingItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    this.category,
    this.observations,
    this.isPurchased = false,
    required this.shoppingListId,
    required this.createdAt,
    required this.updatedAt,
  });

  double get totalPrice => quantity * price;

  ShoppingItem copyWith({
    String? id,
    String? name,
    int? quantity,
    double? price,
    String? category,
    String? observations,
    bool? isPurchased,
    String? shoppingListId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      category: category ?? this.category,
      observations: observations ?? this.observations,
      isPurchased: isPurchased ?? this.isPurchased,
      shoppingListId: shoppingListId ?? this.shoppingListId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    quantity,
    price,
    category,
    observations,
    isPurchased,
    shoppingListId,
    createdAt,
    updatedAt,
  ];
}
