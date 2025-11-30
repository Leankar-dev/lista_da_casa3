import '../entities/market.dart';

/// Market Repository Interface
abstract class IMarketRepository {
  /// Get all markets
  Future<List<Market>> getAllMarkets();

  /// Get market by id
  Future<Market?> getMarketById(String id);

  /// Add a new market
  Future<void> addMarket(Market market);

  /// Update an existing market
  Future<void> updateMarket(Market market);

  /// Delete a market
  Future<void> deleteMarket(String id);

  /// Watch all markets
  Stream<List<Market>> watchMarkets();
}
