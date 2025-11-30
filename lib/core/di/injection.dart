import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../data/repositories/shopping_item_repository_impl.dart';
import '../../data/repositories/shopping_list_repository_impl.dart';
import '../../data/repositories/market_repository_impl.dart';
import '../../data/services/firebase/firebase_auth_service.dart';
import '../../data/services/firebase/firestore_service.dart';
import '../../data/services/firebase/sync_service.dart';
import '../../domain/repositories/i_shopping_item_repository.dart';
import '../../domain/repositories/i_shopping_list_repository.dart';
import '../../domain/repositories/i_market_repository.dart';

/// Database Provider (lazy singleton)
final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(() => database.close());
  return database;
});

/// Shopping Item Repository Provider
final shoppingItemRepositoryProvider = Provider<IShoppingItemRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return ShoppingItemRepositoryImpl(database);
});

/// Shopping List Repository Provider
final shoppingListRepositoryProvider = Provider<IShoppingListRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return ShoppingListRepositoryImpl(database);
});

/// Market Repository Provider
final marketRepositoryProvider = Provider<IMarketRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return MarketRepositoryImpl(database);
});

/// Firebase Auth Service Provider
final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService();
});

/// Firestore Service Provider
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

/// Sync Service Provider
final syncServiceProvider = Provider<SyncService>((ref) {
  final authService = ref.watch(firebaseAuthServiceProvider);
  final firestoreService = ref.watch(firestoreServiceProvider);
  final shoppingListRepository = ref.watch(shoppingListRepositoryProvider);
  final marketRepository = ref.watch(marketRepositoryProvider);

  return SyncService(
    authService: authService,
    firestoreService: firestoreService,
    shoppingListRepository: shoppingListRepository,
    marketRepository: marketRepository,
  );
});
