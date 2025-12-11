import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../data/repositories/shopping_item_repository_impl.dart';
import '../../data/repositories/shopping_list_repository_impl.dart';
import '../../data/repositories/market_repository_impl.dart';
import '../../data/services/firebase/firebase_auth_service.dart';
import '../../data/services/firebase/firestore_service.dart';
import '../../data/services/firebase/sync_service.dart';
import '../../data/services/secure_storage_service.dart';
import '../../domain/repositories/i_shopping_item_repository.dart';
import '../../domain/repositories/i_shopping_list_repository.dart';
import '../../domain/repositories/i_market_repository.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(() => database.close());
  return database;
});

final shoppingItemRepositoryProvider = Provider<IShoppingItemRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return ShoppingItemRepositoryImpl(database);
});
final shoppingListRepositoryProvider = Provider<IShoppingListRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return ShoppingListRepositoryImpl(database);
});

final marketRepositoryProvider = Provider<IMarketRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return MarketRepositoryImpl(database);
});
final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService();
});

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

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
