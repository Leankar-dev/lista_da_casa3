import '../entities/shopping_list.dart';

/// Shopping List Repository Interface
abstract class IShoppingListRepository {
  /// Get all shopping lists
  Future<List<ShoppingList>> getAllLists();

  /// Get active shopping list
  Future<ShoppingList?> getActiveList();

  /// Get shopping list by id
  Future<ShoppingList?> getListById(String id);

  /// Get finalized lists (history)
  Future<List<ShoppingList>> getHistory();

  /// Create a new shopping list
  Future<void> createList(ShoppingList list);

  /// Update an existing list
  Future<void> updateList(ShoppingList list);

  /// Delete a list
  Future<void> deleteList(String id);

  /// Finalize a shopping list
  Future<void> finalizeList(String id, String? marketId);

  /// Watch active list
  Stream<ShoppingList?> watchActiveList();

  /// Watch history
  Stream<List<ShoppingList>> watchHistory();
}
