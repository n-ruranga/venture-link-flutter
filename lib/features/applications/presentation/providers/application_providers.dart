import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venture_link/core/constants/application_strings.dart';
import 'package:venture_link/core/constants/user_roles.dart';
import 'package:venture_link/core/utils/firebase_auth_exception_mapper.dart';
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

final selectedStartupIdProvider = StateProvider<String?>((ref) => null);

final withdrawingApplicationIdProvider = StateProvider<String?>((ref) => null);

final updatingApplicationIdProvider = StateProvider<String?>((ref) => null);

final availableStartupIdsProvider = Provider<List<String>>((ref) {
  final opportunities = ref.watch(opportunitiesListProvider);
  return opportunities.map((item) => item.startupId).toSet().toList()..sort();
});

final effectiveStartupIdProvider = Provider<String?>((ref) {
  final selected = ref.watch(selectedStartupIdProvider);
  if (selected != null) {
    return selected;
  }
  final ids = ref.watch(availableStartupIdsProvider);
  return ids.isEmpty ? null : ids.first;
});

final startupApplicationsStreamProvider =
    StreamProvider<ApplicationsSnapshot>((ref) {
  final startupId = ref.watch(effectiveStartupIdProvider);
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

List<ApplicationEntity> _enrichApplications(
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
          _enrichApplications(data.applications, opportunities);
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
    data: (data) => _enrichApplications(data.applications, opportunities),
    orElse: () => const [],
  );
});

final isStudentApplicationsOfflineProvider = Provider<bool>((ref) {
  return ref.watch(studentApplicationsStreamProvider).maybeWhen(
        data: (data) => data.isFromCache,
        orElse: () => false,
      );
});

final isStartupUserProvider = Provider<bool>((ref) {
  final profile = ref.watch(userProfileStreamProvider).value;
  return profile?.role == UserRoles.startup;
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

    if (state.hasError) {
      final error = state.error!;
      if (error is StateError) {
        return error.message;
      }
      return FirebaseAuthExceptionMapper.mapGeneric(error);
    }

    return null;
  }
}

final withdrawActionProvider =
    AsyncNotifierProvider<WithdrawActionNotifier, void>(
  WithdrawActionNotifier.new,
);

class WithdrawActionNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> withdraw(String applicationId) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) {
      return ApplicationStrings.withdrawError;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(applicationRepositoryProvider).withdraw(
            applicationId: applicationId,
            studentId: userId,
          );
    });

    if (state.hasError) {
      final error = state.error!;
      if (error is StateError) {
        return error.message;
      }
      return FirebaseAuthExceptionMapper.mapGeneric(error);
    }

    return null;
  }
}

final updateApplicationStatusProvider =
    AsyncNotifierProvider<UpdateApplicationStatusNotifier, void>(
  UpdateApplicationStatusNotifier.new,
);

class UpdateApplicationStatusNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> updateStatus({
    required String applicationId,
    required ApplicationStatus status,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(applicationRepositoryProvider).updateStatus(
            applicationId: applicationId,
            status: status,
          );
    });

    if (state.hasError) {
      return FirebaseAuthExceptionMapper.mapGeneric(state.error!);
    }

    return null;
  }
}
