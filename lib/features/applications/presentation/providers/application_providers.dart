import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venture_link/core/constants/application_strings.dart';
import 'package:venture_link/core/providers/user_context_providers.dart';
import 'package:venture_link/core/utils/async_action_mapper.dart';
import 'package:venture_link/features/applications/domain/entities/application_entity.dart';
import 'package:venture_link/features/applications/domain/entities/application_status.dart';
import 'package:venture_link/features/applications/presentation/providers/application_repository_providers.dart';
import 'package:venture_link/features/opportunities/domain/entities/opportunity_entity.dart';
import 'package:venture_link/features/opportunities/presentation/providers/opportunity_providers.dart';
import 'package:venture_link/features/profile/presentation/providers/profile_providers.dart';

final studentApplicationsStreamProvider =
    StreamProvider<ApplicationsSnapshot>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) {
    return Stream.value(const ApplicationsSnapshot(applications: []));
  }
  return ref.watch(applicationRepositoryProvider).watchStudentApplications(userId);
});

final startupApplicationsStreamProvider =
    StreamProvider<ApplicationsSnapshot>((ref) {
  final startupId = ref.watch(currentStartupIdProvider);
  if (startupId == null) {
    return Stream.value(const ApplicationsSnapshot(applications: []));
  }
  return ref
      .watch(applicationRepositoryProvider)
      .watchStartupApplications(startupId);
});

final studentApplicationForOpportunityProvider =
    StreamProvider.family<ApplicationEntity?, String>((ref, opportunityId) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) {
    return Stream.value(null);
  }
  return ref.watch(applicationRepositoryProvider).watchStudentApplicationForOpportunity(
        studentId: userId,
        opportunityId: opportunityId,
      );
});

final hasAppliedStreamProvider = Provider.family<bool, String>((ref, opportunityId) {
  final application =
      ref.watch(studentApplicationForOpportunityProvider(opportunityId));
  return application.maybeWhen(
    data: (value) => value != null,
    orElse: () => false,
  );
});

final selectedApplicationStatusFilterProvider =
    StateProvider<ApplicationStatus?>((ref) => null);

List<ApplicationEntity> enrichApplicationsWithOpportunities(
  List<ApplicationEntity> applications,
  List<OpportunityEntity> opportunities,
) {
  final opportunityMap = {
    for (final opportunity in opportunities) opportunity.id: opportunity,
  };

  return applications.map((application) {
    final opportunity = opportunityMap[application.opportunityId];
    return application.copyWith(
      opportunityTitle: opportunity?.title ?? application.opportunityTitle,
      startupName: opportunity?.startupName ?? application.startupName,
    );
  }).toList();
}

final enrichedStudentApplicationsProvider =
    Provider<List<ApplicationEntity>>((ref) {
  final snapshot = ref.watch(studentApplicationsStreamProvider);
  final opportunities = ref.watch(opportunitiesListProvider);
  final filter = ref.watch(selectedApplicationStatusFilterProvider);

  return snapshot.maybeWhen(
    data: (data) {
      var applications =
          enrichApplicationsWithOpportunities(data.applications, opportunities);
      if (filter != null) {
        applications =
            applications.where((item) => item.status == filter).toList();
      }
      return applications;
    },
    orElse: () => const [],
  );
});

final enrichedStartupApplicationsProvider =
    Provider<List<ApplicationEntity>>((ref) {
  final snapshot = ref.watch(startupApplicationsStreamProvider);
  final opportunities = ref.watch(opportunitiesListProvider);

  return snapshot.maybeWhen(
    data: (data) =>
        enrichApplicationsWithOpportunities(data.applications, opportunities),
    orElse: () => const [],
  );
});

final isStudentApplicationsOfflineProvider = Provider<bool>((ref) {
  return ref.watch(studentApplicationsStreamProvider).maybeWhen(
        data: (data) => data.isFromCache,
        orElse: () => false,
      );
});

final applyActionProvider =
    AsyncNotifierProvider.family<ApplyActionNotifier, void, String>(
  ApplyActionNotifier.new,
);

class ApplyActionNotifier extends FamilyAsyncNotifier<void, String> {
  @override
  Future<void> build(String arg) async {}

  Future<String?> submit({
    required String startupId,
    required String coverLetter,
    String? resumeUrl,
  }) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) {
      return ApplicationStrings.loadError;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(applicationRepositoryProvider).apply(
            studentId: userId,
            opportunityId: arg,
            startupId: startupId,
            coverLetter: coverLetter,
            resumeUrl: resumeUrl,
          );
    });

    return mapAsyncActionError(state);
  }
}

final withdrawActionProvider =
    AsyncNotifierProvider.family<WithdrawActionNotifier, void, String>(
  WithdrawActionNotifier.new,
);

class WithdrawActionNotifier extends FamilyAsyncNotifier<void, String> {
  @override
  Future<void> build(String arg) async {}

  Future<String?> withdraw() async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) {
      return ApplicationStrings.withdrawError;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(applicationRepositoryProvider).withdraw(
            applicationId: arg,
            studentId: userId,
          );
    });

    return mapAsyncActionError(state);
  }
}

final updateApplicationStatusProvider =
    AsyncNotifierProvider.family<UpdateApplicationStatusNotifier, void, String>(
  UpdateApplicationStatusNotifier.new,
);

class UpdateApplicationStatusNotifier extends FamilyAsyncNotifier<void, String> {
  @override
  Future<void> build(String arg) async {}

  Future<String?> updateStatus(ApplicationStatus status) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(applicationRepositoryProvider).updateStatus(
            applicationId: arg,
            status: status,
          );
    });

    return mapAsyncActionError(state);
  }
}
