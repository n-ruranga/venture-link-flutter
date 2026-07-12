import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:venture_link/core/constants/admin_strings.dart';
import 'package:venture_link/core/constants/colors.dart';
import 'package:venture_link/core/constants/profile_strings.dart';
import 'package:venture_link/core/constants/spacing.dart';
import 'package:venture_link/core/constants/strings.dart';
import 'package:venture_link/core/constants/user_roles.dart';
import 'package:venture_link/core/routes/route_names.dart';
import 'package:venture_link/features/admin/presentation/providers/admin_providers.dart';
import 'package:venture_link/features/profile/domain/entities/user_profile_entity.dart';
import 'package:venture_link/features/profile/presentation/providers/profile_providers.dart';
import 'package:venture_link/features/profile/presentation/widgets/profile_widgets.dart';
import 'package:venture_link/shared/widgets/app_card.dart';
import 'package:venture_link/shared/widgets/empty_state_widget.dart';
import 'package:venture_link/shared/widgets/error_state_widget.dart';
import 'package:venture_link/shared/widgets/loading_indicator.dart';
import 'package:venture_link/shared/widgets/primary_button.dart';
import 'package:venture_link/shared/widgets/sign_out_button.dart';

/// Admin-focused account screen — distinct from student/startup profiles.
class AdminProfileScreen extends ConsumerWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileStreamProvider);
    final stats = ref.watch(adminStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AdminStrings.adminAccount),
        actions: [
          profileAsync.maybeWhen(
            data: (profile) => profile != null
                ? IconButton(
                    onPressed: () => context.push(RouteNames.editProfile),
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: ProfileStrings.editProfile,
                  )
                : null,
            orElse: () => null,
          ) ??
              const SizedBox.shrink(),
        ],
      ),
      body: profileAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorStateWidget(
          message: AppStrings.genericError,
          onRetry: () => ref.invalidate(userProfileStreamProvider),
        ),
        data: (profile) {
          if (profile == null) {
            return const EmptyStateWidget(
              title: AdminStrings.adminAccount,
              message: 'Admin profile not found.',
              icon: Icons.admin_panel_settings_outlined,
            );
          }

          return _AdminProfileBody(profile: profile, stats: stats);
        },
      ),
    );
  }
}

class _AdminProfileBody extends StatelessWidget {
  const _AdminProfileBody({
    required this.profile,
    required this.stats,
  });

  final UserProfileEntity profile;
  final AdminStats stats;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: 0.75),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      child: const Icon(
                        Icons.admin_panel_settings_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.fullName,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            profile.email,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    UserRoles.admin.toUpperCase(),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.6,
                        ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  AdminStrings.adminAccountSubtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  label: AdminStrings.totalUsers,
                  value: '${stats.totalUsers}',
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _MetricCard(
                  label: AdminStrings.pendingStartups,
                  value: '${stats.pendingStartups}',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: ProfileInfoSection(
              title: ProfileStrings.about,
              child: Text(
                profile.bio ?? AdminStrings.dashboardSubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: profile.bio == null
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                      height: 1.5,
                    ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: ProfileStrings.editProfile,
            icon: Icons.edit_outlined,
            onPressed: () => context.push(RouteNames.editProfile),
          ),
          const SizedBox(height: AppSpacing.md),
          const SignOutButton(),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
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
