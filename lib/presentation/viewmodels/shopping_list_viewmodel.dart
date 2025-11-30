import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/di/injection.dart';
import '../../domain/entities/shopping_item.dart';
import '../../domain/entities/shopping_list.dart';

/// Shopping List State
class ShoppingListState {
  final ShoppingList? activeList;
  final List<ShoppingItem> items;
  final bool isLoading;
  final String? error;

  const ShoppingListState({
    this.activeList,
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  double get totalValue =>
      items.fold(0, (sum, item) => sum + (item.quantity * item.price));

  double get purchasedValue => items
      .where((item) => item.isPurchased)
      .fold(0, (sum, item) => sum + (item.quantity * item.price));

  int get totalItems => items.length;
  int get purchasedItems => items.where((item) => item.isPurchased).length;
  int get pendingItems => items.where((item) => !item.isPurchased).length;

  ShoppingListState copyWith({
    ShoppingList? activeList,
    List<ShoppingItem>? items,
    bool? isLoading,
    String? error,
  }) {
    return ShoppingListState(
      activeList: activeList ?? this.activeList,
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Shopping List ViewModel
class ShoppingListViewModel extends StateNotifier<ShoppingListState> {
  final Ref _ref;
  static const _uuid = Uuid();

  ShoppingListViewModel(this._ref) : super(const ShoppingListState()) {
    _init();
  }

  Future<void> _init() async {
    await loadActiveList();
  }

  Future<void> loadActiveList() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repository = _ref.read(shoppingListRepositoryProvider);
      var activeList = await repository.getActiveList();

      if (activeList == null) {
        // Create a new active list if none exists
        final newList = ShoppingList(
          id: _uuid.v4(),
          name: 'Lista de Compras',
          status: ShoppingListStatus.active,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await repository.createList(newList);
        activeList = newList;
      }

      final itemRepository = _ref.read(shoppingItemRepositoryProvider);
      final items = await itemRepository.getItemsByListId(activeList.id);

      state = state.copyWith(
        activeList: activeList.copyWith(items: items),
        items: items,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addItem({
    required String name,
    required int quantity,
    required double price,
    String? category,
    String? observations,
  }) async {
    if (state.activeList == null) return;

    try {
      final item = ShoppingItem(
        id: _uuid.v4(),
        name: name,
        quantity: quantity,
        price: price,
        category: category,
        observations: observations,
        isPurchased: false,
        shoppingListId: state.activeList!.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final repository = _ref.read(shoppingItemRepositoryProvider);
      await repository.addItem(item);
      await loadActiveList();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateItem(ShoppingItem item) async {
    try {
      final repository = _ref.read(shoppingItemRepositoryProvider);
      await repository.updateItem(item.copyWith(updatedAt: DateTime.now()));
      await loadActiveList();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteItem(String id) async {
    try {
      final repository = _ref.read(shoppingItemRepositoryProvider);
      await repository.deleteItem(id);
      await loadActiveList();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> toggleItemPurchased(String id) async {
    try {
      final item = state.items.firstWhere((item) => item.id == id);
      final repository = _ref.read(shoppingItemRepositoryProvider);
      await repository.togglePurchased(id, !item.isPurchased);
      await loadActiveList();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> finalizePurchase(String? marketId) async {
    if (state.activeList == null) return;

    try {
      final repository = _ref.read(shoppingListRepositoryProvider);
      await repository.finalizeList(state.activeList!.id, marketId);

      // Create a new active list
      final newList = ShoppingList(
        id: _uuid.v4(),
        name: 'Lista de Compras',
        status: ShoppingListStatus.active,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await repository.createList(newList);

      state = state.copyWith(activeList: newList, items: []);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Shopping List Provider
final shoppingListViewModelProvider =
    StateNotifierProvider<ShoppingListViewModel, ShoppingListState>((ref) {
      return ShoppingListViewModel(ref);
    });
