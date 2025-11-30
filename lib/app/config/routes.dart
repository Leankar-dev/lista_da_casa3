import 'package:flutter/material.dart';
import '../../presentation/views/splash/splash_screen.dart';
import '../../presentation/views/home/home_screen.dart';
import '../../presentation/views/shopping_list/shopping_list_screen.dart';
import '../../presentation/views/shopping_list/add_item_screen.dart';
import '../../presentation/views/history/history_screen.dart';
import '../../presentation/views/markets/markets_screen.dart';
import '../../presentation/views/markets/add_edit_market_screen.dart';
import '../../presentation/views/charts/charts_screen.dart';

/// App Routes
class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String shoppingList = '/shopping-list';
  static const String addItem = '/add-item';
  static const String editItem = '/edit-item';
  static const String history = '/history';
  static const String historyDetail = '/history-detail';
  static const String markets = '/markets';
  static const String addMarket = '/add-market';
  static const String editMarket = '/edit-market';
  static const String charts = '/charts';
  static const String login = '/login';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    home: (context) => const HomeScreen(),
    shoppingList: (context) => const ShoppingListScreen(),
    addItem: (context) => const AddItemScreen(),
    history: (context) => const HistoryScreen(),
    markets: (context) => const MarketsScreen(),
    addMarket: (context) => const AddEditMarketScreen(),
    charts: (context) => const ChartsScreen(),
  };
}
