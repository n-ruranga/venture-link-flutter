import 'package:firebase_auth/firebase_auth.dart';
import 'package:venture_link/core/constants/auth_strings.dart';
import 'package:venture_link/core/constants/strings.dart';

abstract final class FirebaseAuthExceptionMapper {
  static String map(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return AuthStrings.emailInvalid;
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'user-not-found':
        return 'No account found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return AuthStrings.passwordMinLength;
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return AppStrings.networkError;
      case 'invalid-credential':
        return 'Invalid credentials. Please check your email and password.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      default:
        return exception.message ?? AppStrings.genericError;
    }
  }

  static String mapGeneric(Object error) {
    if (error is FirebaseAuthException) {
      return map(error);
    }
    if (error is FirebaseException && error.code == 'permission-denied') {
      return AuthStrings.firestorePermissionDenied;
    }
    return AppStrings.genericError;
  }
}
