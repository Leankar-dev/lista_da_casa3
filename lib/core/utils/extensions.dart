import 'package:intl/intl.dart';

extension StringExtensions on String {
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }
}

extension DoubleExtensions on double {
  String toCurrency({String symbol = '€', int decimalPlaces = 2}) {
    final formatter = NumberFormat.currency(
      locale: 'pt_PT',
      symbol: symbol,
      decimalDigits: decimalPlaces,
    );
    return formatter.format(this);
  }

  String toPercentage({int decimalPlaces = 1}) {
    return '${toStringAsFixed(decimalPlaces)}%';
  }
}

extension IntExtensions on int {
  String toQuantityString() {
    return this == 1 ? '$this unidade' : '$this unidades';
  }
}

extension DateTimeExtensions on DateTime {
  String toFormattedDate({String pattern = 'dd/MM/yyyy'}) {
    return DateFormat(pattern, 'pt_PT').format(this);
  }

  String toFormattedDateTime({String pattern = 'dd/MM/yyyy HH:mm'}) {
    return DateFormat(pattern, 'pt_PT').format(this);
  }

  String toRelativeDate() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays == 0) {
      return 'Hoje';
    } else if (difference.inDays == 1) {
      return 'Ontem';
    } else if (difference.inDays < 7) {
      return 'Há ${difference.inDays} dias';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return weeks == 1 ? 'Há 1 semana' : 'Há $weeks semanas';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? 'Há 1 mês' : 'Há $months meses';
    } else {
      final years = (difference.inDays / 365).floor();
      return years == 1 ? 'Há 1 ano' : 'Há $years anos';
    }
  }

  String get monthName {
    const months = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];
    return months[month - 1];
  }

  String get shortMonthName {
    const months = [
      'Jan',
      'Fev',
      'Mar',
      'Abr',
      'Mai',
      'Jun',
      'Jul',
      'Ago',
      'Set',
      'Out',
      'Nov',
      'Dez',
    ];
    return months[month - 1];
  }
}

extension ListExtensions<T> on List<T> {
  List<T> sortedBy<K extends Comparable>(K Function(T) keyOf) {
    return [...this]..sort((a, b) => keyOf(a).compareTo(keyOf(b)));
  }

  List<T> sortedByDescending<K extends Comparable>(K Function(T) keyOf) {
    return [...this]..sort((a, b) => keyOf(b).compareTo(keyOf(a)));
  }

  Map<K, List<T>> groupBy<K>(K Function(T) keyOf) {
    final map = <K, List<T>>{};
    for (final element in this) {
      final key = keyOf(element);
      map.putIfAbsent(key, () => []).add(element);
    }
    return map;
  }
}
