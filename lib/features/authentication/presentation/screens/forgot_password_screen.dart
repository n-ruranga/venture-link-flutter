import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:venture_link/core/constants/auth_strings.dart';
import 'package:venture_link/core/constants/spacing.dart';
import 'package:venture_link/core/utils/validators.dart';
import 'package:venture_link/core/utils/firebase_auth_exception_mapper.dart';
import 'package:venture_link/features/authentication/presentation/providers/auth_providers.dart';
import 'package:venture_link/features/authentication/presentation/widgets/auth_scaffold.dart';
import 'package:venture_link/shared/extensions/context_extensions.dart';
import 'package:venture_link/shared/widgets/custom_text_field.dart';
import 'package:venture_link/shared/widgets/primary_button.dart';
import 'package:venture_link/shared/widgets/secondary_button.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    await ref.read(forgotPasswordActionProvider.notifier).sendResetEmail(
          _emailController.text,
        );

    if (!mounted) {
      return;
    }

    final state = ref.read(forgotPasswordActionProvider);
    if (state.hasError) {
      context.showSnackBar(
        FirebaseAuthExceptionMapper.mapGeneric(state.error!),
        isError: true,
      );
      return;
    }

    setState(() => _emailSent = true);
    context.showSnackBar(AuthStrings.resetLinkSent);
  }

  @override
  Widget build(BuildContext context) {
    final resetState = ref.watch(forgotPasswordActionProvider);
    final isLoading = resetState.isLoading;

    return AuthScaffold(
      title: AuthStrings.resetPassword,
      subtitle: AuthStrings.resetPasswordSubtitle,
      showBackButton: true,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_emailSent)
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF22C55E).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline_rounded,
                      color: Color(0xFF22C55E),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        AuthStrings.resetLinkSent,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            CustomTextField(
              controller: _emailController,
              label: AuthStrings.email,
              hint: AuthStrings.email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              prefixIcon: Icons.email_outlined,
              validator: Validators.validateEmail,
              onSubmitted: (_) => _handleResetPassword(),
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: AuthStrings.sendResetLink,
              isLoading: isLoading,
              onPressed: isLoading ? null : _handleResetPassword,
            ),
            const SizedBox(height: AppSpacing.md),
            SecondaryButton(
              label: AuthStrings.backToLogin,
              onPressed: isLoading ? null : () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}
