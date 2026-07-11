import 'package:venture_link/core/constants/auth_strings.dart';
import 'package:venture_link/core/constants/application_strings.dart';
import 'package:venture_link/core/constants/startup_strings.dart';
import 'package:venture_link/core/constants/profile_strings.dart';

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

  static String? validateOptionalUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final uri = Uri.tryParse(value.trim());
    if (uri == null || !uri.hasScheme) {
      return ProfileStrings.invalidUrl;
    }
    return null;
  }

  static String? validateDegree(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ProfileStrings.degreeRequired;
    }
    return null;
  }

  static String? validateYear(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ProfileStrings.yearRequired;
    }
    return null;
  }

  static String? validateBio(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    if (value.trim().length < 10) {
      return ProfileStrings.bioTooShort;
    }
    return null;
  }

  static String? validateCoverLetter(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ApplicationStrings.coverLetterRequired;
    }
    if (value.trim().length < 20) {
      return ApplicationStrings.coverLetterTooShort;
    }
    return null;
  }

  static String? validateOpportunityTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return StartupStrings.titleRequired;
    }
    return null;
  }

  static String? validateOpportunityDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return StartupStrings.descriptionRequired;
    }
    if (value.trim().length < 30) {
      return 'Description must be at least 30 characters';
    }
    return null;
  }

  static String? validateOpportunityLocation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return StartupStrings.locationRequired;
    }
    return null;
  }

  static String? validateOpportunityHours(String? value) {
    if (value == null || value.trim().isEmpty) {
      return StartupStrings.hoursRequired;
    }
    return null;
  }
}
