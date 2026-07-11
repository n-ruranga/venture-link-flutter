import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venture_link/core/constants/user_roles.dart';
import 'package:venture_link/core/utils/async_action_mapper.dart';
import 'package:venture_link/features/admin/presentation/providers/admin_repository_providers.dart';
import 'package:venture_link/features/profile/domain/entities/user_profile_entity.dart';

enum AdminUserFilter {
  all,
  startups,
  pending,
  students,
}

final adminUsersStreamProvider =
    StreamProvider.autoDispose<List<UserProfileEntity>>((ref) {
  return ref.watch(adminRepositoryProvider).watchUsers();
});

final adminUserFilterProvider =
    StateProvider.autoDispose<AdminUserFilter>((ref) => AdminUserFilter.all);

final filteredAdminUsersProvider =
    Provider.autoDispose<List<UserProfileEntity>>((ref) {
  final users = ref.watch(adminUsersStreamProvider).value ?? [];
  final filter = ref.watch(adminUserFilterProvider);

  return switch (filter) {
    AdminUserFilter.all => users,
    AdminUserFilter.startups =>
      users.where((user) => user.role == UserRoles.startup).toList(),
    AdminUserFilter.pending => users
        .where(
          (user) => user.role == UserRoles.startup && !user.isVerified,
        )
        .toList(),
    AdminUserFilter.students =>
      users.where((user) => user.role == UserRoles.student).toList(),
  };
});

final adminStatsProvider = Provider.autoDispose<AdminStats>((ref) {
  final users = ref.watch(adminUsersStreamProvider).value ?? [];
  final startups =
      users.where((user) => user.role == UserRoles.startup).toList();

  return AdminStats(
    totalUsers: users.length,
    verifiedStartups: startups.where((user) => user.isVerified).length,
    pendingStartups: startups.where((user) => !user.isVerified).length,
  );
});

class AdminStats {
  const AdminStats({
    required this.totalUsers,
    required this.verifiedStartups,
    required this.pendingStartups,
  });

  final int totalUsers;
  final int verifiedStartups;
  final int pendingStartups;
}

final updateUserVerificationActionProvider = AsyncNotifierProvider.autoDispose
    .family<UpdateUserVerificationNotifier, void, String>(
  UpdateUserVerificationNotifier.new,
);

class UpdateUserVerificationNotifier
    extends AutoDisposeFamilyAsyncNotifier<void, String> {
  @override
  Future<void> build(String arg) async {}

  Future<String?> updateVerification(bool isVerified) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(adminRepositoryProvider).updateUserVerification(
            uid: arg,
            isVerified: isVerified,
          );
    });
    return mapAsyncActionError(state);
  }
}

final updateUserRoleActionProvider = AsyncNotifierProvider.autoDispose
    .family<UpdateUserRoleNotifier, void, String>(
  UpdateUserRoleNotifier.new,
);

class UpdateUserRoleNotifier extends AutoDisposeFamilyAsyncNotifier<void, String> {
  @override
  Future<void> build(String arg) async {}

  Future<String?> updateRole(String role) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(adminRepositoryProvider).updateUserRole(
            uid: arg,
            role: role,
          );
    });
    return mapAsyncActionError(state);
  }
}
