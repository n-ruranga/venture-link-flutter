import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venture_link/core/constants/auth_strings.dart';
import 'package:venture_link/core/constants/colors.dart';
import 'package:venture_link/core/constants/spacing.dart';
import 'package:venture_link/core/utils/firebase_auth_exception_mapper.dart';
import 'package:venture_link/features/authentication/presentation/providers/auth_providers.dart';
import 'package:venture_link/shared/extensions/context_extensions.dart';
import 'package:venture_link/shared/widgets/primary_button.dart';
import 'package:venture_link/shared/widgets/secondary_button.dart';

class EmailVerificationScreen extends ConsumerWidget {
  const EmailVerificationScreen({super.key});

  Future<void> _resendEmail(WidgetRef ref, BuildContext context) async {
    await ref.read(emailVerificationActionProvider.notifier).resendVerification();

    if (!context.mounted) {
      return;
    }

    final state = ref.read(emailVerificationActionProvider);
    if (state.hasError) {
      context.showSnackBar(
        FirebaseAuthExceptionMapper.mapGeneric(state.error!),
        isError: true,
      );
      return;
    }

    context.showSnackBar(AuthStrings.verificationSent);
  }

  Future<void> _checkVerification(WidgetRef ref, BuildContext context) async {
    final isVerified = await ref
        .read(emailVerificationActionProvider.notifier)
        .checkVerification();

    if (!context.mounted) {
      return;
    }

    final state = ref.read(emailVerificationActionProvider);
    if (state.hasError) {
      context.showSnackBar(
        FirebaseAuthExceptionMapper.mapGeneric(state.error!),
        isError: true,
      );
      return;
    }

    if (isVerified) {
      context.showSnackBar(AuthStrings.emailVerified);
    } else {
      context.showSnackBar(AuthStrings.emailNotVerifiedYet, isError: true);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider).value;
    final verificationState = ref.watch(emailVerificationActionProvider);
    final isLoading = verificationState.isLoading;
    final email = authState?.user?.email ?? '';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_unread_outlined,
                  size: 48,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                AuthStrings.verifyEmail,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                AuthStrings.verifyEmailSubtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                textAlign: TextAlign.center,
              ),
              if (email.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    email,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
              const Spacer(),
              PrimaryButton(
                label: AuthStrings.checkVerification,
                isLoading: isLoading,
                onPressed: isLoading
                    ? null
                    : () => _checkVerification(ref, context),
              ),
              const SizedBox(height: AppSpacing.md),
              SecondaryButton(
                label: AuthStrings.resendEmail,
                onPressed: isLoading ? null : () => _resendEmail(ref, context),
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: isLoading
                    ? null
                    : () => ref.read(authNotifierProvider.notifier).signOut(),
                child: const Text(AuthStrings.logout),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
