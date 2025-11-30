import 'package:intl/intl.dart';

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

  static String currency(double value) {
    return _currencyFormatter.format(value);
  }

  static String date(DateTime date) {
    return _dateFormatter.format(date);
  }

  static String dateTime(DateTime date) {
    return _dateTimeFormatter.format(date);
  }

  static String time(DateTime date) {
    return _timeFormatter.format(date);
  }

  static String monthYear(DateTime date) {
    return _monthYearFormatter.format(date);
  }

  static double? parsePrice(String value) {
    final cleanValue = value.replaceAll(',', '.').replaceAll('€', '').trim();
    return double.tryParse(cleanValue);
  }

  static String quantity(int qty) {
    return qty == 1 ? '$qty unidade' : '$qty unidades';
  }

  static String percentage(double value, {int decimals = 1}) {
    return '${value.toStringAsFixed(decimals)}%';
  }
}
