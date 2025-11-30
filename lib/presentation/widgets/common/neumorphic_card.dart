import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/neumorphic_theme.dart';

class NeumorphicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final Color? color;
  final VoidCallback? onTap;

  const NeumorphicCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding != null
        ? EdgeInsets.only(
            left: (padding as EdgeInsets?)?.left ?? AppConstants.defaultPadding,
            top: (padding as EdgeInsets?)?.top ?? AppConstants.defaultPadding,
            right:
                (padding as EdgeInsets?)?.right ?? AppConstants.defaultPadding,
            bottom:
                (padding as EdgeInsets?)?.bottom ?? AppConstants.defaultPadding,
          )
        : const EdgeInsets.all(AppConstants.defaultPadding);

    final card = Neumorphic(
      style: NeumorphicThemeConfig.cardStyle.copyWith(
        color: color ?? AppColors.cardBackground,
      ),
      padding: effectivePadding,
      child: child,
    );

    return Container(
      width: width,
      height: height,
      margin: margin,
      child: onTap != null ? GestureDetector(onTap: onTap, child: card) : card,
    );
  }
}

class NeumorphicFlatCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;

  const NeumorphicFlatCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding != null
        ? EdgeInsets.only(
            left: (padding as EdgeInsets?)?.left ?? AppConstants.defaultPadding,
            top: (padding as EdgeInsets?)?.top ?? AppConstants.defaultPadding,
            right:
                (padding as EdgeInsets?)?.right ?? AppConstants.defaultPadding,
            bottom:
                (padding as EdgeInsets?)?.bottom ?? AppConstants.defaultPadding,
          )
        : const EdgeInsets.all(AppConstants.defaultPadding);

    return Container(
      margin: margin,
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: -4,
          intensity: AppConstants.neumorphicIntensity,
          color: color ?? AppColors.background,
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(AppConstants.borderRadius),
          ),
        ),
        padding: effectivePadding,
        child: child,
      ),
    );
  }
}

class NeumorphicContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double depth;
  final BorderRadius? borderRadius;

  const NeumorphicContainer({
    super.key,
    required this.child,
    this.padding,
    this.depth = 4,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding != null
        ? EdgeInsets.only(
            left: (padding as EdgeInsets?)?.left ?? AppConstants.defaultPadding,
            top: (padding as EdgeInsets?)?.top ?? AppConstants.defaultPadding,
            right:
                (padding as EdgeInsets?)?.right ?? AppConstants.defaultPadding,
            bottom:
                (padding as EdgeInsets?)?.bottom ?? AppConstants.defaultPadding,
          )
        : const EdgeInsets.all(AppConstants.defaultPadding);

    return Neumorphic(
      style: NeumorphicStyle(
        depth: depth,
        intensity: AppConstants.neumorphicIntensity,
        boxShape: NeumorphicBoxShape.roundRect(
          borderRadius ?? BorderRadius.circular(AppConstants.borderRadius),
        ),
      ),
      padding: effectivePadding,
      child: child,
    );
  }
}
