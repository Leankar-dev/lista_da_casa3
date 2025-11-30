import 'package:flutter/material.dart';

/// App color palette for Neumorphic theme
abstract class AppColors {
  // Primary Neumorphic Colors
  static const Color background = Color(0xFFE0E5EC);
  static const Color backgroundDark = Color(0xFF2D2D3A);

  // Light Theme
  static const Color lightShadow = Color(0xFFFFFFFF);
  static const Color darkShadow = Color(0xFFA3B1C6);
  static const Color surfaceLight = Color(0xFFE0E5EC);

  // Dark Theme
  static const Color lightShadowDark = Color(0xFF3D3D4A);
  static const Color darkShadowDark = Color(0xFF1D1D2A);
  static const Color surfaceDark = Color(0xFF2D2D3A);

  // Accent Colors
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF8B83FF);
  static const Color primaryDark = Color(0xFF4B44CC);

  static const Color secondary = Color(0xFF00BFA5);
  static const Color secondaryLight = Color(0xFF5DF2D6);
  static const Color secondaryDark = Color(0xFF008E76);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Text Colors
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1A1A1A);

  // Category Colors
  static const Color categoryFruits = Color(0xFFFF6B6B);
  static const Color categoryVegetables = Color(0xFF4ECDC4);
  static const Color categoryDairy = Color(0xFFFFE66D);
  static const Color categoryMeat = Color(0xFFD63031);
  static const Color categoryFish = Color(0xFF74B9FF);
  static const Color categoryBakery = Color(0xFFFDAA5D);
  static const Color categoryBeverages = Color(0xFF6C5CE7);
  static const Color categoryCleaning = Color(0xFF00CEC9);
  static const Color categoryHygiene = Color(0xFFFF85A2);
  static const Color categoryFrozen = Color(0xFF81ECEC);
  static const Color categorySnacks = Color(0xFFFFC048);
  static const Color categoryOther = Color(0xFFB2BEC3);

  // Chart Colors
  static const List<Color> chartColors = [
    categoryFruits,
    categoryVegetables,
    categoryDairy,
    categoryMeat,
    categoryFish,
    categoryBakery,
    categoryBeverages,
    categoryCleaning,
    categoryHygiene,
    categoryFrozen,
    categorySnacks,
    categoryOther,
  ];

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
