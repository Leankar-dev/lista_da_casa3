import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injection.dart';
import '../../domain/entities/shopping_list.dart';
import '../../domain/entities/category.dart';

/// History State
class HistoryState {
  final List<ShoppingList> history;
  final bool isLoading;
  final String? error;
  final ShoppingList? selectedList;

  const HistoryState({
    this.history = const [],
    this.isLoading = false,
    this.error,
    this.selectedList,
  });

  double get totalSpent =>
      history.fold(0, (sum, list) => sum + list.totalValue);

  HistoryState copyWith({
    List<ShoppingList>? history,
    bool? isLoading,
    String? error,
    ShoppingList? selectedList,
  }) {
    return HistoryState(
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedList: selectedList ?? this.selectedList,
    );
  }
}

/// History ViewModel
class HistoryViewModel extends StateNotifier<HistoryState> {
  final Ref _ref;

  HistoryViewModel(this._ref) : super(const HistoryState()) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repository = _ref.read(shoppingListRepositoryProvider);
      final history = await repository.getHistory();
      state = state.copyWith(history: history, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteFromHistory(String id) async {
    try {
      final repository = _ref.read(shoppingListRepositoryProvider);
      await repository.deleteList(id);
      await loadHistory();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void selectList(ShoppingList? list) {
    state = state.copyWith(selectedList: list);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Get spending data for charts
  Map<String, double> getSpendingByMonth() {
    final Map<String, double> result = {};
    for (final list in state.history) {
      if (list.finalizedAt != null) {
        final key = '${list.finalizedAt!.month}/${list.finalizedAt!.year}';
        result[key] = (result[key] ?? 0) + list.totalValue;
      }
    }
    return result;
  }

  /// Get spending by category
  Map<String, double> getSpendingByCategory() {
    final Map<String, double> result = {};
    for (final list in state.history) {
      for (final item in list.items) {
        // Get the category name in Portuguese, or use 'Outros' as default
        final categoryId = item.category;
        final category = categoryId != null
            ? Category.findById(categoryId)
            : null;
        final categoryName = category?.name ?? 'Outros';
        result[categoryName] = (result[categoryName] ?? 0) + item.totalPrice;
      }
    }
    return result;
  }
}

/// History Provider
final historyViewModelProvider =
    StateNotifierProvider<HistoryViewModel, HistoryState>((ref) {
      return HistoryViewModel(ref);
    });
