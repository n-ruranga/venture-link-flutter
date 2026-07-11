import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:venture_link/core/constants/admin_strings.dart';
import 'package:venture_link/core/constants/colors.dart';
import 'package:venture_link/core/constants/profile_strings.dart';
import 'package:venture_link/core/constants/spacing.dart';
import 'package:venture_link/core/constants/startup_strings.dart';
import 'package:venture_link/core/constants/strings.dart';
import 'package:venture_link/core/providers/user_context_providers.dart';
import 'package:venture_link/core/routes/route_names.dart';
import 'package:venture_link/features/profile/domain/entities/user_profile_entity.dart';
import 'package:venture_link/features/profile/presentation/providers/profile_providers.dart';
import 'package:venture_link/features/profile/presentation/widgets/profile_widgets.dart';
import 'package:venture_link/features/startup/domain/entities/startup_dashboard_stats.dart';
import 'package:venture_link/features/startup/presentation/providers/startup_providers.dart';
import 'package:venture_link/shared/widgets/app_card.dart';
import 'package:venture_link/shared/widgets/empty_state_widget.dart';
import 'package:venture_link/shared/widgets/error_state_widget.dart';
import 'package:venture_link/shared/widgets/loading_indicator.dart';
import 'package:venture_link/shared/widgets/primary_button.dart';

/// Startup-focused company profile — distinct from the student profile layout.
class StartupProfileScreen extends ConsumerWidget {
  const StartupProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileStreamProvider);
    final stats = ref.watch(startupDashboardStatsProvider);
    final isAdmin = ref.watch(isAdminUserProvider);
    final isVerified = ref.watch(isVerifiedStartupProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(StartupStrings.companyProfile),
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
              title: StartupStrings.companyProfile,
              message: 'Company profile not found.',
              icon: Icons.apartment_outlined,
            );
          }

          return _StartupProfileBody(
            profile: profile,
            stats: stats,
            isAdmin: isAdmin,
            isVerified: isVerified,
          );
        },
      ),
    );
  }
}

class _StartupProfileBody extends StatelessWidget {
  const _StartupProfileBody({
    required this.profile,
    required this.stats,
    required this.isAdmin,
    required this.isVerified,
  });

  final UserProfileEntity profile;
  final StartupDashboardStats stats;
  final bool isAdmin;
  final bool isVerified;

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
                  AppColors.accent.withValues(alpha: 0.85),
                  AppColors.secondary,
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
                      child: Text(
                        _initials(profile.fullName),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
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
                    isVerified
                        ? 'Verified ALU Startup'
                        : 'Pending ALU Verification',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
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
                  label: StartupStrings.activeOpportunities,
                  value: '${stats.activeOpportunities}',
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _MetricCard(
                  label: StartupStrings.totalApplicants,
                  value: '${stats.totalApplicants}',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (!isVerified)
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StartupStrings.verificationRequired,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.accent,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    StartupStrings.notVerifiedHint,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
          if (!isVerified) const SizedBox(height: AppSpacing.md),
          AppCard(
            child: ProfileInfoSection(
              title: ProfileStrings.about,
              child: Text(
                profile.bio ?? StartupStrings.companyProfileSubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: profile.bio == null
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                      height: 1.5,
                    ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: ProfileInfoSection(
              title: ProfileStrings.portfolioLinks,
              child: Column(
                children: [
                  ProfileInfoRow(
                    icon: Icons.language_rounded,
                    label: ProfileStrings.portfolio,
                    value: profile.portfolio ?? ProfileStrings.notSet,
                  ),
                  ProfileInfoRow(
                    icon: Icons.link_rounded,
                    label: ProfileStrings.linkedin,
                    value: profile.linkedin ?? ProfileStrings.notSet,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (isAdmin) ...[
            PrimaryButton(
              label: AdminStrings.dashboard,
              icon: Icons.admin_panel_settings_outlined,
              onPressed: () => context.push(RouteNames.adminDashboard),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          PrimaryButton(
            label: ProfileStrings.editProfile,
            icon: Icons.edit_outlined,
            onPressed: () => context.push(RouteNames.editProfile),
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
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
                  color: AppColors.accent,
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
