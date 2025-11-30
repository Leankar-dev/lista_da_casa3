import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/di/injection.dart';
import '../../domain/entities/market.dart';

/// Market State
class MarketState {
  final List<Market> markets;
  final bool isLoading;
  final String? error;

  const MarketState({
    this.markets = const [],
    this.isLoading = false,
    this.error,
  });

  MarketState copyWith({
    List<Market>? markets,
    bool? isLoading,
    String? error,
  }) {
    return MarketState(
      markets: markets ?? this.markets,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Market ViewModel
class MarketViewModel extends StateNotifier<MarketState> {
  final Ref _ref;
  static const _uuid = Uuid();

  MarketViewModel(this._ref) : super(const MarketState()) {
    loadMarkets();
  }

  Future<void> loadMarkets() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repository = _ref.read(marketRepositoryProvider);
      final markets = await repository.getAllMarkets();
      state = state.copyWith(markets: markets, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addMarket({required String name, String? address}) async {
    try {
      final market = Market(
        id: _uuid.v4(),
        name: name,
        address: address,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final repository = _ref.read(marketRepositoryProvider);
      await repository.addMarket(market);
      await loadMarkets();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateMarket(Market market) async {
    try {
      final repository = _ref.read(marketRepositoryProvider);
      await repository.updateMarket(market.copyWith(updatedAt: DateTime.now()));
      await loadMarkets();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteMarket(String id) async {
    try {
      final repository = _ref.read(marketRepositoryProvider);
      await repository.deleteMarket(id);
      await loadMarkets();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Market Provider
final marketViewModelProvider =
    StateNotifierProvider<MarketViewModel, MarketState>((ref) {
      return MarketViewModel(ref);
    });
