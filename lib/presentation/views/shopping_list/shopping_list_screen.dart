import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../domain/entities/shopping_item.dart';
import '../../viewmodels/shopping_list_viewmodel.dart';
import '../../viewmodels/market_viewmodel.dart';
import '../../viewmodels/history_viewmodel.dart';
import '../../viewmodels/sync_viewmodel.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/common/neumorphic_app_bar.dart';
import '../../widgets/common/neumorphic_card.dart';
import '../../widgets/common/neumorphic_button.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/shopping/shopping_item_tile.dart';
import 'add_item_screen.dart';

class ShoppingListScreen extends ConsumerWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(shoppingListViewModelProvider);
    final syncState = ref.watch(syncViewModelProvider);
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomNeumorphicAppBar(
        title: AppStrings.appName,
        actions: [
          if (authState.isAuthenticated) ...[
            // Menu de sincronização (PopupMenuButton)
            _SyncPopupMenu(syncState: syncState),
          ],
        ],
      ),
      body: state.isLoading
          ? const LoadingIndicator()
          : Column(
              children: [
                if (state.items.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: _ShoppingSummaryCard(state: state),
                  ),

                Expanded(
                  child: state.items.isEmpty
                      ? _EmptyListWidget()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.defaultPadding,
                          ),
                          itemCount: state.items.length,
                          itemBuilder: (context, index) {
                            final item = state.items[index];
                            return ShoppingItemTile(
                              item: item,
                              onToggle: () {
                                ref
                                    .read(
                                      shoppingListViewModelProvider.notifier,
                                    )
                                    .toggleItemPurchased(item.id);
                              },
                              onEdit: () => _editItem(context, ref, item),
                              onDelete: () => _deleteItem(context, ref, item),
                            );
                          },
                        ),
                ),

                if (state.items.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: AppConstants.defaultPadding,
                      right: AppConstants.defaultPadding,
                      top: AppConstants.defaultPadding,
                      bottom: AppConstants.largePadding,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: NeumorphicPrimaryButton(
                            text: AppStrings.finalizePurchase,
                            icon: Icons.check_circle_outline,
                            onPressed: () => _finalizePurchase(context, ref),
                          ),
                        ),
                        const SizedBox(width: AppConstants.defaultPadding),
                        NeumorphicButton(
                          onPressed: () => _addItem(context),
                          style: const NeumorphicStyle(
                            depth: 8,
                            boxShape: NeumorphicBoxShape.circle(),
                            color: AppColors.primary,
                          ),
                          padding: const EdgeInsets.all(14),
                          child: const Icon(
                            Icons.add,
                            color: AppColors.textLight,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (state.items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: AppConstants.defaultPadding,
                      right: AppConstants.defaultPadding,
                      bottom: AppConstants.largePadding,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: NeumorphicButton(
                        onPressed: () => _addItem(context),
                        style: const NeumorphicStyle(
                          depth: 8,
                          boxShape: NeumorphicBoxShape.circle(),
                          color: AppColors.primary,
                        ),
                        padding: const EdgeInsets.all(16),
                        child: const Icon(
                          Icons.add,
                          color: AppColors.textLight,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  void _addItem(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddItemScreen()),
    );
  }

  void _editItem(BuildContext context, WidgetRef ref, ShoppingItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddItemScreen(item: item)),
    );
  }

  void _deleteItem(BuildContext context, WidgetRef ref, ShoppingItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        title: const Text(AppStrings.deleteItem),
        content: const Text(AppStrings.confirmDelete),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(shoppingListViewModelProvider.notifier)
                  .deleteItem(item.id);
              Navigator.pop(context);
              SnackbarHelper.showSuccess(context, AppStrings.itemDeleted);
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

  void _finalizePurchase(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _FinalizeDialog(ref: ref),
    );
  }
}

class _FinalizeDialog extends ConsumerStatefulWidget {
  final WidgetRef ref;

