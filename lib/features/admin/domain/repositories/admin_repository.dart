import 'package:venture_link/features/profile/domain/entities/user_profile_entity.dart';

abstract class AdminRepository {
  Stream<List<UserProfileEntity>> watchUsers();

  Future<void> updateUserVerification({
    required String uid,
    required bool isVerified,
  });

  Future<void> updateUserRole({
    required String uid,
    required String role,
  });
}
