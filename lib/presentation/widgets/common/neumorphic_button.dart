import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/neumorphic_theme.dart';

/// Custom Neumorphic Button
class NeumorphicButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;
  final double? width;
  final double? height;
  final bool isLoading;
  final bool isDisabled;

  const NeumorphicButtonWidget({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.color,
    this.width,
    this.height,
    this.isLoading = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? 50,
      child: NeumorphicButton(
        onPressed: isDisabled || isLoading ? null : onPressed,
        style: NeumorphicThemeConfig.buttonStyle.copyWith(
          color: color ?? NeumorphicTheme.baseColor(context),
          disableDepth: isDisabled,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
          vertical: AppConstants.smallPadding,
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        color: isDisabled
                            ? AppColors.textSecondary
                            : AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: AppConstants.smallPadding),
                    ],
                    Text(
                      text,
                      style: TextStyle(
                        color: isDisabled
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Primary Neumorphic Button (filled)
class NeumorphicPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double? width;
  final bool isLoading;

  const NeumorphicPrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.width,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 50,
      child: NeumorphicButton(
        onPressed: isLoading ? null : onPressed,
        style: NeumorphicStyle(
          depth: AppConstants.neumorphicDepth,
          intensity: AppConstants.neumorphicIntensity,
          color: AppColors.primary,
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(AppConstants.borderRadius),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.textLight,
                    ),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: AppColors.textLight, size: 20),
                      const SizedBox(width: AppConstants.smallPadding),
                    ],
                    Text(
                      text,
                      style: const TextStyle(
                        color: AppColors.textLight,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Neumorphic Icon Button
class NeumorphicIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? iconColor;
  final double size;

  const NeumorphicIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.iconColor,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      onPressed: onPressed,
      style: NeumorphicThemeConfig.circleStyle,
      padding: EdgeInsets.all(size / 4),
      child: Icon(icon, color: iconColor ?? AppColors.primary, size: size / 2),
    );
  }
}
