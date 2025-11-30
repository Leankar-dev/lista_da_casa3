import '../entities/shopping_item.dart';

/// Shopping Item Repository Interface
abstract class IShoppingItemRepository {
  /// Get all items for a shopping list
  Future<List<ShoppingItem>> getItemsByListId(String listId);

  /// Get item by id
  Future<ShoppingItem?> getItemById(String id);

  /// Add a new item
  Future<void> addItem(ShoppingItem item);

  /// Update an existing item
  Future<void> updateItem(ShoppingItem item);

  /// Delete an item
  Future<void> deleteItem(String id);

  /// Toggle item purchased status
  Future<void> togglePurchased(String id, bool isPurchased);

  /// Delete all items for a list
  Future<void> deleteItemsByListId(String listId);

  /// Watch items for a shopping list
  Stream<List<ShoppingItem>> watchItemsByListId(String listId);
}
