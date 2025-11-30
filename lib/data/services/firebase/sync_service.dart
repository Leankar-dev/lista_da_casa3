import '../../../domain/entities/shopping_list.dart';
import '../../../domain/entities/market.dart';
import '../../../domain/repositories/i_shopping_list_repository.dart';
import '../../../domain/repositories/i_market_repository.dart';
import '../../models/shopping_list_model.dart';
import '../../models/market_model.dart';
import 'firebase_auth_service.dart';
import 'firestore_service.dart';

class SyncService {
  final FirebaseAuthService _authService;
  final FirestoreService _firestoreService;
  final IShoppingListRepository _shoppingListRepository;
  final IMarketRepository _marketRepository;

  SyncService({
    required FirebaseAuthService authService,
    required FirestoreService firestoreService,
    required IShoppingListRepository shoppingListRepository,
    required IMarketRepository marketRepository,
  }) : _authService = authService,
       _firestoreService = firestoreService,
       _shoppingListRepository = shoppingListRepository,
       _marketRepository = marketRepository;

  bool get isFirebaseAvailable => _authService.isFirebaseAvailable;

  bool get isAuthenticated => _authService.isAuthenticated;

  String? get userId => _authService.currentUser?.uid;

  Future<void> syncHistoryToCloud() async {
    if (!isFirebaseAvailable) return;
    if (!isAuthenticated || userId == null) {
      throw Exception('Utilizador não autenticado');
    }

    final history = await _shoppingListRepository.getHistory();
    final historyModels = history
        .map((list) => ShoppingListModel.fromEntity(list))
        .toList();

    await _firestoreService.syncHistoryToCloud(userId!, historyModels);
  }

  Future<void> syncMarketsToCloud() async {
    if (!isFirebaseAvailable) return;
    if (!isAuthenticated || userId == null) {
      throw Exception('Utilizador não autenticado');
    }

    final markets = await _marketRepository.getAllMarkets();
    final marketModels = markets
        .map((market) => MarketModel.fromEntity(market))
        .toList();

    await _firestoreService.syncMarketsToCloud(userId!, marketModels);
  }

  Future<void> syncAllToCloud() async {
    if (!isFirebaseAvailable) return;
    await syncHistoryToCloud();
    await syncMarketsToCloud();
  }

  Future<List<ShoppingList>> downloadHistoryFromCloud() async {
    if (!isFirebaseAvailable) return [];
    if (!isAuthenticated || userId == null) {
      throw Exception('Utilizador não autenticado');
    }

    final historyModels = await _firestoreService.getHistoryFromCloud(userId!);
    return historyModels.map((model) => model.toEntity()).toList();
  }

  Future<List<Market>> downloadMarketsFromCloud() async {
    if (!isFirebaseAvailable) return [];
    if (!isAuthenticated || userId == null) {
      throw Exception('Utilizador não autenticado');
    }

    final marketModels = await _firestoreService.getMarketsFromCloud(userId!);
    return marketModels.map((model) => model.toEntity()).toList();
  }
}
