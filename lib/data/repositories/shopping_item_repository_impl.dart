import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/shopping_item.dart';
import '../../domain/repositories/i_shopping_item_repository.dart';
import '../database/app_database.dart';
import '../models/shopping_item_model.dart';

/// Shopping Item Repository Implementation using Drift
class ShoppingItemRepositoryImpl implements IShoppingItemRepository {
  final AppDatabase _database;

  ShoppingItemRepositoryImpl(this._database);

  @override
  Future<List<ShoppingItem>> getItemsByListId(String listId) async {
    debugPrint('📦 [Repository] Getting items for listId: $listId');
    final items = await _database.getShoppingItemsByListId(listId);
    debugPrint('📦 [Repository] Found ${items.length} items');
    return items.map((item) => ShoppingItemModel.fromDatabase(item)).toList();
  }

  @override
  Future<ShoppingItem?> getItemById(String id) async {
    final item = await _database.getShoppingItemById(id);
    if (item == null) return null;
    return ShoppingItemModel.fromDatabase(item);
  }

  @override
  Future<void> addItem(ShoppingItem item) async {
    debugPrint(
      '📦 [Repository] Adding item: ${item.name} to list: ${item.shoppingListId}',
    );
    final companion = ShoppingItemsTableCompanion.insert(
      id: item.id,
      name: item.name,
      quantity: Value(item.quantity),
      price: Value(item.price),
      category: Value(item.category),
      observations: Value(item.observations),
      isPurchased: Value(item.isPurchased),
      shoppingListId: item.shoppingListId,
      createdAt: Value(item.createdAt),
      updatedAt: Value(item.updatedAt),
    );
    final result = await _database.insertShoppingItem(companion);
    debugPrint('📦 [Repository] Insert result: $result');
  }

  @override
  Future<void> updateItem(ShoppingItem item) async {
    final companion = ShoppingItemsTableCompanion(
      id: Value(item.id),
      name: Value(item.name),
      quantity: Value(item.quantity),
      price: Value(item.price),
      category: Value(item.category),
      observations: Value(item.observations),
      isPurchased: Value(item.isPurchased),
      shoppingListId: Value(item.shoppingListId),
      createdAt: Value(item.createdAt),
      updatedAt: Value(DateTime.now()),
    );
    await _database.updateShoppingItem(companion);
  }

  @override
  Future<void> deleteItem(String id) async {
    await _database.deleteShoppingItem(id);
  }

  @override
  Future<void> togglePurchased(String id, bool isPurchased) async {
    final item = await _database.getShoppingItemById(id);
    if (item != null) {
      final companion = ShoppingItemsTableCompanion(
        id: Value(item.id),
        name: Value(item.name),
        quantity: Value(item.quantity),
        price: Value(item.price),
        category: Value(item.category),
        observations: Value(item.observations),
        isPurchased: Value(isPurchased),
        shoppingListId: Value(item.shoppingListId),
        createdAt: Value(item.createdAt),
        updatedAt: Value(DateTime.now()),
      );
      await _database.updateShoppingItem(companion);
    }
  }

  @override
  Future<void> deleteItemsByListId(String listId) async {
    await _database.deleteShoppingItemsByListId(listId);
  }

  @override
  Stream<List<ShoppingItem>> watchItemsByListId(String listId) {
    return _database
        .watchShoppingItemsByListId(listId)
        .map(
          (items) => items
              .map((item) => ShoppingItemModel.fromDatabase(item))
              .toList(),
        );
  }
}
