import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/extensions.dart';
import '../../../domain/entities/shopping_list.dart';
import '../../../domain/entities/category.dart';
import '../../widgets/common/neumorphic_app_bar.dart';
import '../../widgets/common/neumorphic_card.dart';

class HistoryDetailScreen extends StatelessWidget {
  final ShoppingList shoppingList;

  const HistoryDetailScreen({super.key, required this.shoppingList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomNeumorphicAppBar(
        title:
            shoppingList.finalizedAt?.toFormattedDate() ?? AppStrings.history,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SummaryCard(shoppingList: shoppingList),
            const SizedBox(height: AppConstants.largePadding),
            const Text(
              AppStrings.itemsPurchased,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            ...shoppingList.items.map((item) {
              final category = item.category != null
                  ? Category.findById(item.category!)
                  : null;
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: AppConstants.smallPadding,
                ),
                child: Neumorphic(
                  style: NeumorphicStyle(
                    depth: 4,
                    intensity: AppConstants.neumorphicIntensity,
                    boxShape: NeumorphicBoxShape.roundRect(
                      BorderRadius.circular(AppConstants.borderRadius),
                    ),
                  ),
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Row(
                    children: [
                      if (category != null)
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: category.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            category.icon ?? '📦',
                            style: const TextStyle(fontSize: 20),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '📦',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      const SizedBox(width: AppConstants.defaultPadding),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${item.quantity}x ${Formatters.currency(item.price)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        Formatters.currency(item.totalPrice),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            // Espaço extra no final para o último item não ficar cortado
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final ShoppingList shoppingList;

  const _SummaryCard({required this.shoppingList});

  @override
  Widget build(BuildContext context) {
    return NeumorphicCard(
      child: Column(
        children: [
          if (shoppingList.marketName != null) ...[
            Row(
              children: [
                const Icon(
                  Icons.store_outlined,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  shoppingList.marketName!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            const Divider(),
            const SizedBox(height: AppConstants.defaultPadding),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                icon: Icons.shopping_bag_outlined,
                label: 'Itens',
                value: '${shoppingList.totalItems}',
              ),
              _StatItem(
                icon: Icons.attach_money,
                label: AppStrings.total,
                value: Formatters.currency(shoppingList.totalValue),
                valueColor: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
