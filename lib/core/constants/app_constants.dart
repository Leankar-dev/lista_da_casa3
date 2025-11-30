library;

abstract class AppConstants {
  static const String appName = 'ListaDaCasa';
  static const String appVersion = '1.0.0';
  static const String developerName = 'Leankar.dev';
  static const String developerEmail = 'leankar.dev@gmail.com';
  static const String developerWebsite = 'https://leankar.dev';

  static const String databaseName = 'lista_da_casa.db';
  static const int databaseVersion = 1;

  static const String usersCollection = 'users';
  static const String shoppingListsCollection = 'shopping_lists';
  static const String historyCollection = 'history';
  static const String marketsCollection = 'markets';

  static const Duration splashDuration = Duration(milliseconds: 2500);
  static const Duration fadeInDuration = Duration(milliseconds: 500);
  static const Duration animationDuration = Duration(milliseconds: 300);

  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double neumorphicDepth = 8.0;
  static const double neumorphicIntensity = 0.5;
}
