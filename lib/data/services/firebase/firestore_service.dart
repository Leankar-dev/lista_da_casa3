import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../../core/constants/app_constants.dart';
import '../../models/shopping_list_model.dart';
import '../../models/market_model.dart';

class FirestoreService {
  FirebaseFirestore? _firestore;
  bool _isInitialized = false;

  void _ensureInitialized() {
    if (!_isInitialized) {
      try {
        if (Firebase.apps.isNotEmpty) {
          _firestore = FirebaseFirestore.instance;
          _isInitialized = true;
        }
      } catch (e) {
        _isInitialized = false;
      }
    }
  }

  bool get isFirestoreAvailable {
    _ensureInitialized();
    return _isInitialized && _firestore != null;
  }

  CollectionReference<Map<String, dynamic>>? _getHistoryRef(String userId) {
    _ensureInitialized();
    return _firestore
        ?.collection(AppConstants.usersCollection)
        .doc(userId)
        .collection(AppConstants.historyCollection);
  }

  CollectionReference<Map<String, dynamic>>? _getMarketsRef(String userId) {
    _ensureInitialized();
    return _firestore
        ?.collection(AppConstants.usersCollection)
        .doc(userId)
        .collection(AppConstants.marketsCollection);
  }

  Future<void> saveShoppingListToCloud(
    String userId,
    ShoppingListModel list,
  ) async {
    final ref = _getHistoryRef(userId);
    if (ref == null) return;
    await ref.doc(list.id).set(list.toJson());
  }

  Future<List<ShoppingListModel>> getHistoryFromCloud(String userId) async {
    final ref = _getHistoryRef(userId);
    if (ref == null) return [];

    final snapshot = await ref.get();
    final results = <ShoppingListModel>[];

    for (final doc in snapshot.docs) {
      try {
        results.add(ShoppingListModel.fromJson(doc.data()));
      } catch (_) {
        // Ignora documentos com formato inválido
      }
    }

    // Ordenar por finalizedAt
    results.sort((a, b) {
      if (a.finalizedAt == null && b.finalizedAt == null) return 0;
      if (a.finalizedAt == null) return 1;
      if (b.finalizedAt == null) return -1;
      return b.finalizedAt!.compareTo(a.finalizedAt!);
    });

    return results;
  }

  Future<void> deleteShoppingListFromCloud(String userId, String listId) async {
    final ref = _getHistoryRef(userId);
    if (ref == null) return;
    await ref.doc(listId).delete();
  }

  Future<void> syncHistoryToCloud(
    String userId,
    List<ShoppingListModel> lists,
  ) async {
    _ensureInitialized();
    if (_firestore == null) return;
    final batch = _firestore!.batch();
    final ref = _getHistoryRef(userId);
    if (ref == null) return;

    for (final list in lists) {
      batch.set(ref.doc(list.id), list.toJson());
    }

    await batch.commit();
  }

  Future<void> saveMarketToCloud(String userId, MarketModel market) async {
    final ref = _getMarketsRef(userId);
    if (ref == null) return;
    await ref.doc(market.id).set(market.toJson());
  }

  Future<List<MarketModel>> getMarketsFromCloud(String userId) async {
    final ref = _getMarketsRef(userId);
    if (ref == null) return [];

    final snapshot = await ref.get();
    final results = <MarketModel>[];

    for (final doc in snapshot.docs) {
      try {
        results.add(MarketModel.fromJson(doc.data()));
      } catch (_) {
        // Ignora documentos com formato inválido
      }
    }

    return results;
  }

  Future<void> deleteMarketFromCloud(String userId, String marketId) async {
    final ref = _getMarketsRef(userId);
    if (ref == null) return;
    await ref.doc(marketId).delete();
  }

  Future<void> syncMarketsToCloud(
    String userId,
    List<MarketModel> markets,
  ) async {
    _ensureInitialized();
    if (_firestore == null) return;
    final batch = _firestore!.batch();
    final ref = _getMarketsRef(userId);
    if (ref == null) return;

    for (final market in markets) {
      batch.set(ref.doc(market.id), market.toJson());
    }

    await batch.commit();
  }

  /// Limpa todos os dados do utilizador na nuvem
  Future<void> clearAllUserData(String userId) async {
    _ensureInitialized();
    if (_firestore == null) return;

    // Limpar histórico
    final historyRef = _getHistoryRef(userId);
    if (historyRef != null) {
      final historyDocs = await historyRef.get();
      for (final doc in historyDocs.docs) {
        await doc.reference.delete();
      }
    }

    // Limpar mercados
    final marketsRef = _getMarketsRef(userId);
    if (marketsRef != null) {
      final marketsDocs = await marketsRef.get();
      for (final doc in marketsDocs.docs) {
        await doc.reference.delete();
      }
    }
  }
}
