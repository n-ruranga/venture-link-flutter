import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venture_link/core/constants/startup_strings.dart';
import 'package:venture_link/core/constants/user_roles.dart';
import 'package:venture_link/core/providers/user_context_providers.dart';
import 'package:venture_link/core/utils/async_action_mapper.dart';
import 'package:venture_link/features/applications/domain/entities/application_entity.dart';
import 'package:venture_link/features/applications/domain/entities/application_status.dart';
import 'package:venture_link/features/applications/presentation/providers/application_providers.dart';
import 'package:venture_link/features/opportunities/domain/entities/opportunity_entity.dart';
import 'package:venture_link/features/opportunities/presentation/providers/opportunity_repository_providers.dart';
import 'package:venture_link/features/startup/domain/entities/opportunity_input.dart';
import 'package:venture_link/features/startup/domain/entities/startup_dashboard_stats.dart';

export 'package:venture_link/core/providers/user_context_providers.dart'
    show currentStartupIdProvider, isStartupUserProvider, isVerifiedStartupProvider;

final startupOpportunitiesStreamProvider =
    StreamProvider<OpportunitiesSnapshot>((ref) {
  final startupId = ref.watch(currentStartupIdProvider);
  if (startupId == null) {
    return Stream.value(const OpportunitiesSnapshot(opportunities: []));
  }
  return ref
      .watch(opportunityRepositoryProvider)
      .watchStartupOpportunities(startupId);
});

final startupOpportunitiesListProvider = Provider<List<OpportunityEntity>>((ref) {
  return ref.watch(startupOpportunitiesStreamProvider).maybeWhen(
        data: (snapshot) => snapshot.opportunities,
        orElse: () => const [],
      );
});

final startupDashboardStatsProvider = Provider<StartupDashboardStats>((ref) {
  final opportunities = ref.watch(startupOpportunitiesListProvider);
  final applications = ref.watch(startupApplicationsStreamProvider).maybeWhen(
        data: (snapshot) => snapshot.applications,
        orElse: () => const <ApplicationEntity>[],
      );

  return StartupDashboardStats(
    activeOpportunities: opportunities.where((item) => item.isActive).length,
    totalApplicants: applications.length,
    acceptedStudents: applications
        .where((item) => item.status == ApplicationStatus.accepted)
        .length,
    rejectedStudents: applications
        .where((item) => item.status == ApplicationStatus.rejected)
        .length,
  );
});

final selectedApplicantOpportunityFilterProvider =
    StateProvider<String?>((ref) => null);

final filteredStartupApplicantsProvider =
    Provider<List<ApplicationEntity>>((ref) {
  final applications = ref.watch(enrichedStartupApplicationsProvider);
  final opportunityFilter =
      ref.watch(selectedApplicantOpportunityFilterProvider);

  if (opportunityFilter == null) {
    return applications;
  }

  return applications
      .where((item) => item.opportunityId == opportunityFilter)
      .toList();
});

final createOpportunityActionProvider =
    AsyncNotifierProvider<CreateOpportunityNotifier, void>(
  CreateOpportunityNotifier.new,
);

class CreateOpportunityNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> submit(OpportunityInput input) async {
    final profile = ref.read(userProfileProvider);
    if (profile == null || profile.role != UserRoles.startup) {
      return StartupStrings.unauthorized;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(opportunityRepositoryProvider).createOpportunity(
            startupId: profile.uid,
            startupName: profile.fullName,
            startupIsVerified: profile.isVerified,
            input: input,
          );
    });

    return mapAsyncActionError(state);
  }
}

final updateOpportunityActionProvider =
    AsyncNotifierProvider.family<UpdateOpportunityNotifier, void, String>(
  UpdateOpportunityNotifier.new,
);

class UpdateOpportunityNotifier extends FamilyAsyncNotifier<void, String> {
  @override
  Future<void> build(String arg) async {}

  Future<String?> submit(OpportunityInput input) async {
    final startupId = ref.read(currentStartupIdProvider);
    if (startupId == null) {
      return StartupStrings.unauthorized;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(opportunityRepositoryProvider).updateOpportunity(
            opportunityId: arg,
            startupId: startupId,
            input: input,
          );
    });

    return mapAsyncActionError(state);
  }
}

final deleteOpportunityActionProvider =
    AsyncNotifierProvider.family<DeleteOpportunityNotifier, void, String>(
  DeleteOpportunityNotifier.new,
);

class DeleteOpportunityNotifier extends FamilyAsyncNotifier<void, String> {
  @override
  Future<void> build(String arg) async {}

  Future<String?> delete() async {
    final startupId = ref.read(currentStartupIdProvider);
    if (startupId == null) {
      return StartupStrings.unauthorized;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(opportunityRepositoryProvider).deleteOpportunity(
            opportunityId: arg,
            startupId: startupId,
          );
    });

    return mapAsyncActionError(state);
  }
}
