import 'package:drift/drift.dart';
import '../../domain/entities/market.dart';
import '../../domain/repositories/i_market_repository.dart';
import '../database/app_database.dart';
import '../models/market_model.dart';

class MarketRepositoryImpl implements IMarketRepository {
  final AppDatabase _database;

  MarketRepositoryImpl(this._database);

  @override
  Future<List<Market>> getAllMarkets() async {
    final markets = await _database.getAllMarkets();
    return markets.map((market) => MarketModel.fromDatabase(market)).toList();
  }

  @override
  Future<Market?> getMarketById(String id) async {
    final market = await _database.getMarketById(id);
    if (market == null) return null;
    return MarketModel.fromDatabase(market);
  }

  @override
  Future<void> addMarket(Market market) async {
    final companion = MarketsTableCompanion.insert(
      id: market.id,
      name: market.name,
      address: Value(market.address),
      createdAt: Value(market.createdAt),
      updatedAt: Value(market.updatedAt),
    );
    await _database.insertMarket(companion);
  }

  @override
  Future<void> updateMarket(Market market) async {
    final companion = MarketsTableCompanion(
      id: Value(market.id),
      name: Value(market.name),
      address: Value(market.address),
      createdAt: Value(market.createdAt),
      updatedAt: Value(DateTime.now()),
    );
    await _database.updateMarket(companion);
  }

  @override
  Future<void> deleteMarket(String id) async {
    await _database.deleteMarket(id);
  }

  @override
  Stream<List<Market>> watchMarkets() {
    return _database.watchAllMarkets().map(
      (markets) =>
          markets.map((market) => MarketModel.fromDatabase(market)).toList(),
    );
  }
}
