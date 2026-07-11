import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:venture_link/core/constants/auth_strings.dart';
import 'package:venture_link/core/constants/spacing.dart';
import 'package:venture_link/core/constants/user_roles.dart';
import 'package:venture_link/core/utils/validators.dart';
import 'package:venture_link/core/utils/firebase_auth_exception_mapper.dart';
import 'package:venture_link/features/authentication/presentation/providers/auth_providers.dart';
import 'package:venture_link/features/authentication/presentation/widgets/auth_scaffold.dart';
import 'package:venture_link/features/authentication/presentation/widgets/password_text_field.dart';
import 'package:venture_link/features/authentication/presentation/widgets/register_role_picker.dart';
import 'package:venture_link/shared/extensions/context_extensions.dart';
import 'package:venture_link/shared/widgets/custom_text_field.dart';
import 'package:venture_link/shared/widgets/primary_button.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  var _selectedRole = UserRoles.student;

  bool get _isStartup => _selectedRole == UserRoles.startup;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    await ref.read(registerActionProvider.notifier).register(
          displayName: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          role: _selectedRole,
        );

    if (!mounted) {
      return;
    }

    final registerState = ref.read(registerActionProvider);
    if (registerState.hasError) {
      context.showSnackBar(
        FirebaseAuthExceptionMapper.mapGeneric(registerState.error!),
        isError: true,
      );
      return;
    }

    context.showSnackBar(AuthStrings.registerSuccess);
  }

  @override
  Widget build(BuildContext context) {
    final registerState = ref.watch(registerActionProvider);
    final isLoading = registerState.isLoading;

    return AuthScaffold(
      title: AuthStrings.createAccount,
      subtitle: _isStartup
          ? AuthStrings.registerStartupSubtitle
          : AuthStrings.registerStudentSubtitle,
      showBackButton: true,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RegisterRolePicker(
              selectedRole: _selectedRole,
              onRoleChanged: (role) => setState(() => _selectedRole = role),
            ),
            const SizedBox(height: AppSpacing.lg),
            CustomTextField(
              controller: _nameController,
              label: _isStartup ? AuthStrings.startupName : AuthStrings.fullName,
              hint: _isStartup ? AuthStrings.startupName : AuthStrings.fullName,
              textInputAction: TextInputAction.next,
              prefixIcon: _isStartup
                  ? Icons.apartment_outlined
                  : Icons.person_outline_rounded,
              validator: Validators.validateName,
            ),
            const SizedBox(height: AppSpacing.md),
            CustomTextField(
              controller: _emailController,
              label: AuthStrings.email,
              hint: AuthStrings.email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              prefixIcon: Icons.email_outlined,
              validator: Validators.validateEmail,
            ),
            const SizedBox(height: AppSpacing.md),
            PasswordTextField(
              controller: _passwordController,
              label: AuthStrings.password,
              hint: AuthStrings.password,
              validator: Validators.validatePassword,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSpacing.md),
            PasswordTextField(
              controller: _confirmPasswordController,
              label: AuthStrings.confirmPassword,
              hint: AuthStrings.confirmPassword,
              validator: (value) => Validators.validateConfirmPassword(
                value,
                _passwordController.text,
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _handleRegister(),
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: AuthStrings.register,
              isLoading: isLoading,
              onPressed: isLoading ? null : _handleRegister,
            ),
            const SizedBox(height: AppSpacing.md),
            AuthFooterLink(
              prefix: AuthStrings.haveAccount,
              actionLabel: AuthStrings.signIn,
              onTap: isLoading ? () {} : () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}
