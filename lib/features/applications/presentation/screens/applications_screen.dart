import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venture_link/core/constants/application_strings.dart';
import 'package:venture_link/core/constants/colors.dart';
import 'package:venture_link/core/constants/home_strings.dart';
import 'package:venture_link/core/constants/spacing.dart';
import 'package:venture_link/features/applications/domain/entities/application_status.dart';
import 'package:venture_link/features/applications/presentation/providers/application_providers.dart';
import 'package:venture_link/features/applications/presentation/widgets/application_card.dart';
import 'package:venture_link/features/opportunities/presentation/widgets/opportunity_state_widgets.dart';
import 'package:venture_link/features/startup/presentation/providers/startup_providers.dart';
import 'package:venture_link/features/startup/presentation/widgets/startup_applicants_list.dart';
import 'package:venture_link/shared/utils/action_result_handler.dart';
import 'package:venture_link/shared/widgets/empty_state_widget.dart';
import 'package:venture_link/shared/widgets/error_state_widget.dart';
import 'package:venture_link/shared/widgets/loading_indicator.dart';

class ApplicationsScreen extends ConsumerWidget {
  const ApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isStartupUser = ref.watch(isStartupUserProvider);

    return isStartupUser
        ? const _StartupApplicationsView()
        : const _StudentApplicationsView();
  }
}

class _StudentApplicationsView extends ConsumerWidget {
  const _StudentApplicationsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationsAsync = ref.watch(studentApplicationsStreamProvider);
    final applications = ref.watch(enrichedStudentApplicationsProvider);
    final selectedFilter = ref.watch(selectedApplicationStatusFilterProvider);
    final isOffline = ref.watch(isStudentApplicationsOfflineProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(HomeStrings.navApplications),
      ),
      body: applicationsAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorStateWidget(
          message: ApplicationStrings.loadError,
          onRetry: () => ref.invalidate(studentApplicationsStreamProvider),
        ),
        data: (_) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isOffline) const OfflineBanner(),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ApplicationStrings.applications,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      ApplicationStrings.trackProgress,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              _StatusFilterBar(selectedFilter: selectedFilter),
              Expanded(
                child: applications.isEmpty
                    ? EmptyStateWidget(
                        title: selectedFilter == null
                            ? ApplicationStrings.emptyApplications
                            : ApplicationStrings.emptyFiltered,
                        icon: Icons.inbox_outlined,
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        itemCount: applications.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.md),
                        itemBuilder: (context, index) {
                          final application = applications[index];
                          final isWithdrawing = ref
                              .watch(withdrawActionProvider(application.id))
                              .isLoading;

                          return ApplicationCard(
                            application: application,
                            isWithdrawing: isWithdrawing,
                            onWithdraw: application.status.canWithdraw
                                ? () => handleActionResult(
                                      context,
                                      action: () => ref
                                          .read(
                                            withdrawActionProvider(
                                              application.id,
                                            ).notifier,
                                          )
                                          .withdraw(),
                                      successMessage:
                                          ApplicationStrings.withdrawSuccess,
                                    )
                                : null,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StartupApplicationsView extends ConsumerWidget {
  const _StartupApplicationsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationsAsync = ref.watch(startupApplicationsStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(ApplicationStrings.startupApplications),
      ),
      body: applicationsAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorStateWidget(
          message: ApplicationStrings.loadError,
          onRetry: () => ref.invalidate(startupApplicationsStreamProvider),
        ),
        data: (snapshot) {
          return Column(
            children: [
              if (snapshot.isFromCache) const OfflineBanner(),
              const Expanded(child: StartupApplicantsList()),
            ],
          );
        },
      ),
    );
  }
}

class _StatusFilterBar extends ConsumerWidget {
  const _StatusFilterBar({required this.selectedFilter});

  final ApplicationStatus? selectedFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          _FilterChip(
            label: ApplicationStrings.all,
            isSelected: selectedFilter == null,
            onSelected: () {
              ref
                  .read(selectedApplicationStatusFilterProvider.notifier)
                  .state = null;
            },
          ),
          ...ApplicationStatus.values.map(
            (status) => Padding(
              padding: const EdgeInsets.only(left: AppSpacing.sm),
              child: _FilterChip(
                label: status.label,
                isSelected: selectedFilter == status,
                selectedColor: status.backgroundColor,
                labelColor: status.color,
                onSelected: () {
                  ref
                      .read(selectedApplicationStatusFilterProvider.notifier)
                      .state = status;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.selectedColor,
    this.labelColor,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onSelected;
  final Color? selectedColor;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      selected: isSelected,
      button: true,
      child: FilterChip(
        label: Text(
          label,
          style: labelColor != null
              ? TextStyle(color: isSelected ? labelColor : null)
              : null,
        ),
        selected: isSelected,
        selectedColor: selectedColor,
        onSelected: (_) => onSelected(),
      ),
    );
  }
}
