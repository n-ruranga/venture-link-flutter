import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:venture_link/core/constants/auth_strings.dart';
import 'package:venture_link/core/constants/colors.dart';
import 'package:venture_link/core/constants/spacing.dart';
import 'package:venture_link/core/routes/route_names.dart';
import 'package:venture_link/core/utils/validators.dart';
import 'package:venture_link/core/utils/firebase_auth_exception_mapper.dart';
import 'package:venture_link/features/authentication/presentation/providers/auth_providers.dart';
import 'package:venture_link/features/authentication/presentation/widgets/auth_scaffold.dart';
import 'package:venture_link/features/authentication/presentation/widgets/password_text_field.dart';
import 'package:venture_link/shared/extensions/context_extensions.dart';
import 'package:venture_link/shared/widgets/custom_text_field.dart';
import 'package:venture_link/shared/widgets/primary_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadRememberedEmail());
  }

  Future<void> _loadRememberedEmail() async {
    final remembered = await ref.read(rememberedEmailProvider.future);
    if (!mounted) {
      return;
    }
    setState(() {
      _rememberMe = remembered.rememberMe;
      if (remembered.email != null) {
        _emailController.text = remembered.email!;
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    await ref.read(loginActionProvider.notifier).signIn(
          email: _emailController.text,
          password: _passwordController.text,
          rememberMe: _rememberMe,
        );

    if (!mounted) {
      return;
    }

    final loginState = ref.read(loginActionProvider);
    if (loginState.hasError) {
      context.showSnackBar(
        FirebaseAuthExceptionMapper.mapGeneric(loginState.error!),
        isError: true,
      );
      return;
    }

    context.showSnackBar(AuthStrings.loginSuccess);
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginActionProvider);
    final isLoading = loginState.isLoading;

    return AuthScaffold(
      title: AuthStrings.welcomeBack,
      subtitle: AuthStrings.loginSubtitle,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
              validator: Validators.validatePasswordRequired,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _handleLogin(),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: isLoading
                      ? null
                      : (value) => setState(() => _rememberMe = value ?? false),
                  activeColor: AppColors.primary,
                ),
                Text(
                  AuthStrings.rememberMe,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () => context.push(RouteNames.forgotPassword),
                  child: const Text(AuthStrings.forgotPassword),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              label: AuthStrings.login,
              isLoading: isLoading,
              onPressed: isLoading ? null : _handleLogin,
            ),
            const SizedBox(height: AppSpacing.md),
            AuthFooterLink(
              prefix: AuthStrings.noAccount,
              actionLabel: AuthStrings.signUp,
              onTap: isLoading ? () {} : () => context.push(RouteNames.register),
            ),
          ],
        ),
      ),
    );
  }
}
