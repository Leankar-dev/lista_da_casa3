import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../domain/entities/market.dart';
import '../../viewmodels/market_viewmodel.dart';
import '../../widgets/common/neumorphic_app_bar.dart';
import '../../widgets/common/neumorphic_text_field.dart';
import '../../widgets/common/neumorphic_button.dart';

class AddEditMarketScreen extends ConsumerStatefulWidget {
  final Market? market;

  const AddEditMarketScreen({super.key, this.market});

  @override
  ConsumerState<AddEditMarketScreen> createState() =>
      _AddEditMarketScreenState();
}

class _AddEditMarketScreenState extends ConsumerState<AddEditMarketScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;

  bool get isEditing => widget.market != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.market?.name ?? '');
    _addressController = TextEditingController(
      text: widget.market?.address ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomNeumorphicAppBar(
        title: isEditing ? AppStrings.editMarket : AppStrings.addMarket,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Neumorphic(
                  style: NeumorphicStyle(
                    depth: 8,
                    intensity: AppConstants.neumorphicIntensity,
                    boxShape: const NeumorphicBoxShape.circle(),
                    color: AppColors.secondary.withValues(alpha: 0.1),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: const Icon(
                    Icons.store,
                    color: AppColors.secondary,
                    size: 48,
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.largePadding),
              NeumorphicTextField(
                controller: _nameController,
                labelText: '${AppStrings.marketName} *',
                hintText: 'Ex: Continente, Pingo Doce...',
                prefixIcon: Icons.store_outlined,
                validator: Validators.marketName,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppConstants.defaultPadding),
              NeumorphicTextField(
                controller: _addressController,
                labelText: AppStrings.marketAddress,
                hintText: 'Ex: Rua das Flores, 123',
                prefixIcon: Icons.location_on_outlined,
                maxLines: 2,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: AppConstants.largePadding * 2),
              NeumorphicPrimaryButton(
                text: AppStrings.save,
                icon: Icons.check,
                onPressed: _saveMarket,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveMarket() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final address = _addressController.text.trim();

      final viewModel = ref.read(marketViewModelProvider.notifier);

      if (isEditing) {
        viewModel.updateMarket(
          widget.market!.copyWith(
            name: name,
            address: address.isEmpty ? null : address,
          ),
        );
        SnackbarHelper.showSuccess(context, AppStrings.marketUpdated);
      } else {
        viewModel.addMarket(
          name: name,
          address: address.isEmpty ? null : address,
        );
        SnackbarHelper.showSuccess(context, AppStrings.marketAdded);
      }

      Navigator.pop(context);
    }
  }
}
