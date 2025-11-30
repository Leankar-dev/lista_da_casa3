import '../../domain/entities/shopping_item.dart';
import '../database/app_database.dart';

/// Shopping Item Model - Data Transfer Object
class ShoppingItemModel extends ShoppingItem {
  const ShoppingItemModel({
    required super.id,
    required super.name,
    required super.quantity,
    required super.price,
    super.category,
    super.observations,
    super.isPurchased,
    required super.shoppingListId,
    required super.createdAt,
    required super.updatedAt,
  });

  /// From Entity
  factory ShoppingItemModel.fromEntity(ShoppingItem entity) {
    return ShoppingItemModel(
      id: entity.id,
      name: entity.name,
      quantity: entity.quantity,
      price: entity.price,
      category: entity.category,
      observations: entity.observations,
      isPurchased: entity.isPurchased,
      shoppingListId: entity.shoppingListId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// From Database Row
  factory ShoppingItemModel.fromDatabase(ShoppingItemsTableData data) {
    return ShoppingItemModel(
      id: data.id,
      name: data.name,
      quantity: data.quantity,
      price: data.price,
      category: data.category,
      observations: data.observations,
      isPurchased: data.isPurchased,
      shoppingListId: data.shoppingListId,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }

  /// From JSON (Firebase)
  factory ShoppingItemModel.fromJson(Map<String, dynamic> json) {
    return ShoppingItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String?,
      observations: json['observations'] as String?,
      isPurchased: json['isPurchased'] as bool? ?? false,
      shoppingListId: json['shoppingListId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// To JSON (Firebase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      'category': category,
      'observations': observations,
      'isPurchased': isPurchased,
      'shoppingListId': shoppingListId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// To Entity
  ShoppingItem toEntity() {
    return ShoppingItem(
      id: id,
      name: name,
      quantity: quantity,
      price: price,
      category: category,
      observations: observations,
      isPurchased: isPurchased,
      shoppingListId: shoppingListId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
