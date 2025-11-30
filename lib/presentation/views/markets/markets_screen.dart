import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../domain/entities/market.dart';
import '../../viewmodels/market_viewmodel.dart';
import '../../widgets/common/neumorphic_app_bar.dart';
import '../../widgets/common/neumorphic_card.dart';
import '../../widgets/common/loading_indicator.dart';
import 'add_edit_market_screen.dart';

class MarketsScreen extends ConsumerWidget {
  const MarketsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(marketViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomNeumorphicAppBar(title: AppStrings.marketManagement),
      body: state.isLoading
          ? const LoadingIndicator()
          : state.markets.isEmpty
          ? _EmptyMarketsWidget()
          : ListView.builder(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              itemCount: state.markets.length,
              itemBuilder: (context, index) {
                final market = state.markets[index];
                return _MarketTile(
                  market: market,
                  onEdit: () => _editMarket(context, market),
                  onDelete: () => _deleteMarket(context, ref, market),
                );
              },
            ),
      floatingActionButton: NeumorphicButton(
        onPressed: () => _addMarket(context),
        style: const NeumorphicStyle(
          depth: 8,
          boxShape: NeumorphicBoxShape.circle(),
          color: AppColors.primary,
        ),
        padding: const EdgeInsets.all(16),
        child: const Icon(Icons.add, color: AppColors.textLight, size: 28),
      ),
    );
  }

  void _addMarket(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEditMarketScreen()),
    );
  }

  void _editMarket(BuildContext context, Market market) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditMarketScreen(market: market),
      ),
    );
  }

  void _deleteMarket(BuildContext context, WidgetRef ref, Market market) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        title: const Text(AppStrings.deleteMarket),
        content: const Text(AppStrings.confirmDelete),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(marketViewModelProvider.notifier)
                  .deleteMarket(market.id);
              Navigator.pop(context);
              SnackbarHelper.showSuccess(context, AppStrings.marketDeleted);
            },
            child: const Text(
              AppStrings.delete,
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _MarketTile extends StatelessWidget {
  final Market market;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _MarketTile({required this.market, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      child: Dismissible(
        key: Key(market.id),
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
        child: NeumorphicCard(
          onTap: onEdit,
          child: Row(
            children: [
              Neumorphic(
                style: NeumorphicStyle(
                  depth: -4,
                  intensity: AppConstants.neumorphicIntensity,
                  boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular(12),
                  ),
                  color: AppColors.secondary.withValues(alpha: 0.1),
                ),
                padding: const EdgeInsets.all(12),
                child: const Icon(
                  Icons.store,
                  color: AppColors.secondary,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppConstants.defaultPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      market.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (market.address != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.8,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              market.address!,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary.withValues(
                                  alpha: 0.8,
                                ),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.edit_outlined,
                color: AppColors.textSecondary.withValues(alpha: 0.6),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyMarketsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.store_outlined,
            size: 80,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          const Text(
            AppStrings.noMarkets,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
