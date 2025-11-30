import '../../domain/entities/shopping_list.dart';
import '../../domain/entities/shopping_item.dart';
import '../database/app_database.dart';
import 'shopping_item_model.dart';

class ShoppingListModel extends ShoppingList {
  const ShoppingListModel({
    required super.id,
    super.name,
    super.marketId,
    super.marketName,
    super.status,
    super.items,
    required super.createdAt,
    required super.updatedAt,
    super.finalizedAt,
  });

  factory ShoppingListModel.fromEntity(ShoppingList entity) {
    return ShoppingListModel(
      id: entity.id,
      name: entity.name,
      marketId: entity.marketId,
      marketName: entity.marketName,
      status: entity.status,
      items: entity.items,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      finalizedAt: entity.finalizedAt,
    );
  }

  factory ShoppingListModel.fromDatabase(
    ShoppingListsTableData data, {
    List<ShoppingItem> items = const [],
  }) {
    return ShoppingListModel(
      id: data.id,
      name: data.name,
      marketId: data.marketId,
      marketName: data.marketName,
      status: data.status == 'active'
          ? ShoppingListStatus.active
          : ShoppingListStatus.finalized,
      items: items,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      finalizedAt: data.finalizedAt,
    );
  }

  factory ShoppingListModel.fromJson(Map<String, dynamic> json) {
    final itemsList =
        (json['items'] as List<dynamic>?)
            ?.map(
              (item) =>
                  ShoppingItemModel.fromJson(item as Map<String, dynamic>),
            )
            .toList() ??
        [];

    return ShoppingListModel(
      id: json['id'] as String,
      name: json['name'] as String?,
      marketId: json['marketId'] as String?,
      marketName: json['marketName'] as String?,
      status: json['status'] == 'active'
          ? ShoppingListStatus.active
          : ShoppingListStatus.finalized,
      items: itemsList,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      finalizedAt: json['finalizedAt'] != null
          ? DateTime.parse(json['finalizedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'marketId': marketId,
      'marketName': marketName,
      'status': status == ShoppingListStatus.active ? 'active' : 'finalized',
      'items': items
          .map((item) => ShoppingItemModel.fromEntity(item).toJson())
          .toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'finalizedAt': finalizedAt?.toIso8601String(),
    };
  }

  ShoppingList toEntity() {
    return ShoppingList(
      id: id,
      name: name,
      marketId: marketId,
      marketName: marketName,
      status: status,
      items: items,
      createdAt: createdAt,
      updatedAt: updatedAt,
      finalizedAt: finalizedAt,
    );
  }
}
