import 'package:venture_link/features/admin/data/datasources/firestore_admin_datasource.dart';
import 'package:venture_link/features/admin/domain/repositories/admin_repository.dart';
import 'package:venture_link/features/profile/domain/entities/user_profile_entity.dart';

class AdminRepositoryImpl implements AdminRepository {
  AdminRepositoryImpl(this.datasource);

  final FirestoreAdminDatasource datasource;

  @override
  Stream<List<UserProfileEntity>> watchUsers() {
    return datasource.watchUsers().map(
          (users) => users.map((user) => user.toEntity()).toList(),
        );
  }

  @override
  Future<void> updateUserVerification({
    required String uid,
    required bool isVerified,
  }) {
    return datasource.updateUserVerification(
      uid: uid,
      isVerified: isVerified,
    );
  }

  @override
  Future<void> updateUserRole({
    required String uid,
    required String role,
  }) {
    return datasource.updateUserRole(uid: uid, role: role);
  }
}
