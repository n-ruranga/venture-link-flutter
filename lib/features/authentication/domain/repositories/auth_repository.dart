import 'package:venture_link/features/authentication/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;

  Future<UserEntity?> getCurrentUser();

  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserEntity> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  });

  Future<void> signOut();

  Future<void> sendPasswordResetEmail(String email);

  Future<void> sendEmailVerification();

  Future<UserEntity> reloadUser();
}
