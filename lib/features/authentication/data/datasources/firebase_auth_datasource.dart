import 'package:firebase_auth/firebase_auth.dart';
import 'package:venture_link/features/authentication/data/models/user_model.dart';

class FirebaseAuthDatasource {
  FirebaseAuthDatasource(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentFirebaseUser => _firebaseAuth.currentUser;

  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw FirebaseAuthException(code: 'user-not-found');
    }
    return UserModel.fromFirebaseUser(user);
  }

  Future<UserModel> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw FirebaseAuthException(code: 'user-not-found');
    }
    await user.updateDisplayName(displayName.trim());
    await user.sendEmailVerification();
    return UserModel.fromFirebaseUser(user).copyWith(
      displayName: displayName.trim(),
    );
  }

  Future<void> signOut() => _firebaseAuth.signOut();

  Future<void> sendPasswordResetEmail(String email) {
    return _firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(code: 'user-not-found');
    }
    await user.sendEmailVerification();
  }

  Future<UserModel> reloadUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(code: 'user-not-found');
    }
    await user.reload();
    final refreshedUser = _firebaseAuth.currentUser;
    if (refreshedUser == null) {
      throw FirebaseAuthException(code: 'user-not-found');
    }
    return UserModel.fromFirebaseUser(refreshedUser);
  }

  UserModel? getCurrentUserModel() {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return null;
    }
    return UserModel.fromFirebaseUser(user);
  }
}
