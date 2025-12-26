import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/formatters.dart';
import '../../viewmodels/history_viewmodel.dart';
import '../../widgets/common/neumorphic_app_bar.dart';
import '../../widgets/common/neumorphic_card.dart';
import '../../widgets/common/loading_indicator.dart';

class MonthlyTotal {
  final int year;
  final int month;
  final double total;
  final int listCount;

  const MonthlyTotal({
    required this.year,
    required this.month,
    required this.total,
    required this.listCount,
  });

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

  String get formattedPeriod => '$monthName $year';
  String get shortPeriod => '${month.toString().padLeft(2, '0')}/$year';
}

class MonthlyTotalsScreen extends ConsumerStatefulWidget {
  const MonthlyTotalsScreen({super.key});

  @override
  ConsumerState<MonthlyTotalsScreen> createState() =>
      _MonthlyTotalsScreenState();
}

class _MonthlyTotalsScreenState extends ConsumerState<MonthlyTotalsScreen> {
  int? _selectedYear;
  List<int> _availableYears = [];

  @override
  void initState() {
    super.initState();
    _initializeYears();
  }

  void _initializeYears() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(historyViewModelProvider);
      final years = _extractYears(state);
      if (years.isNotEmpty) {
        setState(() {
          _availableYears = years;
          _selectedYear = years.first;
        });
      }
    });
  }

  List<int> _extractYears(HistoryState state) {
    final years = <int>{};
    for (final list in state.history) {
      if (list.finalizedAt != null) {
        years.add(list.finalizedAt!.year);
      }
    }
    final sortedYears = years.toList()..sort((a, b) => b.compareTo(a));
    return sortedYears;
  }

  List<MonthlyTotal> _getMonthlyTotals(HistoryState state) {
    if (_selectedYear == null) return [];

    final Map<int, MonthlyTotal> monthlyData = {};

    for (final list in state.history) {
      if (list.finalizedAt != null && list.finalizedAt!.year == _selectedYear) {
        final month = list.finalizedAt!.month;
        final existing = monthlyData[month];

        if (existing != null) {
          monthlyData[month] = MonthlyTotal(
            year: _selectedYear!,
            month: month,
            total: existing.total + list.totalValue,
            listCount: existing.listCount + 1,
          );
        } else {
          monthlyData[month] = MonthlyTotal(
            year: _selectedYear!,
            month: month,
            total: list.totalValue,
            listCount: 1,
          );
        }
      }
    }

    final result = monthlyData.values.toList()
      ..sort((a, b) => b.month.compareTo(a.month));
    return result;
  }

  double _getYearTotal(List<MonthlyTotal> monthlyTotals) {
    return monthlyTotals.fold(0, (sum, item) => sum + item.total);
  }

  int _getTotalLists(List<MonthlyTotal> monthlyTotals) {
    return monthlyTotals.fold(0, (sum, item) => sum + item.listCount);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(historyViewModelProvider);

    final years = _extractYears(state);
    if (years.isNotEmpty && _availableYears.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _availableYears = years;
          _selectedYear = years.first;
        });
      });
    }

    final monthlyTotals = _getMonthlyTotals(state);
    final yearTotal = _getYearTotal(monthlyTotals);
    final totalLists = _getTotalLists(monthlyTotals);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomNeumorphicAppBar(title: AppStrings.monthlyTotals),
      body: state.isLoading
          ? const LoadingIndicator()
          : state.history.isEmpty
          ? _NoDataWidget()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _YearSelector(
                    years: _availableYears,
                    selectedYear: _selectedYear,
                    onYearChanged: (year) {
                      setState(() {
                        _selectedYear = year;
                      });
                    },
                  ),
                  const SizedBox(height: AppConstants.largePadding),

                  _YearSummaryCard(
                    year: _selectedYear ?? DateTime.now().year,
                    total: yearTotal,
                    listCount: totalLists,
                    monthCount: monthlyTotals.length,
                  ),
                  const SizedBox(height: AppConstants.largePadding),

                  if (monthlyTotals.isNotEmpty) ...[
                    const Text(
                      'Gastos por Mês',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.defaultPadding),
                    _MonthlyBarChart(monthlyTotals: monthlyTotals),
                    const SizedBox(height: AppConstants.largePadding),
                  ],

                  const Text(
                    'Detalhes por Mês',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  if (monthlyTotals.isEmpty)
                    _NoMonthlyDataWidget(year: _selectedYear)
                  else
                    ...monthlyTotals.map(
                      (monthly) => _MonthlyTotalCard(monthlyTotal: monthly),
                    ),
                ],
              ),
            ),
    );
  }
}

