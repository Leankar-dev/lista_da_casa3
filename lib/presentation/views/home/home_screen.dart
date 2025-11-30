import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../widgets/common/neumorphic_bottom_nav.dart';
import '../shopping_list/shopping_list_screen.dart';
import '../history/history_screen.dart';
import '../markets/markets_screen.dart';
import '../charts/charts_screen.dart';

/// Home Screen with Bottom Navigation
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    ShoppingListScreen(),
    HistoryScreen(),
    MarketsScreen(),
    ChartsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
      theme: const NeumorphicThemeData(
        baseColor: AppColors.background,
        lightSource: LightSource.topLeft,
        depth: 8,
        intensity: 0.5,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: IndexedStack(index: _currentIndex, children: _screens),
        bottomNavigationBar: NeumorphicBottomNav(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            NeumorphicBottomNavItem(
              icon: Icons.shopping_cart_outlined,
              selectedIcon: Icons.shopping_cart,
              label: AppStrings.shoppingList,
            ),
            NeumorphicBottomNavItem(
              icon: Icons.history_outlined,
              selectedIcon: Icons.history,
              label: AppStrings.history,
            ),
            NeumorphicBottomNavItem(
              icon: Icons.store_outlined,
              selectedIcon: Icons.store,
              label: AppStrings.markets,
            ),
            NeumorphicBottomNavItem(
              icon: Icons.bar_chart_outlined,
              selectedIcon: Icons.bar_chart,
              label: AppStrings.charts,
            ),
          ],
        ),
      ),
    );
  }
}
