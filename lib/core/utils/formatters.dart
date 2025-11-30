import 'package:intl/intl.dart';

/// Formatters for currency, date, etc.
class Formatters {
  Formatters._();

  static final _currencyFormatter = NumberFormat.currency(
    locale: 'pt_PT',
    symbol: '€',
    decimalDigits: 2,
  );

  static final _dateFormatter = DateFormat('dd/MM/yyyy', 'pt_PT');
  static final _dateTimeFormatter = DateFormat('dd/MM/yyyy HH:mm', 'pt_PT');
  static final _timeFormatter = DateFormat('HH:mm', 'pt_PT');
  static final _monthYearFormatter = DateFormat('MMMM yyyy', 'pt_PT');

  /// Format value as currency (EUR)
  static String currency(double value) {
    return _currencyFormatter.format(value);
  }

  /// Format date as dd/MM/yyyy
  static String date(DateTime date) {
    return _dateFormatter.format(date);
  }

  /// Format datetime as dd/MM/yyyy HH:mm
  static String dateTime(DateTime date) {
    return _dateTimeFormatter.format(date);
  }

  /// Format time as HH:mm
  static String time(DateTime date) {
    return _timeFormatter.format(date);
  }

  /// Format as Month Year (e.g., Novembro 2025)
  static String monthYear(DateTime date) {
    return _monthYearFormatter.format(date);
  }

  /// Parse price string to double
  static double? parsePrice(String value) {
    final cleanValue = value.replaceAll(',', '.').replaceAll('€', '').trim();
    return double.tryParse(cleanValue);
  }

  /// Format quantity with unit
  static String quantity(int qty) {
    return qty == 1 ? '$qty unidade' : '$qty unidades';
  }

  /// Format percentage
  static String percentage(double value, {int decimals = 1}) {
    return '${value.toStringAsFixed(decimals)}%';
  }
}
