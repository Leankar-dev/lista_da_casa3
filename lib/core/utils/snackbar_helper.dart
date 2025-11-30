import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

/// Custom Snackbar Helper
class SnackbarHelper {
  SnackbarHelper._();

  static void showSuccess(BuildContext context, String message) {
    _showSnackbar(
      context,
      message: message,
      icon: Icons.check_circle_outline,
      backgroundColor: AppColors.success.withValues(alpha: 0.9),
    );
  }

  static void showError(BuildContext context, String message) {
    _showSnackbar(
      context,
      message: message,
      icon: Icons.error_outline,
      backgroundColor: AppColors.error.withValues(alpha: 0.9),
    );
  }

  static void showWarning(BuildContext context, String message) {
    _showSnackbar(
      context,
      message: message,
      icon: Icons.warning_amber_outlined,
      backgroundColor: AppColors.warning.withValues(alpha: 0.9),
    );
  }

  static void showInfo(BuildContext context, String message) {
    _showSnackbar(
      context,
      message: message,
      icon: Icons.info_outline,
      backgroundColor: AppColors.info.withValues(alpha: 0.9),
    );
  }

  static void _showSnackbar(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: AppConstants.smallPadding),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        margin: const EdgeInsets.all(AppConstants.defaultPadding),
        duration: duration,
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }

  /// Show snackbar with action button
  static void showWithAction(
    BuildContext context, {
    required String message,
    required String actionLabel,
    required VoidCallback onAction,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: backgroundColor ?? AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        margin: const EdgeInsets.all(AppConstants.defaultPadding),
        action: SnackBarAction(
          label: actionLabel,
          textColor: Colors.white,
          onPressed: onAction,
        ),
      ),
    );
  }
}
