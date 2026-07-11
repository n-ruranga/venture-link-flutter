import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:venture_link/core/constants/colors.dart';
import 'package:venture_link/core/constants/spacing.dart';
import 'package:venture_link/core/constants/startup_strings.dart';
import 'package:venture_link/core/providers/user_context_providers.dart';
import 'package:venture_link/core/routes/route_names.dart';
import 'package:venture_link/features/startup/presentation/providers/startup_providers.dart';
import 'package:venture_link/features/startup/presentation/widgets/startup_opportunity_tile.dart';
import 'package:venture_link/shared/utils/action_result_handler.dart';
import 'package:venture_link/shared/widgets/empty_state_widget.dart';
import 'package:venture_link/shared/widgets/error_state_widget.dart';
import 'package:venture_link/shared/widgets/loading_indicator.dart';

/// Startup tab: manage posted opportunities (distinct from student Explore).
class StartupListingsScreen extends ConsumerWidget {
  const StartupListingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opportunitiesAsync = ref.watch(startupOpportunitiesStreamProvider);
    final opportunities = ref.watch(startupOpportunitiesListProvider);
    final isVerified = ref.watch(isVerifiedStartupProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(StartupStrings.listingsTitle),
        actions: [
          if (isVerified)
            IconButton(
              onPressed: () => context.push(RouteNames.createOpportunity),
              icon: const Icon(Icons.add_rounded),
              tooltip: StartupStrings.createOpportunity,
            ),
        ],
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
        data: (_) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(startupOpportunitiesStreamProvider);
            },
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                Text(
                  StartupStrings.listingsSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                if (!isVerified) ...[
                  const SizedBox(height: AppSpacing.md),
                  const _VerificationBanner(),
                ],
                const SizedBox(height: AppSpacing.lg),
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
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
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
                const SizedBox(height: 80),
              ],
            ),
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
  const _VerificationBanner();

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
