import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:venture_link/core/services/local_storage_service.dart';
import 'package:venture_link/features/authentication/data/datasources/firebase_auth_datasource.dart';
import 'package:venture_link/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:venture_link/features/authentication/domain/entities/user_entity.dart';
import 'package:venture_link/features/authentication/domain/repositories/auth_repository.dart';
import 'package:venture_link/features/authentication/presentation/providers/auth_state.dart';
import 'package:venture_link/features/profile/presentation/providers/profile_repository_providers.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'SharedPreferences must be overridden in main.dart',
  );
});

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService(ref.watch(sharedPreferencesProvider));
});

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final firebaseAuthDatasourceProvider = Provider<FirebaseAuthDatasource>((ref) {
  return FirebaseAuthDatasource(ref.watch(firebaseAuthProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    authDatasource: ref.watch(firebaseAuthDatasourceProvider),
    profileRepository: ref.watch(profileRepositoryProvider),
  );
});

final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

final loginActionProvider =
    AsyncNotifierProvider<LoginActionNotifier, void>(LoginActionNotifier.new);

final registerActionProvider =
    AsyncNotifierProvider<RegisterActionNotifier, void>(
      RegisterActionNotifier.new,
    );

final forgotPasswordActionProvider =
    AsyncNotifierProvider<ForgotPasswordActionNotifier, void>(
      ForgotPasswordActionNotifier.new,
    );

final emailVerificationActionProvider =
    AsyncNotifierProvider<EmailVerificationActionNotifier, void>(
      EmailVerificationActionNotifier.new,
    );

final onboardingStatusProvider =
    AsyncNotifierProvider<OnboardingStatusNotifier, bool>(
      OnboardingStatusNotifier.new,
    );

final rememberedEmailProvider =
    AsyncNotifierProvider<RememberedEmailNotifier, RememberedEmailState>(
      RememberedEmailNotifier.new,
    );

class RememberedEmailState {
  const RememberedEmailState({
    this.rememberMe = false,
    this.email,
  });

  final bool rememberMe;
  final String? email;
}

class AuthNotifier extends AsyncNotifier<AuthState> {
  StreamSubscription<UserEntity?>? _subscription;

  @override
  Future<AuthState> build() async {
    ref.onDispose(() => _subscription?.cancel());

    final repository = ref.read(authRepositoryProvider);
    _subscription = repository.authStateChanges.listen((user) {
      state = AsyncData(_mapUserToState(user));
    });

    final user = await repository.getCurrentUser();
    return _mapUserToState(user);
  }

  AuthState _mapUserToState(UserEntity? user) {
    if (user == null) {
      return const AuthState.unauthenticated();
    }
    if (!user.isEmailVerified) {
      return AuthState.emailNotVerified(user);
    }
    return AuthState.authenticated(user);
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
  }

  Future<void> refreshUser() async {
    final user = await ref.read(authRepositoryProvider).getCurrentUser();
    state = AsyncData(_mapUserToState(user));
  }
}

class LoginActionNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> signIn({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signInWithEmailAndPassword(
            email: email,
            password: password,
          );

      final storage = ref.read(localStorageServiceProvider);
      await storage.setRememberMe(rememberMe);
      if (rememberMe) {
        await storage.setRememberedEmail(email.trim());
      } else {
        await storage.setRememberedEmail(null);
      }
      ref.invalidate(rememberedEmailProvider);
    });
  }
}

class RegisterActionNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> register({
    required String displayName,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).registerWithEmailAndPassword(
            email: email,
            password: password,
            displayName: displayName,
          );
    });
  }
}

class ForgotPasswordActionNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> sendResetEmail(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).sendPasswordResetEmail(email);
    });
  }
}

class EmailVerificationActionNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> resendVerification() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).sendEmailVerification();
    });
  }

  Future<bool> checkVerification() async {
    state = const AsyncLoading();
    late UserEntity user;

    state = await AsyncValue.guard(() async {
      user = await ref.read(authRepositoryProvider).reloadUser();
    });

    if (state.hasError) {
      return false;
    }

    if (user.isEmailVerified) {
      await ref.read(authNotifierProvider.notifier).refreshUser();
    }

    return user.isEmailVerified;
  }
}

class OnboardingStatusNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final storage = ref.read(localStorageServiceProvider);
    return storage.hasCompletedOnboarding();
  }

  Future<void> completeOnboarding() async {
    final storage = ref.read(localStorageServiceProvider);
    await storage.setOnboardingComplete(true);
    state = const AsyncData(true);
  }
}

class RememberedEmailNotifier extends AsyncNotifier<RememberedEmailState> {
  @override
  Future<RememberedEmailState> build() async {
    final storage = ref.read(localStorageServiceProvider);
    final rememberMe = await storage.getRememberMe();
    final email = rememberMe ? await storage.getRememberedEmail() : null;
    return RememberedEmailState(rememberMe: rememberMe, email: email);
  }
}
