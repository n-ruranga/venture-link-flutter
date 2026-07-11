import 'package:venture_link/core/constants/user_roles.dart';
import 'package:venture_link/features/opportunities/domain/repositories/opportunity_repository.dart';
import 'package:venture_link/features/profile/data/datasources/firestore_profile_datasource.dart';
import 'package:venture_link/features/profile/data/models/user_model.dart';
import 'package:venture_link/features/profile/domain/entities/user_profile_entity.dart';
import 'package:venture_link/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({
    required this.datasource,
    required this.opportunityRepository,
  });

  final FirestoreProfileDatasource datasource;
  final OpportunityRepository opportunityRepository;

  @override
  Future<void> createInitialProfile({
    required String uid,
    required String email,
    required String fullName,
    required String role,
  }) async {
    final user = UserModel.initial(
      uid: uid,
      email: email,
      fullName: fullName.trim(),
      role: role,
    );
    await datasource.createProfile(user);
  }

  @override
  Future<UserProfileEntity?> getProfile(String uid) async {
    final profile = await datasource.getProfile(uid);
    return profile?.toEntity();
  }

  @override
  Stream<UserProfileEntity?> watchProfile(String uid) {
    return datasource.watchProfile(uid).map((profile) => profile?.toEntity());
  }

  @override
  Future<UserProfileEntity> updateProfile(UserProfileEntity profile) async {
    final existing = await getProfile(profile.uid);
    final isComplete = UserModel.calculateIsComplete(profile);
    final updatedProfile = profile.copyWith(
      isProfileComplete: isComplete,
      updatedAt: DateTime.now(),
    );
    final model = UserModel.fromEntity(updatedProfile);
    await datasource.updateProfile(model);

    final nameChanged = existing != null &&
        existing.fullName.trim() != updatedProfile.fullName.trim();
    if (nameChanged && updatedProfile.role == UserRoles.startup) {
      await opportunityRepository.syncStartupName(
        startupId: updatedProfile.uid,
        startupName: updatedProfile.fullName.trim(),
      );
    }

    return updatedProfile;
  }

  @override
  Future<void> updateEmailVerified(String uid, bool isVerified) {
    return datasource.updateEmailVerified(uid, isVerified);
  }
}
