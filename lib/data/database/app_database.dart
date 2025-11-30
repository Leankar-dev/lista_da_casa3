import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../core/constants/app_constants.dart';
import 'tables/tables.dart';

part 'app_database.g.dart';

/// Main application database using Drift
@DriftDatabase(tables: [ShoppingItemsTable, ShoppingListsTable, MarketsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => AppConstants.databaseVersion;

  // Shopping Items Operations
  Future<List<ShoppingItemsTableData>> getAllShoppingItems() =>
      select(shoppingItemsTable).get();

  Stream<List<ShoppingItemsTableData>> watchShoppingItemsByListId(
    String listId,
  ) {
    return (select(
      shoppingItemsTable,
    )..where((tbl) => tbl.shoppingListId.equals(listId))).watch();
  }

  Future<List<ShoppingItemsTableData>> getShoppingItemsByListId(String listId) {
    return (select(
      shoppingItemsTable,
    )..where((tbl) => tbl.shoppingListId.equals(listId))).get();
  }

  Future<ShoppingItemsTableData?> getShoppingItemById(String id) {
    return (select(
      shoppingItemsTable,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertShoppingItem(ShoppingItemsTableCompanion item) =>
      into(shoppingItemsTable).insert(item);

  Future<int> updateShoppingItem(ShoppingItemsTableCompanion item) => (update(
    shoppingItemsTable,
  )..where((tbl) => tbl.id.equals(item.id.value))).write(item);

  Future<int> deleteShoppingItem(String id) =>
      (delete(shoppingItemsTable)..where((tbl) => tbl.id.equals(id))).go();

  Future<int> deleteShoppingItemsByListId(String listId) => (delete(
    shoppingItemsTable,
  )..where((tbl) => tbl.shoppingListId.equals(listId))).go();

  // Shopping Lists Operations
  Future<List<ShoppingListsTableData>> getAllShoppingLists() =>
      select(shoppingListsTable).get();

  Stream<ShoppingListsTableData?> watchActiveShoppingList() {
    return (select(
      shoppingListsTable,
    )..where((tbl) => tbl.status.equals('active'))).watchSingleOrNull();
  }

  Future<ShoppingListsTableData?> getActiveShoppingList() {
    return (select(
      shoppingListsTable,
    )..where((tbl) => tbl.status.equals('active'))).getSingleOrNull();
  }

  Future<ShoppingListsTableData?> getShoppingListById(String id) {
    return (select(
      shoppingListsTable,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Stream<List<ShoppingListsTableData>> watchShoppingHistory() {
    return (select(shoppingListsTable)
          ..where((tbl) => tbl.status.equals('finalized'))
          ..orderBy([
            (tbl) => OrderingTerm(
              expression: tbl.finalizedAt,
              mode: OrderingMode.desc,
            ),
          ]))
        .watch();
  }

  Future<List<ShoppingListsTableData>> getShoppingHistory() {
    return (select(shoppingListsTable)
          ..where((tbl) => tbl.status.equals('finalized'))
          ..orderBy([
            (tbl) => OrderingTerm(
              expression: tbl.finalizedAt,
              mode: OrderingMode.desc,
            ),
          ]))
        .get();
  }

  Future<int> insertShoppingList(ShoppingListsTableCompanion list) =>
      into(shoppingListsTable).insert(list);

  Future<int> updateShoppingList(ShoppingListsTableCompanion list) => (update(
    shoppingListsTable,
  )..where((tbl) => tbl.id.equals(list.id.value))).write(list);

  Future<int> deleteShoppingList(String id) =>
      (delete(shoppingListsTable)..where((tbl) => tbl.id.equals(id))).go();

  // Markets Operations
  Future<List<MarketsTableData>> getAllMarkets() => select(marketsTable).get();

  Stream<List<MarketsTableData>> watchAllMarkets() =>
      select(marketsTable).watch();

  Future<MarketsTableData?> getMarketById(String id) {
    return (select(
      marketsTable,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertMarket(MarketsTableCompanion market) =>
      into(marketsTable).insert(market);

  Future<int> updateMarket(MarketsTableCompanion market) => (update(
    marketsTable,
  )..where((tbl) => tbl.id.equals(market.id.value))).write(market);

  Future<int> deleteMarket(String id) =>
      (delete(marketsTable)..where((tbl) => tbl.id.equals(id))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, AppConstants.databaseName));
    return NativeDatabase.createInBackground(file);
  });
}
