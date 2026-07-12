import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venture_link/core/constants/admin_strings.dart';
import 'package:venture_link/core/constants/colors.dart';
import 'package:venture_link/core/constants/spacing.dart';
import 'package:venture_link/core/providers/user_context_providers.dart';
import 'package:venture_link/features/admin/presentation/providers/admin_providers.dart';
import 'package:venture_link/shared/widgets/app_card.dart';
import 'package:venture_link/shared/widgets/error_state_widget.dart';
import 'package:venture_link/shared/widgets/loading_indicator.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(isAdminUserProvider);
    final stats = ref.watch(adminStatsProvider);
    final usersAsync = ref.watch(adminUsersStreamProvider);

    if (!isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text(AdminStrings.dashboard)),
        body: const ErrorStateWidget(message: AdminStrings.unauthorized),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AdminStrings.dashboard),
      ),
      body: usersAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorStateWidget(
          message: AdminStrings.loadError,
          onRetry: () => ref.invalidate(adminUsersStreamProvider),
        ),
        data: (_) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Text(
                AdminStrings.dashboard,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                AdminStrings.dashboardSubtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      label: AdminStrings.totalUsers,
                      value: '${stats.totalUsers}',
                      icon: Icons.people_outline_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _StatTile(
                      label: AdminStrings.verifiedStartups,
                      value: '${stats.verifiedStartups}',
                      icon: Icons.verified_outlined,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              _StatTile(
                label: AdminStrings.pendingStartups,
                value: '${stats.pendingStartups}',
                icon: Icons.pending_actions_outlined,
                color: AppColors.accent,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}
