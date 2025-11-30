import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String? icon;
  final Color color;

  const Category({
    required this.id,
    required this.name,
    this.icon,
    required this.color,
  });

  @override
  List<Object?> get props => [id, name, icon, color];

  static List<Category> get defaultCategories => [
    const Category(
      id: 'fruits',
      name: AppStrings.fruits,
      icon: '🍎',
      color: AppColors.categoryFruits,
    ),
    const Category(
      id: 'vegetables',
      name: AppStrings.vegetables,
      icon: '🥬',
      color: AppColors.categoryVegetables,
    ),
    const Category(
      id: 'dairy',
      name: AppStrings.dairy,
      icon: '🥛',
      color: AppColors.categoryDairy,
    ),
    const Category(
      id: 'meat',
      name: AppStrings.meat,
      icon: '🥩',
      color: AppColors.categoryMeat,
    ),
    const Category(
      id: 'fish',
      name: AppStrings.fish,
      icon: '🐟',
      color: AppColors.categoryFish,
    ),
    const Category(
      id: 'bakery',
      name: AppStrings.bakery,
      icon: '🍞',
      color: AppColors.categoryBakery,
    ),
    const Category(
      id: 'beverages',
      name: AppStrings.beverages,
      icon: '🥤',
      color: AppColors.categoryBeverages,
    ),
    const Category(
      id: 'cleaning',
      name: AppStrings.cleaning,
      icon: '🧹',
      color: AppColors.categoryCleaning,
    ),
    const Category(
      id: 'hygiene',
      name: AppStrings.hygiene,
      icon: '🧴',
      color: AppColors.categoryHygiene,
    ),
    const Category(
      id: 'frozen',
      name: AppStrings.frozen,
      icon: '🧊',
      color: AppColors.categoryFrozen,
    ),
    const Category(
      id: 'snacks',
      name: AppStrings.snacks,
      icon: '🍿',
      color: AppColors.categorySnacks,
    ),
    const Category(
      id: 'grocery',
      name: AppStrings.grocery,
      icon: '🛒',
      color: AppColors.categoryGrocery,
    ),
    const Category(
      id: 'petFood',
      name: AppStrings.petFood,
      icon: '🐾',
      color: AppColors.categoryPetFood,
    ),
    const Category(
      id: 'other',
      name: AppStrings.other,
      icon: '📦',
      color: AppColors.categoryOther,
    ),
  ];

  static Category? findById(String id) {
    try {
      return defaultCategories.firstWhere((cat) => cat.id == id);
    } catch (_) {
      return null;
    }
  }

  static Category? findByName(String name) {
    try {
      return defaultCategories.firstWhere(
        (cat) => cat.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }
}
