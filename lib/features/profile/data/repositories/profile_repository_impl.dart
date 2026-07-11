import 'package:venture_link/features/profile/data/datasources/firestore_profile_datasource.dart';
import 'package:venture_link/features/profile/data/models/user_model.dart';
import 'package:venture_link/features/profile/domain/entities/user_profile_entity.dart';
import 'package:venture_link/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this.datasource);

  final FirestoreProfileDatasource datasource;

  @override
  Future<void> createInitialProfile({
    required String uid,
    required String email,
    required String fullName,
  }) async {
    final user = UserModel.initial(
      uid: uid,
      email: email,
      fullName: fullName.trim(),
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
    final isComplete = UserModel.calculateIsComplete(profile);
    final updatedProfile = profile.copyWith(
      isProfileComplete: isComplete,
      updatedAt: DateTime.now(),
    );
    final model = UserModel.fromEntity(updatedProfile);
    await datasource.updateProfile(model);
    return updatedProfile;
  }

  @override
  Future<void> updateEmailVerified(String uid, bool isVerified) {
    return datasource.updateEmailVerified(uid, isVerified);
  }
}
