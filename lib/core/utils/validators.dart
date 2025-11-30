import '../constants/app_strings.dart';

/// Form Validators
class Validators {
  Validators._();

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.errorRequired;
    }
    return null;
  }

  static String? itemName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.errorRequired;
    }
    if (value.length < 2) {
      return 'O nome deve ter pelo menos 2 caracteres';
    }
    if (value.length > 100) {
      return 'O nome deve ter no máximo 100 caracteres';
    }
    return null;
  }

  static String? price(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.errorRequired;
    }
    final cleanValue = value.replaceAll(',', '.').replaceAll('€', '').trim();
    final parsed = double.tryParse(cleanValue);
    if (parsed == null) {
      return AppStrings.errorInvalidPrice;
    }
    if (parsed < 0) {
      return 'O preço não pode ser negativo';
    }
    if (parsed > 999999.99) {
      return 'O preço é demasiado elevado';
    }
    return null;
  }

  static String? quantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.errorRequired;
    }
    final parsed = int.tryParse(value);
    if (parsed == null) {
      return AppStrings.errorInvalidQuantity;
    }
    if (parsed < 1) {
      return 'A quantidade deve ser pelo menos 1';
    }
    if (parsed > 9999) {
      return 'A quantidade é demasiado elevada';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.errorRequired;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return AppStrings.errorInvalidEmail;
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.errorRequired;
    }
    if (value.length < 6) {
      return AppStrings.errorWeakPassword;
    }
    return null;
  }

  static String? marketName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.errorRequired;
    }
    if (value.length < 2) {
      return 'O nome deve ter pelo menos 2 caracteres';
    }
    if (value.length > 50) {
      return 'O nome deve ter no máximo 50 caracteres';
    }
    return null;
  }

  static String? optional(String? value) {
    return null;
  }
}
