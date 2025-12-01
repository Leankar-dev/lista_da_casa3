import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/shopping_list.dart';
import '../../domain/repositories/i_shopping_list_repository.dart';
import '../database/app_database.dart';
import '../models/shopping_list_model.dart';
import '../models/shopping_item_model.dart';

class ShoppingListRepositoryImpl implements IShoppingListRepository {
  final AppDatabase _database;

  ShoppingListRepositoryImpl(this._database);

  @override
  Future<List<ShoppingList>> getAllLists() async {
    final lists = await _database.getAllShoppingLists();
    final result = <ShoppingList>[];
    for (final list in lists) {
      final items = await _database.getShoppingItemsByListId(list.id);
      final itemEntities = items
          .map((item) => ShoppingItemModel.fromDatabase(item))
          .toList();
      result.add(ShoppingListModel.fromDatabase(list, items: itemEntities));
    }
    return result;
  }

  @override
  Future<ShoppingList?> getActiveList() async {
    debugPrint('📋 [Repository] Getting active list...');
    final list = await _database.getActiveShoppingList();
    if (list == null) {
      debugPrint('📋 [Repository] No active list found');
      return null;
    }
    debugPrint('📋 [Repository] Found active list: ${list.id}');
    final items = await _database.getShoppingItemsByListId(list.id);
    debugPrint('📋 [Repository] Active list has ${items.length} items');
    final itemEntities = items
        .map((item) => ShoppingItemModel.fromDatabase(item))
        .toList();
    return ShoppingListModel.fromDatabase(list, items: itemEntities);
  }

  @override
  Future<ShoppingList?> getListById(String id) async {
    final list = await _database.getShoppingListById(id);
    if (list == null) return null;
    final items = await _database.getShoppingItemsByListId(list.id);
    final itemEntities = items
        .map((item) => ShoppingItemModel.fromDatabase(item))
        .toList();
    return ShoppingListModel.fromDatabase(list, items: itemEntities);
  }

  @override
  Future<List<ShoppingList>> getHistory() async {
    final lists = await _database.getShoppingHistory();
    final result = <ShoppingList>[];
    for (final list in lists) {
      final items = await _database.getShoppingItemsByListId(list.id);
      final itemEntities = items
          .map((item) => ShoppingItemModel.fromDatabase(item))
          .toList();
      result.add(ShoppingListModel.fromDatabase(list, items: itemEntities));
    }
    return result;
  }

  @override
  Future<void> createList(ShoppingList list) async {
    debugPrint('📋 [Repository] Creating list: ${list.id} - ${list.name}');
    final companion = ShoppingListsTableCompanion.insert(
      id: list.id,
      name: Value(list.name),
      marketId: Value(list.marketId),
      marketName: Value(list.marketName),
      status: Value(
        list.status == ShoppingListStatus.active ? 'active' : 'finalized',
      ),
      createdAt: Value(list.createdAt),
      updatedAt: Value(list.updatedAt),
      finalizedAt: Value(list.finalizedAt),
    );
    final result = await _database.insertShoppingList(companion);
    debugPrint('📋 [Repository] Create list result: $result');
  }

  @override
  Future<void> updateList(ShoppingList list) async {
    final companion = ShoppingListsTableCompanion(
      id: Value(list.id),
      name: Value(list.name),
      marketId: Value(list.marketId),
      marketName: Value(list.marketName),
      status: Value(
        list.status == ShoppingListStatus.active ? 'active' : 'finalized',
      ),
      createdAt: Value(list.createdAt),
      updatedAt: Value(DateTime.now()),
      finalizedAt: Value(list.finalizedAt),
    );
    await _database.updateShoppingList(companion);
  }

  @override
  Future<void> deleteList(String id) async {
    await _database.deleteShoppingItemsByListId(id);
    await _database.deleteShoppingList(id);
  }

  @override
  Future<void> finalizeList(String id, String? marketId) async {
    final list = await _database.getShoppingListById(id);
    if (list != null) {
      String? marketName;
      if (marketId != null) {
        final market = await _database.getMarketById(marketId);
        marketName = market?.name;
      }
      final companion = ShoppingListsTableCompanion(
        id: Value(list.id),
        name: Value(list.name),
        marketId: Value(marketId),
        marketName: Value(marketName),
        status: const Value('finalized'),
        createdAt: Value(list.createdAt),
        updatedAt: Value(DateTime.now()),
        finalizedAt: Value(DateTime.now()),
      );
      await _database.updateShoppingList(companion);
    }
  }

  @override
  Stream<ShoppingList?> watchActiveList() {
    return _database.watchActiveShoppingList().asyncMap((list) async {
      if (list == null) return null;
      final items = await _database.getShoppingItemsByListId(list.id);
      final itemEntities = items
          .map((item) => ShoppingItemModel.fromDatabase(item))
          .toList();
      return ShoppingListModel.fromDatabase(list, items: itemEntities);
    });
  }

  @override
  Stream<List<ShoppingList>> watchHistory() {
    return _database.watchShoppingHistory().asyncMap((lists) async {
      final result = <ShoppingList>[];
      for (final list in lists) {
        final items = await _database.getShoppingItemsByListId(list.id);
        final itemEntities = items
            .map((item) => ShoppingItemModel.fromDatabase(item))
            .toList();
        result.add(ShoppingListModel.fromDatabase(list, items: itemEntities));
      }
      return result;
    });
  }

  @override
  Future<void> clearHistory() async {
    // Apaga todas as listas finalizadas e seus itens
    final history = await _database.getShoppingHistory();
    for (final list in history) {
      await _database.deleteShoppingItemsByListId(list.id);
      await _database.deleteShoppingList(list.id);
    }
  }

  @override
  Future<void> saveToHistory(ShoppingList list) async {
    // Inserir a lista
    final listCompanion = ShoppingListsTableCompanion.insert(
      id: list.id,
      name: Value(list.name),
      marketId: Value(list.marketId),
      marketName: Value(list.marketName),
      status: const Value('finalized'),
      createdAt: Value(list.createdAt),
      updatedAt: Value(list.updatedAt),
      finalizedAt: Value(list.finalizedAt),
    );
    await _database.insertShoppingList(listCompanion);

    // Inserir os itens da lista
    for (final item in list.items) {
      final itemCompanion = ShoppingItemsTableCompanion.insert(
        id: item.id,
        shoppingListId: list.id,
        name: item.name,
        quantity: Value(item.quantity),
        price: Value(item.price),
        category: Value(item.category),
        isPurchased: Value(item.isPurchased),
        observations: Value(item.observations),
        createdAt: Value(item.createdAt),
        updatedAt: Value(item.updatedAt),
      );
      await _database.insertShoppingItem(itemCompanion);
    }
  }
}
