import 'package:venture_link/features/profile/domain/entities/user_profile_entity.dart';

abstract class ProfileRepository {
  Future<void> createInitialProfile({
    required String uid,
    required String email,
    required String fullName,
  });

  Future<UserProfileEntity?> getProfile(String uid);

  Stream<UserProfileEntity?> watchProfile(String uid);

  Future<UserProfileEntity> updateProfile(UserProfileEntity profile);

  Future<void> updateEmailVerified(String uid, bool isVerified);
}
