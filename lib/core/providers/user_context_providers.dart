import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venture_link/core/constants/user_roles.dart';
import 'package:venture_link/features/profile/domain/entities/user_profile_entity.dart';
import 'package:venture_link/features/profile/presentation/providers/profile_providers.dart';

/// Shared user-role providers used across features without circular imports.
final userProfileProvider = Provider<UserProfileEntity?>((ref) {
  return ref.watch(userProfileStreamProvider).maybeWhen(
        data: (profile) => profile,
        orElse: () => null,
      );
});

final currentStartupIdProvider = Provider<String?>((ref) {
  final profile = ref.watch(userProfileProvider);
  if (profile?.role != UserRoles.startup) {
    return null;
  }
  return profile!.uid;
});

final isVerifiedStartupProvider = Provider<bool>((ref) {
  final profile = ref.watch(userProfileProvider);
  return profile?.role == UserRoles.startup && (profile?.isVerified ?? false);
});

final isStartupUserProvider = Provider<bool>((ref) {
  final profile = ref.watch(userProfileProvider);
  return profile?.role == UserRoles.startup;
});

final isAdminUserProvider = Provider<bool>((ref) {
  final profile = ref.watch(userProfileProvider);
  return profile?.role == UserRoles.admin;
});
