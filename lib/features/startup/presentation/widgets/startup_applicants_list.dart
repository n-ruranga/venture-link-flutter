import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venture_link/core/constants/application_strings.dart';
import 'package:venture_link/core/constants/colors.dart';
import 'package:venture_link/core/constants/spacing.dart';
import 'package:venture_link/core/constants/startup_strings.dart';
import 'package:venture_link/features/applications/domain/entities/application_status.dart';
import 'package:venture_link/features/applications/presentation/providers/application_providers.dart';
import 'package:venture_link/features/applications/presentation/widgets/application_card.dart';
import 'package:venture_link/features/startup/presentation/providers/startup_providers.dart';
import 'package:venture_link/shared/extensions/context_extensions.dart';

class StartupApplicantsList extends ConsumerWidget {
  const StartupApplicantsList({
    super.key,
    this.initialOpportunityId,
  });

  final String? initialOpportunityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applications = ref.watch(filteredStartupApplicantsProvider);
    final opportunities = ref.watch(startupOpportunitiesListProvider);
    final selectedFilter = ref.watch(selectedApplicantOpportunityFilterProvider);
    final updatingId = ref.watch(updatingApplicationIdProvider);
    final updateState = ref.watch(updateApplicationStatusProvider);

    if (initialOpportunityId != null && selectedFilter == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(selectedApplicantOpportunityFilterProvider.notifier).state =
            initialOpportunityId;
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (opportunities.length > 1)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: DropdownButtonFormField<String?>(
              initialValue: selectedFilter,
              decoration: const InputDecoration(
                labelText: StartupStrings.filterByOpportunity,
              ),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text(StartupStrings.allOpportunities),
                ),
                ...opportunities.map(
                  (opportunity) => DropdownMenuItem<String?>(
                    value: opportunity.id,
                    child: Text(opportunity.title),
                  ),
                ),
              ],
              onChanged: (value) {
                ref
                    .read(selectedApplicantOpportunityFilterProvider.notifier)
                    .state = value;
              },
            ),
          ),
        Expanded(
          child: applications.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Text(
                      ApplicationStrings.emptyStartupApplications,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: applications.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final application = applications[index];
                    final isUpdating = updateState.isLoading &&
                        updatingId == application.id;

                    return ApplicationCard(
                      application: application,
                      showStartupActions: true,
                      isUpdatingStatus: isUpdating,
                      onStatusChanged: (status) => _updateStatus(
                        context,
                        ref,
                        application.id,
                        status,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Future<void> _updateStatus(
    BuildContext context,
    WidgetRef ref,
    String applicationId,
    ApplicationStatus status,
  ) async {
    ref.read(updatingApplicationIdProvider.notifier).state = applicationId;

    final error = await ref
        .read(updateApplicationStatusProvider.notifier)
        .updateStatus(
          applicationId: applicationId,
          status: status,
        );

    ref.read(updatingApplicationIdProvider.notifier).state = null;

    if (!context.mounted) {
      return;
    }

    if (error != null) {
      context.showSnackBar(error, isError: true);
      return;
    }

    context.showSnackBar(ApplicationStrings.statusUpdated);
  }
}
