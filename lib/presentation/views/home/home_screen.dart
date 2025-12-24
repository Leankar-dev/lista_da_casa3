import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/common/neumorphic_bottom_nav.dart';
import '../shopping_list/shopping_list_screen.dart';
import '../history/history_screen.dart';
import '../markets/markets_screen.dart';
import '../charts/charts_screen.dart';
import '../auth/login_screen.dart';

/// Provider para controlar o drawer da HomeScreen
final homeScaffoldKeyProvider = Provider<GlobalKey<ScaffoldState>>((ref) {
  return GlobalKey<ScaffoldState>();
});

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
    final scaffoldKey = ref.watch(homeScaffoldKeyProvider);
    final authState = ref.watch(authViewModelProvider);

    return NeumorphicTheme(
      theme: const NeumorphicThemeData(
        baseColor: AppColors.background,
        lightSource: LightSource.topLeft,
        depth: 8,
        intensity: 0.5,
      ),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: AppColors.background,
        drawer: _HomeDrawer(authState: authState),
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

class _HomeDrawer extends ConsumerWidget {
  final AuthState authState;

  const _HomeDrawer({required this.authState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            // Cabeçalho do Drawer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.largePadding),
              child: Column(
                children: [
                  // Avatar neumórfico
                  Neumorphic(
                    style: const NeumorphicStyle(
                      depth: 4,
                      boxShape: NeumorphicBoxShape.circle(),
                      color: AppColors.background,
                    ),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 40,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  // Email do utilizador
                  if (authState.isAuthenticated && authState.user != null) ...[
                    Text(
                      authState.user!.email ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ] else ...[
                    const Text(
                      'Não autenticado',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const Divider(color: AppColors.darkShadow, height: 1),

            const Spacer(),

            // Botão de Logout
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: NeumorphicButton(
                onPressed: () => _handleLogout(context, ref),
                style: NeumorphicStyle(
                  depth: 4,
                  color: AppColors.background,
                  boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular(AppConstants.borderRadius),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding,
                  vertical: AppConstants.smallPadding + 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout,
                      color: AppColors.error,
                      size: 20,
                    ),
                    const SizedBox(width: AppConstants.smallPadding),
                    Text(
                      AppStrings.logout,
                      style: TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Versão da app
            Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
              child: Text(
                AppStrings.byDeveloper,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    // Mostrar diálogo de confirmação primeiro (antes de fechar o drawer)
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.background,
        title: const Text(AppStrings.logout),
        content: const Text('Tem a certeza que deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              AppStrings.logout,
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
      // Fechar o drawer
      Navigator.of(context).pop();

      await ref.read(authViewModelProvider.notifier).signOut();

      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }
}
