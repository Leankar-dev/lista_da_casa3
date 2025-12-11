import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/sync_viewmodel.dart';
import '../../widgets/common/neumorphic_text_field.dart';
import '../../widgets/common/neumorphic_button.dart';
import '../home/home_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.error != null) {
        SnackbarHelper.showError(context, _getErrorMessage(next.error!));
        ref.read(authViewModelProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Row(
                children: [
                  NeumorphicButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: const NeumorphicStyle(
                      depth: 4,
                      boxShape: NeumorphicBoxShape.circle(),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Criar Conta',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
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
                            color: AppColors.primary.withValues(alpha: 0.1),
                          ),
                          padding: const EdgeInsets.all(24),
                          child: const Icon(
                            Icons.person_add_outlined,
                            size: 48,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      const Center(
                        child: Text(
                          'Crie uma conta para sincronizar\nos seus dados na nuvem',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 32),

                      NeumorphicTextField(
                        controller: _emailController,
                        labelText: '${AppStrings.email} *',
                        hintText: 'exemplo@email.com',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: Validators.email,
                      ),
                      const SizedBox(height: AppConstants.defaultPadding),

                      NeumorphicTextField(
                        controller: _passwordController,
                        labelText: '${AppStrings.password} *',
                        hintText: 'Mínimo 6 caracteres',
                        prefixIcon: Icons.lock_outlined,
                        obscureText: _obscurePassword,
                        suffixIcon: _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        onSuffixIconPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        textInputAction: TextInputAction.next,
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: AppConstants.defaultPadding),

                      NeumorphicTextField(
                        controller: _confirmPasswordController,
                        labelText: 'Confirmar Palavra-passe *',
                        hintText: 'Repita a palavra-passe',
                        prefixIcon: Icons.lock_outlined,
                        obscureText: _obscureConfirmPassword,
                        suffixIcon: _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        onSuffixIconPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                        textInputAction: TextInputAction.done,
                        validator: _validateConfirmPassword,
                        onSubmitted: (_) => _register(),
                      ),
                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.info.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'A palavra-passe deve conter:',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildPasswordRequirement(
                              'Pelo menos 6 caracteres',
                              _passwordController.text.length >= 6,
                            ),
                            _buildPasswordRequirement(
                              'Pelo menos uma letra maiúscula',
                              _passwordController.text.contains(
                                RegExp(r'[A-Z]'),
                              ),
                            ),
                            _buildPasswordRequirement(
                              'Pelo menos um número',
                              _passwordController.text.contains(
                                RegExp(r'[0-9]'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      NeumorphicPrimaryButton(
                        text: 'Criar Conta',
                        icon: Icons.person_add,
                        onPressed: authState.isLoading ? null : _register,
                        isLoading: authState.isLoading,
                      ),
                      const SizedBox(height: 24),

                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Já tem uma conta? ',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Faça login',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordRequirement(String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: isValid ? AppColors.success : AppColors.textSecondary,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isValid ? AppColors.success : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.errorRequired;
    }
    if (value.length < 6) {
      return 'A palavra-passe deve ter pelo menos 6 caracteres';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'A palavra-passe deve conter pelo menos uma letra maiúscula';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'A palavra-passe deve conter pelo menos um número';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.errorRequired;
    }
    if (value != _passwordController.text) {
      return 'As palavras-passe não coincidem';
    }
    return null;
  }

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref
          .read(authViewModelProvider.notifier)
          .registerWithEmail(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      final authState = ref.read(authViewModelProvider);
      if (authState.isAuthenticated && mounted) {
        ref.read(syncViewModelProvider.notifier).syncToCloud();

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      }
    }
  }

  String _getErrorMessage(String error) {
    if (error.contains('email-already-in-use')) {
      return 'Este email já está registado';
    } else if (error.contains('invalid-email')) {
      return 'Email inválido';
    } else if (error.contains('weak-password')) {
      return 'Palavra-passe muito fraca';
    } else if (error.contains('operation-not-allowed')) {
      return 'Operação não permitida';
    } else if (error.contains('network-request-failed')) {
      return 'Erro de ligação à internet';
    }
    return 'Erro ao criar conta. Tente novamente.';
  }
}
