import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venture_link/core/constants/auth_strings.dart';
import 'package:venture_link/core/constants/colors.dart';
import 'package:venture_link/core/constants/spacing.dart';
import 'package:venture_link/core/constants/strings.dart';
import 'package:venture_link/features/authentication/presentation/providers/auth_providers.dart';
import 'package:venture_link/shared/extensions/context_extensions.dart';
import 'package:venture_link/shared/widgets/loading_indicator.dart';
import 'package:venture_link/shared/widgets/primary_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _handleLogout(WidgetRef ref, BuildContext context) async {
    await ref.read(authNotifierProvider.notifier).signOut();
    if (context.mounted) {
      context.showSnackBar(AuthStrings.logoutSuccess);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            onPressed: authAsync.isLoading
                ? null
                : () => _handleLogout(ref, context),
            icon: const Icon(Icons.logout_rounded),
            tooltip: AuthStrings.logout,
          ),
        ],
      ),
      body: authAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (authState) {
          if (!authState.isAuthenticated) {
            return const LoadingIndicator();
          }

          final user = authState.user!;
          final displayName = user.displayName ?? user.email.split('@').first;

          return Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, $displayName!',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        user.email,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'You are signed in',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Opportunity features coming in the next phase.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const Spacer(),
                PrimaryButton(
                  label: AuthStrings.logout,
                  icon: Icons.logout_rounded,
                  onPressed: () => _handleLogout(ref, context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
