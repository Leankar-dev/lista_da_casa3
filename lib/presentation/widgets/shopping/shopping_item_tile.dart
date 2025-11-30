import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/formatters.dart';
import '../../../domain/entities/shopping_item.dart';
import '../../../domain/entities/category.dart';

class ShoppingItemTile extends StatelessWidget {
  final ShoppingItem item;
  final VoidCallback? onToggle;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ShoppingItemTile({
    super.key,
    required this.item,
    this.onToggle,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final category = item.category != null
        ? Category.findById(item.category!)
        : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      child: Dismissible(
        key: Key(item.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: AppConstants.defaultPadding),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          child: const Icon(
            Icons.delete_outline,
            color: AppColors.error,
            size: 28,
          ),
        ),
        confirmDismiss: (direction) async {
          onDelete?.call();
          return false;
        },
        child: Neumorphic(
          style: NeumorphicStyle(
            depth: item.isPurchased ? -4 : 6,
            intensity: AppConstants.neumorphicIntensity,
            color: item.isPurchased
                ? AppColors.background.withValues(alpha: 0.8)
                : AppColors.background,
            boxShape: NeumorphicBoxShape.roundRect(
              BorderRadius.circular(AppConstants.borderRadius),
            ),
          ),
          child: InkWell(
            onTap: onToggle,
            onLongPress: onEdit,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Row(
                children: [
                  _NeumorphicCheckbox(
                    value: item.isPurchased,
                    onChanged: (_) => onToggle?.call(),
                    color: category?.color ?? AppColors.primary,
                  ),
                  const SizedBox(width: AppConstants.defaultPadding),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (category != null) ...[
                              Text(
                                category.icon ?? '',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(width: 4),
                            ],
                            Expanded(
                              child: Text(
                                item.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: item.isPurchased
                                      ? AppColors.textSecondary
                                      : AppColors.textPrimary,
                                  decoration: item.isPurchased
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '${item.quantity}x ${Formatters.currency(item.price)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary.withValues(
                                  alpha: 0.8,
                                ),
                              ),
                            ),
                            if (item.observations?.isNotEmpty == true) ...[
                              const SizedBox(width: 8),
                              Icon(
                                Icons.notes,
                                size: 14,
                                color: AppColors.textSecondary.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        Formatters.currency(item.totalPrice),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: item.isPurchased
                              ? AppColors.textSecondary
                              : AppColors.primary,
                        ),
                      ),
                      if (category != null)
                        Text(
                          category.name,
                          style: TextStyle(
                            fontSize: 10,
                            color: category.color.withValues(alpha: 0.8),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NeumorphicCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color color;

  const _NeumorphicCheckbox({
    required this.value,
    this.onChanged,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged?.call(!value),
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: value ? -4 : 4,
          intensity: AppConstants.neumorphicIntensity,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
          color: value ? color.withValues(alpha: 0.2) : null,
        ),
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: value ? Icon(Icons.check, color: color, size: 20) : null,
        ),
      ),
    );
  }
}
