import 'package:firebase_auth/firebase_auth.dart';
import 'package:venture_link/features/authentication/data/datasources/firebase_auth_datasource.dart';
import 'package:venture_link/features/authentication/domain/entities/user_entity.dart';
import 'package:venture_link/features/authentication/domain/repositories/auth_repository.dart';
import 'package:venture_link/features/profile/domain/repositories/profile_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.authDatasource,
    required this.profileRepository,
  });

  final FirebaseAuthDatasource authDatasource;
  final ProfileRepository profileRepository;

  @override
  Stream<UserEntity?> get authStateChanges {
    return authDatasource.authStateChanges.asyncMap(_resolveUser);
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = authDatasource.currentFirebaseUser;
    if (user == null) {
      return null;
    }
    return _resolveUser(user);
  }

  @override
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final user = await authDatasource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return await _resolveUser(user) ?? _fallbackEntity(user);
  }

  @override
  Future<UserEntity> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final user = await authDatasource.createUserWithEmailAndPassword(
      email: email,
      password: password,
      displayName: displayName,
    );

    await profileRepository.createInitialProfile(
      uid: user.uid,
      email: user.email ?? email.trim(),
      fullName: displayName.trim(),
    );

    return await _resolveUser(user) ?? _fallbackEntity(user);
  }

  @override
  Future<void> signOut() => authDatasource.signOut();

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return authDatasource.sendPasswordResetEmail(email);
  }

  @override
  Future<void> sendEmailVerification() {
    return authDatasource.sendEmailVerification();
  }

  @override
  Future<UserEntity> reloadUser() async {
    final user = await authDatasource.reloadUser();
    if (user.emailVerified) {
      await profileRepository.updateEmailVerified(user.uid, true);
    }
    return await _resolveUser(user) ?? _fallbackEntity(user);
  }

  Future<UserEntity?> _resolveUser(User? user) async {
    if (user == null) {
      return null;
    }

    var profile = await profileRepository.getProfile(user.uid);

    if (profile == null) {
      await profileRepository.createInitialProfile(
        uid: user.uid,
        email: user.email ?? '',
        fullName: user.displayName ??
            user.email?.split('@').first ??
            'User',
      );
      profile = await profileRepository.getProfile(user.uid);
    }

    if (profile == null) {
      return _fallbackEntity(user);
    }

    return UserEntity(
      uid: profile.uid,
      email: profile.email,
      displayName: profile.fullName,
      isEmailVerified: user.emailVerified,
      role: profile.role,
      skills: profile.skills,
      createdAt: profile.createdAt,
    );
  }

  UserEntity _fallbackEntity(User user) {
    return UserEntity(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      isEmailVerified: user.emailVerified,
    );
  }
}
