import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

class NeumorphicThemeConfig {
  static NeumorphicThemeData get lightTheme {
    return const NeumorphicThemeData(
      baseColor: AppColors.background,
      lightSource: LightSource.topLeft,
      depth: AppConstants.neumorphicDepth,
      intensity: AppConstants.neumorphicIntensity,
      shadowLightColor: AppColors.lightShadow,
      shadowDarkColor: AppColors.darkShadow,
      accentColor: AppColors.primary,
    );
  }

  static NeumorphicThemeData get darkTheme {
    return const NeumorphicThemeData(
      baseColor: AppColors.backgroundDark,
      lightSource: LightSource.topLeft,
      depth: AppConstants.neumorphicDepth,
      intensity: AppConstants.neumorphicIntensity,
      shadowLightColor: AppColors.lightShadowDark,
      shadowDarkColor: AppColors.darkShadowDark,
      accentColor: AppColors.primary,
    );
  }

  static NeumorphicStyle get cardStyle {
    return NeumorphicStyle(
      depth: AppConstants.neumorphicDepth,
      intensity: AppConstants.neumorphicIntensity,
      boxShape: NeumorphicBoxShape.roundRect(
        BorderRadius.circular(AppConstants.borderRadius),
      ),
    );
  }

  static NeumorphicStyle get buttonStyle {
    return NeumorphicStyle(
      depth: AppConstants.neumorphicDepth,
      intensity: AppConstants.neumorphicIntensity,
      boxShape: NeumorphicBoxShape.roundRect(
        BorderRadius.circular(AppConstants.borderRadius),
      ),
    );
  }

  static NeumorphicStyle get pressedButtonStyle {
    return NeumorphicStyle(
      depth: -AppConstants.neumorphicDepth / 2,
      intensity: AppConstants.neumorphicIntensity,
      boxShape: NeumorphicBoxShape.roundRect(
        BorderRadius.circular(AppConstants.borderRadius),
      ),
    );
  }

  static NeumorphicStyle get textFieldStyle {
    return NeumorphicStyle(
      depth: -4,
      intensity: AppConstants.neumorphicIntensity,
      boxShape: NeumorphicBoxShape.roundRect(
        BorderRadius.circular(AppConstants.borderRadius),
      ),
    );
  }

  static NeumorphicStyle get circleStyle {
    return NeumorphicStyle(
      depth: AppConstants.neumorphicDepth,
      intensity: AppConstants.neumorphicIntensity,
      boxShape: const NeumorphicBoxShape.circle(),
    );
  }

  static NeumorphicStyle get checkboxStyle {
    return NeumorphicStyle(
      depth: 4,
      intensity: AppConstants.neumorphicIntensity,
      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
    );
  }
}
