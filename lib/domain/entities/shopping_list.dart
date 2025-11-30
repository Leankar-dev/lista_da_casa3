import 'package:equatable/equatable.dart';
import 'shopping_item.dart';

/// Shopping List Status
enum ShoppingListStatus { active, finalized }

/// Shopping List Entity
class ShoppingList extends Equatable {
  final String id;
  final String? name;
  final String? marketId;
  final String? marketName;
  final ShoppingListStatus status;
  final List<ShoppingItem> items;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? finalizedAt;

  const ShoppingList({
    required this.id,
    this.name,
    this.marketId,
    this.marketName,
    this.status = ShoppingListStatus.active,
    this.items = const [],
    required this.createdAt,
    required this.updatedAt,
    this.finalizedAt,
  });

  double get totalValue => items.fold(0, (sum, item) => sum + item.totalPrice);

  double get purchasedValue => items
      .where((item) => item.isPurchased)
      .fold(0, (sum, item) => sum + item.totalPrice);

  int get totalItems => items.length;

  int get purchasedItems => items.where((item) => item.isPurchased).length;

  int get pendingItems => items.where((item) => !item.isPurchased).length;

  double get progress => totalItems > 0 ? purchasedItems / totalItems : 0;

  bool get isFinalized => status == ShoppingListStatus.finalized;

  bool get isActive => status == ShoppingListStatus.active;

  ShoppingList copyWith({
    String? id,
    String? name,
    String? marketId,
    String? marketName,
    ShoppingListStatus? status,
    List<ShoppingItem>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? finalizedAt,
  }) {
    return ShoppingList(
      id: id ?? this.id,
      name: name ?? this.name,
      marketId: marketId ?? this.marketId,
      marketName: marketName ?? this.marketName,
      status: status ?? this.status,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      finalizedAt: finalizedAt ?? this.finalizedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    marketId,
    marketName,
    status,
    items,
    createdAt,
    updatedAt,
    finalizedAt,
  ];
}
