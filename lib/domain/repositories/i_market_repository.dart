import '../entities/market.dart';

abstract class IMarketRepository {
  Future<List<Market>> getAllMarkets();

  Future<Market?> getMarketById(String id);

  Future<void> addMarket(Market market);

  Future<void> updateMarket(Market market);

  Future<void> deleteMarket(String id);

  Stream<List<Market>> watchMarkets();
}
