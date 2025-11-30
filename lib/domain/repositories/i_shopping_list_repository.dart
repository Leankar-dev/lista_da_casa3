import '../entities/shopping_list.dart';

abstract class IShoppingListRepository {
  Future<List<ShoppingList>> getAllLists();

  Future<ShoppingList?> getActiveList();

  Future<ShoppingList?> getListById(String id);

  Future<List<ShoppingList>> getHistory();

  Future<void> createList(ShoppingList list);

  Future<void> updateList(ShoppingList list);

  Future<void> deleteList(String id);

  Future<void> finalizeList(String id, String? marketId);

  Stream<ShoppingList?> watchActiveList();

  Stream<List<ShoppingList>> watchHistory();
}
