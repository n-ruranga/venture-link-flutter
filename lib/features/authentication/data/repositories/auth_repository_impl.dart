import 'package:venture_link/features/authentication/data/datasources/firebase_auth_datasource.dart';
import 'package:venture_link/features/authentication/data/datasources/firestore_user_datasource.dart';
import 'package:venture_link/features/authentication/data/models/user_model.dart';
import 'package:venture_link/features/authentication/domain/entities/user_entity.dart';
import 'package:venture_link/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.authDatasource,
    required this.firestoreUserDatasource,
  });

  final FirebaseAuthDatasource authDatasource;
  final FirestoreUserDatasource firestoreUserDatasource;

  @override
  Stream<UserEntity?> get authStateChanges {
    return authDatasource.authStateChanges.asyncMap((user) async {
      if (user == null) {
        return null;
      }
      return _resolveUser(UserModel.fromFirebaseUser(user));
    });
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final firebaseUser = authDatasource.getCurrentUserModel();
    if (firebaseUser == null) {
      return null;
    }
    return _resolveUser(firebaseUser);
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
    return await _resolveUser(user) ?? user.toEntity();
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

    final userModel = user.copyWith(
      displayName: displayName.trim(),
      role: 'student',
      createdAt: DateTime.now(),
    );

    await firestoreUserDatasource.createUser(userModel);
    return userModel.toEntity();
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
    if (user.isEmailVerified) {
      await firestoreUserDatasource.updateEmailVerified(user.uid, true);
    }
    return await _resolveUser(user) ?? user.toEntity();
  }

  Future<UserEntity?> _resolveUser(UserModel userModel) async {
    final firestoreUser =
        await firestoreUserDatasource.getUser(userModel.uid);
    final mergedUser = firestoreUser?.copyWith(
          isEmailVerified: userModel.isEmailVerified,
          displayName: firestoreUser.displayName ?? userModel.displayName,
        ) ??
        userModel;

    return mergedUser.toEntity();
  }
}
