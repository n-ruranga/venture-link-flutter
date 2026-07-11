import 'package:shared_preferences/shared_preferences.dart';
import 'package:venture_link/core/constants/storage_keys.dart';

class LocalStorageService {
  LocalStorageService(this._prefs);

  final SharedPreferences _prefs;

  Future<bool> hasCompletedOnboarding() async {
    return _prefs.getBool(StorageKeys.onboardingComplete) ?? false;
  }

  Future<void> setOnboardingComplete(bool value) async {
    await _prefs.setBool(StorageKeys.onboardingComplete, value);
  }

  Future<bool> getRememberMe() async {
    return _prefs.getBool(StorageKeys.rememberMe) ?? false;
  }

  Future<void> setRememberMe(bool value) async {
    await _prefs.setBool(StorageKeys.rememberMe, value);
  }

  Future<String?> getRememberedEmail() async {
    return _prefs.getString(StorageKeys.rememberedEmail);
  }

  Future<void> setRememberedEmail(String? email) async {
    if (email == null) {
      await _prefs.remove(StorageKeys.rememberedEmail);
      return;
    }
    await _prefs.setString(StorageKeys.rememberedEmail, email);
  }
}
