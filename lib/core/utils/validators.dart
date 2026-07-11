import 'package:venture_link/core/constants/auth_strings.dart';

abstract final class Validators {
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final RegExp _uppercaseRegex = RegExp(r'[A-Z]');
  static final RegExp _lowercaseRegex = RegExp(r'[a-z]');
  static final RegExp _numberRegex = RegExp(r'[0-9]');

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AuthStrings.emailRequired;
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return AuthStrings.emailInvalid;
    }
    return null;
  }

  static String? validatePasswordRequired(String? value) {
    if (value == null || value.isEmpty) {
      return AuthStrings.passwordRequired;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AuthStrings.passwordRequired;
    }
    if (value.length < 8) {
      return AuthStrings.passwordMinLength;
    }
    if (!_uppercaseRegex.hasMatch(value)) {
      return AuthStrings.passwordUppercase;
    }
    if (!_lowercaseRegex.hasMatch(value)) {
      return AuthStrings.passwordLowercase;
    }
    if (!_numberRegex.hasMatch(value)) {
      return AuthStrings.passwordNumber;
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return AuthStrings.confirmPasswordRequired;
    }
    if (value != password) {
      return AuthStrings.passwordsDoNotMatch;
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AuthStrings.nameRequired;
    }
    if (value.trim().length < 2) {
      return AuthStrings.nameTooShort;
    }
    return null;
  }
}
