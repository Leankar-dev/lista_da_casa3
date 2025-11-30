import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class LoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  final String? message;

  const LoadingIndicator({super.key, this.size = 50, this.color, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Neumorphic(
            style: NeumorphicStyle(
              depth: -4,
              intensity: AppConstants.neumorphicIntensity,
              boxShape: const NeumorphicBoxShape.circle(),
            ),
            padding: EdgeInsets.all(size / 4),
            child: SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  color ?? AppColors.primary,
                ),
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: AppConstants.defaultPadding),
            Text(
              message!,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: AppColors.background.withValues(alpha: 0.8),
            child: LoadingIndicator(message: message),
          ),
      ],
    );
  }
}

class NeumorphicProgressIndicator extends StatelessWidget {
  final double progress;
  final double height;
  final Color? progressColor;

  const NeumorphicProgressIndicator({
    super.key,
    required this.progress,
    this.height = 8,
    this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(height / 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkShadow.withValues(alpha: 0.3),
            offset: const Offset(2, 2),
            blurRadius: 4,
          ),
          const BoxShadow(
            color: AppColors.lightShadow,
            offset: Offset(-2, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height / 2),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final clampedProgress = progress.clamp(0.0, 1.0);
            final progressWidth = constraints.maxWidth * clampedProgress;

            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.background.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(height / 2),
                  ),
                ),
                AnimatedContainer(
                  duration: AppConstants.animationDuration,
                  width: progressWidth > 0 ? progressWidth : 0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        progressColor ?? AppColors.primary,
                        (progressColor ?? AppColors.primary).withValues(
                          alpha: 0.8,
                        ),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(height / 2),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
