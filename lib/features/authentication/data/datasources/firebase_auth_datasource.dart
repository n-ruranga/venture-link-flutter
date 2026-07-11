import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthDatasource {
  FirebaseAuthDatasource(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentFirebaseUser => _firebaseAuth.currentUser;

  Future<User> signInWithEmailAndPassword({
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
    return user;
  }

  Future<User> createUserWithEmailAndPassword({
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
    return user;
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

  Future<User> reloadUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(code: 'user-not-found');
    }
    await user.reload();
    final refreshedUser = _firebaseAuth.currentUser;
    if (refreshedUser == null) {
      throw FirebaseAuthException(code: 'user-not-found');
    }
    return refreshedUser;
  }
}
