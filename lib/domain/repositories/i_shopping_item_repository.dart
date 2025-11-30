import '../entities/shopping_item.dart';

abstract class IShoppingItemRepository {
  Future<List<ShoppingItem>> getItemsByListId(String listId);

  Future<ShoppingItem?> getItemById(String id);

  Future<void> addItem(ShoppingItem item);

  Future<void> updateItem(ShoppingItem item);

  Future<void> deleteItem(String id);

  Future<void> togglePurchased(String id, bool isPurchased);

  Future<void> deleteItemsByListId(String listId);

  Stream<List<ShoppingItem>> watchItemsByListId(String listId);
}
