import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../domain/entities/shopping_list.dart';
import '../../../domain/entities/shopping_item.dart';
import '../../../domain/entities/category.dart';
import '../../viewmodels/history_viewmodel.dart';
import '../../viewmodels/market_viewmodel.dart';
import '../../widgets/common/neumorphic_app_bar.dart';
import '../../widgets/common/neumorphic_card.dart';
import '../../widgets/common/neumorphic_button.dart';
import '../../../core/di/injection.dart';

class EditHistoryScreen extends ConsumerStatefulWidget {
  final ShoppingList shoppingList;

  const EditHistoryScreen({super.key, required this.shoppingList});

  @override
  ConsumerState<EditHistoryScreen> createState() => _EditHistoryScreenState();
}

class _EditHistoryScreenState extends ConsumerState<EditHistoryScreen> {
  late String? _selectedMarketId;
  late String? _selectedMarketName;
  late List<ShoppingItem> _items;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _selectedMarketId = widget.shoppingList.marketId;
    _selectedMarketName = widget.shoppingList.marketName;
    _items = List.from(widget.shoppingList.items);
  }

  @override
  Widget build(BuildContext context) {
    final marketState = ref.watch(marketViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomNeumorphicAppBar(
        title: 'Editar Compra',
        actions: [
          if (_hasChanges)
            NeumorphicAppBarAction(
              icon: Icons.save,
              iconColor: AppColors.primary,
              onPressed: _saveChanges,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NeumorphicCard(
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Data da Compra',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        widget.shoppingList.finalizedAt?.toFormattedDate() ??
                            '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),

            const Text(
              'Mercado',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
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
                  hint: const Text('Selecionar mercado'),
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Sem mercado'),
                    ),
                    ...marketState.markets.map(
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
                      _selectedMarketName = value != null
                          ? marketState.markets
                                .firstWhere((m) => m.id == value)
                                .name
                          : null;
                      _hasChanges = true;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: AppConstants.largePadding),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Itens da Compra',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${_items.length} ${_items.length == 1 ? 'item' : 'itens'}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ..._items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return _EditableItemCard(
                item: item,
                onEdit: () => _editItem(index, item),
                onDelete: () => _deleteItem(index),
              );
            }),

            const SizedBox(height: AppConstants.largePadding),

            NeumorphicCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total da Compra',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    Formatters.currency(_calculateTotal()),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),

            if (_hasChanges)
              NeumorphicPrimaryButton(
                text: 'Guardar Alterações',
                icon: Icons.save,
                onPressed: _saveChanges,
              ),
          ],
        ),
      ),
    );
  }

  double _calculateTotal() {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  void _editItem(int index, ShoppingItem item) {
    showDialog(
      context: context,
      builder: (context) => _EditItemDialog(
        item: item,
        onSave: (updatedItem) {
          setState(() {
            _items[index] = updatedItem;
            _hasChanges = true;
          });
        },
      ),
    );
  }

  void _deleteItem(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        title: const Text('Eliminar Item'),
        content: Text(
          'Tem a certeza que deseja eliminar "${_items[index].name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _items.removeAt(index);
                _hasChanges = true;
              });
              Navigator.pop(context);
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

  Future<void> _saveChanges() async {
    try {
      final repository = ref.read(shoppingListRepositoryProvider);

      final updatedList = widget.shoppingList.copyWith(
        marketId: _selectedMarketId,
        marketName: _selectedMarketName,
        updatedAt: DateTime.now(),
      );

      await repository.updateList(updatedList);

      final itemRepository = ref.read(shoppingItemRepositoryProvider);

      final originalIds = widget.shoppingList.items.map((i) => i.id).toSet();
      final currentIds = _items.map((i) => i.id).toSet();
      final deletedIds = originalIds.difference(currentIds);

      for (final id in deletedIds) {
        await itemRepository.deleteItem(id);
      }

      for (final item in _items) {
        await itemRepository.updateItem(item);
      }

      await ref.read(historyViewModelProvider.notifier).loadHistory();

      if (mounted) {
        SnackbarHelper.showSuccess(context, 'Compra atualizada com sucesso');
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        SnackbarHelper.showError(context, 'Erro ao guardar alterações');
      }
    }
  }
}

class _EditableItemCard extends StatelessWidget {
  final ShoppingItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _EditableItemCard({
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final category = item.category != null
        ? Category.findById(item.category!)
        : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.smallPadding),
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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (category?.color ?? AppColors.textSecondary).withValues(
                  alpha: 0.1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                category?.icon ?? '📦',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(width: 12),
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
            const SizedBox(width: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      size: 16,
                      color: AppColors.error,
                    ),
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

class _EditItemDialog extends StatefulWidget {
  final ShoppingItem item;
  final Function(ShoppingItem) onSave;

  const _EditItemDialog({required this.item, required this.onSave});

  @override
  State<_EditItemDialog> createState() => _EditItemDialogState();
}

class _EditItemDialogState extends State<_EditItemDialog> {
  late TextEditingController _quantityController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(
      text: widget.item.quantity.toString(),
    );
    _priceController = TextEditingController(
      text: widget.item.price.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      title: Text('Editar ${widget.item.name}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: AppStrings.quantity,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.numbers),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: '${AppStrings.price} (€)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.euro),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(AppStrings.cancel),
        ),
        TextButton(
          onPressed: () {
            final quantity = int.tryParse(_quantityController.text) ?? 1;
            final price =
                double.tryParse(_priceController.text.replaceAll(',', '.')) ??
                0;

            final updatedItem = widget.item.copyWith(
              quantity: quantity,
              price: price,
              updatedAt: DateTime.now(),
            );

            widget.onSave(updatedItem);
            Navigator.pop(context);
          },
          child: const Text(
            AppStrings.save,
            style: TextStyle(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