class _YearSelector extends StatelessWidget {
  final List<int> years;
  final int? selectedYear;
  final ValueChanged<int?> onYearChanged;

  const _YearSelector({
    required this.years,
    required this.selectedYear,
    required this.onYearChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (years.isEmpty) {
      return const SizedBox.shrink();
    }

    return NeumorphicCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.calendar_today, size: 20, color: AppColors.primary),
              SizedBox(width: 12),
              Text(
                'Ano',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
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
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: selectedYear,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.primary,
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
                dropdownColor: AppColors.background,
                items: years.map((year) {
                  return DropdownMenuItem<int>(
                    value: year,
                    child: Text(year.toString()),
                  );
                }).toList(),
                onChanged: onYearChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _YearSummaryCard extends StatelessWidget {
  final int year;
  final double total;
  final int listCount;
  final int monthCount;

  const _YearSummaryCard({
    required this.year,
    required this.total,
    required this.listCount,
    required this.monthCount,
  });

  @override
  Widget build(BuildContext context) {
    final avgPerMonth = monthCount > 0 ? total / monthCount : 0.0;

    return NeumorphicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total $year',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  Formatters.currency(total),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          const Divider(height: 1, color: AppColors.darkShadow),
          const SizedBox(height: AppConstants.defaultPadding),
          Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  icon: Icons.receipt_long,
                  label: 'Compras',
                  value: listCount.toString(),
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.darkShadow.withValues(alpha: 0.3),
              ),
              Expanded(
                child: _SummaryItem(
                  icon: Icons.date_range,
                  label: 'Meses',
                  value: monthCount.toString(),
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.darkShadow.withValues(alpha: 0.3),
              ),
              Expanded(
                child: _SummaryItem(
                  icon: Icons.trending_up,
                  label: 'Média/Mês',
                  value: Formatters.currency(avgPerMonth),
                  isHighlighted: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isHighlighted;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: isHighlighted ? AppColors.primary : AppColors.textSecondary,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: isHighlighted ? 13 : 14,
            fontWeight: FontWeight.w600,
            color: isHighlighted ? AppColors.primary : AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _MonthlyBarChart extends StatelessWidget {
  final List<MonthlyTotal> monthlyTotals;

  const _MonthlyBarChart({required this.monthlyTotals});

  @override
  Widget build(BuildContext context) {
    final sortedTotals = List<MonthlyTotal>.from(monthlyTotals)
      ..sort((a, b) => a.month.compareTo(b.month));

    final maxValue = sortedTotals
        .map((e) => e.total)
        .reduce((a, b) => a > b ? a : b);

    return NeumorphicCard(
      child: SizedBox(
        height: 220,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: maxValue * 1.2,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                tooltipPadding: const EdgeInsets.all(8),
                tooltipMargin: 8,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final monthly = sortedTotals[group.x.toInt()];
                  return BarTooltipItem(
                    '${monthly.monthName}\n${Formatters.currency(monthly.total)}',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < sortedTotals.length) {
                      final monthNames = [
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
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          monthNames[sortedTotals[index].month - 1],
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 50,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '€${value.toInt()}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: maxValue / 4,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: AppColors.textSecondary.withValues(alpha: 0.2),
                  strokeWidth: 1,
                );
              },
            ),
            barGroups: sortedTotals.asMap().entries.map((e) {
              return BarChartGroupData(
                x: e.key,
                barRods: [
                  BarChartRodData(
                    toY: e.value.total,
                    color: AppColors.primary,
                    width: 20,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: maxValue * 1.2,
                      color: AppColors.primary.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _MonthlyTotalCard extends StatelessWidget {
  final MonthlyTotal monthlyTotal;

  const _MonthlyTotalCard({required this.monthlyTotal});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      child: NeumorphicCard(
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  monthlyTotal.month.toString().padLeft(2, '0'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppConstants.defaultPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    monthlyTotal.monthName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${monthlyTotal.listCount} ${monthlyTotal.listCount == 1 ? 'compra' : 'compras'}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Formatters.currency(monthlyTotal.total),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'média: ${Formatters.currency(monthlyTotal.total / monthlyTotal.listCount)}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NoDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 80,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          const Text(
            AppStrings.noData,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Finalize algumas compras para ver os totais mensais',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _NoMonthlyDataWidget extends StatelessWidget {
  final int? year;

  const _NoMonthlyDataWidget({this.year});

  @override
  Widget build(BuildContext context) {
    return NeumorphicCard(
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.event_busy,
              size: 40,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              year != null
                  ? 'Sem dados para $year'
                  : 'Selecione um ano para ver os dados',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
