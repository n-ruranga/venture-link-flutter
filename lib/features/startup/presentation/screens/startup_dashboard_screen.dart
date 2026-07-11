import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:venture_link/core/constants/colors.dart';
import 'package:venture_link/core/constants/spacing.dart';
import 'package:venture_link/core/constants/startup_strings.dart';
import 'package:venture_link/core/utils/responsive_layout.dart';
import 'package:venture_link/core/routes/route_names.dart';
import 'package:venture_link/features/opportunities/presentation/widgets/opportunity_state_widgets.dart';
import 'package:venture_link/features/applications/presentation/providers/application_providers.dart';
import 'package:venture_link/features/startup/presentation/providers/startup_providers.dart';
import 'package:venture_link/features/startup/presentation/widgets/dashboard_stat_card.dart';
import 'package:venture_link/features/startup/presentation/widgets/startup_opportunity_tile.dart';
import 'package:venture_link/shared/utils/action_result_handler.dart';
import 'package:venture_link/shared/widgets/empty_state_widget.dart';
import 'package:venture_link/shared/widgets/error_state_widget.dart';
import 'package:venture_link/shared/widgets/loading_indicator.dart';

class StartupDashboardScreen extends ConsumerWidget {
  const StartupDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opportunitiesAsync = ref.watch(startupOpportunitiesStreamProvider);
    final stats = ref.watch(startupDashboardStatsProvider);
    final isVerified = ref.watch(isVerifiedStartupProvider);
    final opportunities = ref.watch(startupOpportunitiesListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(StartupStrings.dashboard),
      ),
      floatingActionButton: isVerified
          ? FloatingActionButton.extended(
              onPressed: () => context.push(RouteNames.createOpportunity),
              icon: const Icon(Icons.add_rounded),
              label: const Text(StartupStrings.createOpportunity),
            )
          : null,
      body: opportunitiesAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorStateWidget(
          message: StartupStrings.loadError,
          onRetry: () => ref.invalidate(startupOpportunitiesStreamProvider),
        ),
        data: (snapshot) {
          return Column(
            children: [
              if (snapshot.isFromCache) const OfflineBanner(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(startupOpportunitiesStreamProvider);
                    ref.invalidate(startupApplicationsStreamProvider);
                  },
                  child: ListView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    children: [
                      Text(
                        StartupStrings.dashboard,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        StartupStrings.dashboardSubtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      if (!isVerified) ...[
                        const SizedBox(height: AppSpacing.md),
                        _VerificationBanner(),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final crossAxisCount =
                              ResponsiveLayout.gridCrossAxisCount(context);
                          return GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: AppSpacing.md,
                            mainAxisSpacing: AppSpacing.md,
                            childAspectRatio: crossAxisCount > 2 ? 1.8 : 1.6,
                            children: [
                            DashboardStatCard(
                              label: StartupStrings.activeOpportunities,
                              value: '${stats.activeOpportunities}',
                              icon: Icons.work_outline_rounded,
                              color: AppColors.primary,
                            ),
                            DashboardStatCard(
                              label: StartupStrings.totalApplicants,
                              value: '${stats.totalApplicants}',
                              icon: Icons.people_outline_rounded,
                              color: AppColors.accent,
                              onTap: () =>
                                  context.push(RouteNames.startupApplicants),
                            ),
                            DashboardStatCard(
                              label: StartupStrings.acceptedStudents,
                              value: '${stats.acceptedStudents}',
                              icon: Icons.check_circle_outline_rounded,
                              color: AppColors.success,
                            ),
                            DashboardStatCard(
                              label: StartupStrings.rejectedStudents,
                              value: '${stats.rejectedStudents}',
                              icon: Icons.cancel_outlined,
                              color: AppColors.error,
                            ),
                          ],
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              StartupStrings.myOpportunities,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                context.push(RouteNames.startupApplicants),
                            child: const Text(StartupStrings.viewApplicants),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      if (opportunities.isEmpty)
                        const EmptyStateWidget(
                          title: StartupStrings.emptyOpportunities,
                          icon: Icons.work_outline_rounded,
                        )
                      else
                        ...opportunities.map((opportunity) {
                          final deleteState = ref.watch(
                            deleteOpportunityActionProvider(opportunity.id),
                          );

                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.md,
                            ),
                            child: StartupOpportunityTile(
                              opportunity: opportunity,
                              isDeleting: deleteState.isLoading,
                              onDelete: () => _confirmDelete(
                                context,
                                ref,
                                opportunity.id,
                                opportunity.title,
                              ),
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String opportunityId,
    String title,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(StartupStrings.deleteOpportunity),
        content: Text('${StartupStrings.deleteConfirm}\n\n$title'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(StartupStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(StartupStrings.delete),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    await handleActionResult(
      context,
      action: () => ref
          .read(deleteOpportunityActionProvider(opportunityId).notifier)
          .delete(),
      successMessage: StartupStrings.deleteSuccess,
    );
  }
}

class _VerificationBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            StartupStrings.verificationRequired,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.accent,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            StartupStrings.notVerifiedHint,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
