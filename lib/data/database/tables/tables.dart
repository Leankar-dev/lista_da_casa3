import 'package:drift/drift.dart';

class ShoppingItemsTable extends Table {
  @override
  String get tableName => 'shopping_items';

  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  RealColumn get price => real().withDefault(const Constant(0.0))();
  TextColumn get category => text().nullable()();
  TextColumn get observations => text().nullable()();
  BoolColumn get isPurchased => boolean().withDefault(const Constant(false))();
  TextColumn get shoppingListId => text().references(ShoppingListsTable, #id)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class ShoppingListsTable extends Table {
  @override
  String get tableName => 'shopping_lists';

  TextColumn get id => text()();
  TextColumn get name => text().nullable()();
  TextColumn get marketId => text().nullable()();
  TextColumn get marketName => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get finalizedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class MarketsTable extends Table {
  @override
  String get tableName => 'markets';

  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get address => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