  const _FinalizeDialog({required this.ref});

  @override
  ConsumerState<_FinalizeDialog> createState() => _FinalizeDialogState();
}

class _FinalizeDialogState extends ConsumerState<_FinalizeDialog> {
  String? _selectedMarketId;
  final _newMarketController = TextEditingController();
  bool _showNewMarketField = false;

  @override
  void dispose() {
    _newMarketController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final marketState = ref.watch(marketViewModelProvider);
    final markets = marketState.markets;

    return AlertDialog(
      backgroundColor: AppColors.background,
      title: const Text(AppStrings.finalizePurchase),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selecione o mercado onde fez a compra:',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),

            if (markets.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.textSecondary.withValues(alpha: 0.3),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String?>(
                    value: _selectedMarketId,
                    hint: const Text('Escolher mercado'),
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down),
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('Sem mercado'),
                      ),
                      ...markets.map(
                        (market) => DropdownMenuItem<String?>(
                          value: market.id,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.store,
                                size: 18,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  market.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedMarketId = value;
                        _showNewMarketField = false;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),

              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _showNewMarketField = !_showNewMarketField;
                    if (_showNewMarketField) {
                      _selectedMarketId = null;
                    }
                  });
                },
                icon: Icon(
                  _showNewMarketField ? Icons.close : Icons.add,
                  size: 18,
                ),
                label: Text(
                  _showNewMarketField ? 'Cancelar' : 'Adicionar novo mercado',
                ),
              ),
            ],

            if (_showNewMarketField || markets.isEmpty) ...[
              const SizedBox(height: 8),
              TextField(
                controller: _newMarketController,
                decoration: InputDecoration(
                  labelText: 'Nome do novo mercado',
                  hintText: 'Ex: Continente, Pingo Doce...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.store_outlined),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(AppStrings.cancel),
        ),
        TextButton(
          onPressed: () async {
            String? marketId = _selectedMarketId;

            if (_newMarketController.text.trim().isNotEmpty) {
              await ref
                  .read(marketViewModelProvider.notifier)
                  .addMarket(name: _newMarketController.text.trim());

              final updatedMarkets = ref.read(marketViewModelProvider).markets;
              final newMarket = updatedMarkets.lastOrNull;
              marketId = newMarket?.id;
            }

            await widget.ref
                .read(shoppingListViewModelProvider.notifier)
                .finalizePurchase(marketId);

            await widget.ref
                .read(historyViewModelProvider.notifier)
                .loadHistory();

            if (context.mounted) {
              Navigator.pop(context);
              SnackbarHelper.showSuccess(context, AppStrings.purchaseFinalized);
            }
          },
          child: const Text(
            AppStrings.confirm,
            style: TextStyle(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}

class _ShoppingSummaryCard extends StatelessWidget {
  final ShoppingListState state;

  const _ShoppingSummaryCard({required this.state});

  @override
  Widget build(BuildContext context) {
    return NeumorphicCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SummaryItem(
                icon: Icons.shopping_bag_outlined,
                label: 'Itens',
                value: '${state.purchasedItems}/${state.totalItems}',
              ),
              _SummaryItem(
                icon: Icons.attach_money,
                label: AppStrings.total,
                value: Formatters.currency(state.totalValue),
                valueColor: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.defaultPadding),

          NeumorphicProgressIndicator(
            progress: state.totalItems > 0
                ? state.purchasedItems / state.totalItems
                : 0,
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
  final Color? valueColor;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: valueColor ?? AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _EmptyListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkShadow.withValues(alpha: 0.3),
                  offset: const Offset(6, 6),
                  blurRadius: 12,
                ),
                const BoxShadow(
                  color: AppColors.lightShadow,
                  offset: Offset(-6, -6),
                  blurRadius: 12,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset('assets/images/logo.jpg', fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: AppConstants.largePadding),
          const Text(
            AppStrings.byDeveloper,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            AppStrings.addNewItem,
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

enum _SyncMenuOption { uploadToCloud, downloadFromCloud, clearCloud }

class _SyncPopupMenu extends ConsumerWidget {
  final SyncState syncState;

  const _SyncPopupMenu({required this.syncState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<_SyncMenuOption>(
      icon: syncState.isSyncing
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            )
          : const Icon(Icons.more_vert, color: AppColors.textPrimary, size: 24),
      enabled: !syncState.isSyncing,
      tooltip: AppStrings.syncMenu,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.background,
      elevation: 8,
      onSelected: (option) => _handleMenuSelection(context, ref, option),
      itemBuilder: (context) => [
        PopupMenuItem<_SyncMenuOption>(
          value: _SyncMenuOption.uploadToCloud,
          child: Row(
            children: [
              const Icon(
                Icons.cloud_upload_outlined,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                AppStrings.saveToCloud,
                style: const TextStyle(color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
        PopupMenuItem<_SyncMenuOption>(
          value: _SyncMenuOption.downloadFromCloud,
          child: Row(
            children: [
              const Icon(
                Icons.cloud_download_outlined,
                color: AppColors.info,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                AppStrings.downloadFromCloud,
                style: const TextStyle(color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<_SyncMenuOption>(
          value: _SyncMenuOption.clearCloud,
          child: Row(
            children: [
              const Icon(
                Icons.cloud_off_outlined,
                color: AppColors.error,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                AppStrings.clearCloud,
                style: const TextStyle(color: AppColors.error),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleMenuSelection(
    BuildContext context,
    WidgetRef ref,
    _SyncMenuOption option,
  ) {
    switch (option) {
      case _SyncMenuOption.uploadToCloud:
        _uploadToCloud(context, ref);
        break;
      case _SyncMenuOption.downloadFromCloud:
        _showDownloadDialog(context, ref);
        break;
      case _SyncMenuOption.clearCloud:
        _showClearCloudDialog(context, ref);
        break;
    }
  }

  Future<void> _uploadToCloud(BuildContext context, WidgetRef ref) async {
    final success = await ref
        .read(syncViewModelProvider.notifier)
        .syncToCloud();
    if (context.mounted) {
      if (success) {
        SnackbarHelper.showSuccess(context, AppStrings.syncSuccess);
      } else {
        SnackbarHelper.showError(context, AppStrings.syncError);
      }
    }
  }

  void _showDownloadDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        title: Row(
          children: [
            const Icon(
              Icons.cloud_download_outlined,
              color: AppColors.info,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(AppStrings.downloadFromCloud),
          ],
        ),
        content: Text(
          AppStrings.downloadFromCloudConfirm,
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await ref
                  .read(syncViewModelProvider.notifier)
                  .downloadFromCloud();
              if (context.mounted) {
                if (success) {
                  // Recarregar os dados
                  ref.read(historyViewModelProvider.notifier).loadHistory();
                  ref.read(marketViewModelProvider.notifier).loadMarkets();
                  SnackbarHelper.showSuccess(
                    context,
                    AppStrings.downloadSuccess,
                  );
                } else {
                  SnackbarHelper.showError(context, AppStrings.downloadError);
                }
              }
            },
            child: Text(
              AppStrings.confirm,
              style: const TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCloudDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warning,
              size: 28,
            ),
            const SizedBox(width: 12),
            const Text(AppStrings.clearCloud),
          ],
        ),
        content: const Text(
          AppStrings.clearCloudConfirm,
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await ref
                  .read(syncViewModelProvider.notifier)
                  .clearCloudData();
              if (context.mounted) {
                if (success) {
                  SnackbarHelper.showSuccess(
                    context,
                    AppStrings.clearCloudSuccess,
                  );
                } else {
                  SnackbarHelper.showError(context, AppStrings.clearCloudError);
                }
              }
            },
            child: Text(
              AppStrings.delete,
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
