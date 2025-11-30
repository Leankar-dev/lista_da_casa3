import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../core/constants/app_strings.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/neumorphic_theme.dart';
import '../presentation/views/splash/splash_screen.dart';

/// ListaDaCasa App Widget
class ListaDaCasaApp extends StatelessWidget {
  const ListaDaCasaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: NeumorphicThemeConfig.lightTheme,
      darkTheme: NeumorphicThemeConfig.darkTheme,
      materialTheme: AppTheme.lightTheme,
      materialDarkTheme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
