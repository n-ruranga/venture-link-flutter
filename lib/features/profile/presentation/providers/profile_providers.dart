import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venture_link/features/authentication/presentation/providers/auth_providers.dart';
import 'package:venture_link/features/profile/domain/entities/user_profile_entity.dart';
import 'package:venture_link/features/profile/presentation/providers/profile_repository_providers.dart';

final currentUserIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(authNotifierProvider).value;
  if (authState == null) {
    return null;
  }
  return authState.user?.uid;
});

final userProfileStreamProvider =
    StreamProvider.autoDispose<UserProfileEntity?>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) {
    return Stream.value(null);
  }
  return ref.watch(profileRepositoryProvider).watchProfile(uid);
});

final updateProfileActionProvider =
    AsyncNotifierProvider<UpdateProfileNotifier, void>(
  UpdateProfileNotifier.new,
);

class UpdateProfileNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> updateProfile(UserProfileEntity profile) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(profileRepositoryProvider).updateProfile(profile);
    });
  }
}
