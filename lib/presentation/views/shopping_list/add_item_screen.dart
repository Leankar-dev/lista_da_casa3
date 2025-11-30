import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../domain/entities/shopping_item.dart';
import '../../../domain/entities/category.dart';
import '../../viewmodels/shopping_list_viewmodel.dart';
import '../../widgets/common/neumorphic_app_bar.dart';
import '../../widgets/common/neumorphic_text_field.dart';
import '../../widgets/common/neumorphic_button.dart';
import '../../widgets/common/neumorphic_card.dart';

class AddItemScreen extends ConsumerStatefulWidget {
  final ShoppingItem? item;

  const AddItemScreen({super.key, this.item});

  @override
  ConsumerState<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends ConsumerState<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;
  late final TextEditingController _priceController;
  late final TextEditingController _observationsController;
  String? _selectedCategory;

  bool get isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item?.name ?? '');
    _quantityController = TextEditingController(
      text: widget.item?.quantity.toString() ?? '1',
    );
    _priceController = TextEditingController(
      text: widget.item?.price.toStringAsFixed(2) ?? '',
    );
    _observationsController = TextEditingController(
      text: widget.item?.observations ?? '',
    );
    _selectedCategory = widget.item?.category;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomNeumorphicAppBar(
        title: isEditing ? AppStrings.editItem : AppStrings.addItem,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NeumorphicTextField(
                controller: _nameController,
                labelText: '${AppStrings.itemName} *',
                hintText: 'Ex: Leite, Pão, Arroz...',
                prefixIcon: Icons.shopping_bag_outlined,
                validator: Validators.itemName,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppConstants.defaultPadding),

              Row(
                children: [
                  Expanded(
                    child: NeumorphicTextField(
                      controller: _quantityController,
                      labelText: '${AppStrings.quantity} *',
                      hintText: '1',
                      prefixIcon: Icons.numbers,
                      keyboardType: TextInputType.number,
                      validator: Validators.quantity,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(width: AppConstants.defaultPadding),
                  Expanded(
                    child: NeumorphicTextField(
                      controller: _priceController,
                      labelText: '${AppStrings.price} *',
                      hintText: '0.00',
                      prefixIcon: Icons.euro,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: Validators.price,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.defaultPadding),

              const Text(
                AppStrings.category,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              _CategorySelector(
                selectedCategory: _selectedCategory,
                onCategorySelected: (category) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
              ),
              const SizedBox(height: AppConstants.defaultPadding),

              NeumorphicTextField(
                controller: _observationsController,
                labelText: AppStrings.observations,
                hintText: 'Notas adicionais...',
                prefixIcon: Icons.notes_outlined,
                maxLines: 3,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: AppConstants.largePadding),

              NeumorphicFlatCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      _calculateTotal(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.largePadding),

              NeumorphicPrimaryButton(
                text: AppStrings.save,
                icon: Icons.check,
                onPressed: _saveItem,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _calculateTotal() {
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    final price = Formatters.parsePrice(_priceController.text) ?? 0;
    return Formatters.currency(quantity * price);
  }

  void _saveItem() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final quantity = int.parse(_quantityController.text);
      final price = Formatters.parsePrice(_priceController.text) ?? 0;
      final observations = _observationsController.text.trim();

      final viewModel = ref.read(shoppingListViewModelProvider.notifier);

      if (isEditing) {
        viewModel.updateItem(
          widget.item!.copyWith(
            name: name,
            quantity: quantity,
            price: price,
            category: _selectedCategory,
            observations: observations.isEmpty ? null : observations,
          ),
        );
        SnackbarHelper.showSuccess(context, AppStrings.itemUpdated);
      } else {
        viewModel.addItem(
          name: name,
          quantity: quantity,
          price: price,
          category: _selectedCategory,
          observations: observations.isEmpty ? null : observations,
        );
        SnackbarHelper.showSuccess(context, AppStrings.itemAdded);
      }

      Navigator.pop(context);
    }
  }
}

class _CategorySelector extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;

  const _CategorySelector({
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = Category.defaultCategories;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((category) {
        final isSelected = selectedCategory == category.id;
        return GestureDetector(
          onTap: () => onCategorySelected(isSelected ? null : category.id),
          child: Neumorphic(
            style: NeumorphicStyle(
              depth: isSelected ? -4 : 4,
              intensity: AppConstants.neumorphicIntensity,
              color: isSelected
                  ? category.color.withValues(alpha: 0.2)
                  : AppColors.background,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(category.icon ?? '', style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 4),
                Text(
                  category.name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isSelected
                        ? category.color
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
