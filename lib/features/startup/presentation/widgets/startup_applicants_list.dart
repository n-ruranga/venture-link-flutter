import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venture_link/core/constants/application_strings.dart';
import 'package:venture_link/core/constants/spacing.dart';
import 'package:venture_link/core/constants/startup_strings.dart';
import 'package:venture_link/features/applications/presentation/providers/application_providers.dart';
import 'package:venture_link/features/applications/presentation/widgets/application_card.dart';
import 'package:venture_link/features/startup/presentation/providers/startup_providers.dart';
import 'package:venture_link/shared/utils/action_result_handler.dart';
import 'package:venture_link/shared/widgets/empty_state_widget.dart';

class StartupApplicantsList extends ConsumerWidget {
  const StartupApplicantsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applications = ref.watch(filteredStartupApplicantsProvider);
    final opportunities = ref.watch(startupOpportunitiesListProvider);
    final selectedFilter = ref.watch(selectedApplicantOpportunityFilterProvider);

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
              ? const EmptyStateWidget(
                  title: ApplicationStrings.emptyStartupApplications,
                  icon: Icons.people_outline_rounded,
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: applications.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final application = applications[index];
                    final isUpdating = ref
                        .watch(updateApplicationStatusProvider(application.id))
                        .isLoading;

                    return ApplicationCard(
                      application: application,
                      showStartupActions: true,
                      isUpdatingStatus: isUpdating,
                      onStatusChanged: (status) => handleActionResult(
                        context,
                        action: () => ref
                            .read(
                              updateApplicationStatusProvider(application.id)
                                  .notifier,
                            )
                            .updateStatus(status),
                        successMessage: ApplicationStrings.statusUpdated,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
