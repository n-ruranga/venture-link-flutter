import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:venture_link/core/routes/page_transitions.dart';
import 'package:venture_link/core/routes/route_names.dart';
import 'package:venture_link/features/authentication/presentation/providers/auth_providers.dart';
import 'package:venture_link/features/authentication/presentation/providers/auth_state.dart';
import 'package:venture_link/features/authentication/presentation/screens/email_verification_screen.dart';
import 'package:venture_link/features/authentication/presentation/screens/forgot_password_screen.dart';
import 'package:venture_link/features/authentication/presentation/screens/login_screen.dart';
import 'package:venture_link/features/authentication/presentation/screens/onboarding_screen.dart';
import 'package:venture_link/features/authentication/presentation/screens/register_screen.dart';
import 'package:venture_link/features/authentication/presentation/screens/splash_screen.dart';
import 'package:venture_link/features/home/presentation/screens/home_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = ValueNotifier<int>(0);

  ref.listen(authNotifierProvider, (_, _) {
    refreshNotifier.value++;
  });
  ref.listen(onboardingStatusProvider, (_, _) {
    refreshNotifier.value++;
  });

  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: true,
    refreshListenable: refreshNotifier,
    redirect: (context, state) => _redirect(ref, state),
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        pageBuilder: (context, state) => fadeTransitionPage(
          key: state.pageKey,
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        name: 'onboarding',
        pageBuilder: (context, state) => slideTransitionPage(
          key: state.pageKey,
          child: const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        pageBuilder: (context, state) => slideTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.register,
        name: 'register',
        pageBuilder: (context, state) => slideTransitionPage(
          key: state.pageKey,
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        name: 'forgotPassword',
        pageBuilder: (context, state) => slideTransitionPage(
          key: state.pageKey,
          child: const ForgotPasswordScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.emailVerification,
        name: 'emailVerification',
        pageBuilder: (context, state) => slideTransitionPage(
          key: state.pageKey,
          child: const EmailVerificationScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.home,
        name: 'home',
        pageBuilder: (context, state) => fadeTransitionPage(
          key: state.pageKey,
          child: const HomeScreen(),
        ),
      ),
    ],
  );
});

String? _redirect(Ref ref, GoRouterState state) {
  final authAsync = ref.read(authNotifierProvider);
  final onboardingAsync = ref.read(onboardingStatusProvider);
  final location = state.matchedLocation;

  if (authAsync.isLoading || onboardingAsync.isLoading) {
    return location == RouteNames.splash ? null : RouteNames.splash;
  }

  final authState = authAsync.value ?? const AuthState.initial();
  final hasCompletedOnboarding = onboardingAsync.value ?? false;

  const publicRoutes = {
    RouteNames.splash,
    RouteNames.onboarding,
    RouteNames.login,
    RouteNames.register,
    RouteNames.forgotPassword,
  };

  if (authState.isAuthenticated) {
    if (publicRoutes.contains(location) ||
        location == RouteNames.emailVerification) {
      return RouteNames.home;
    }
    return null;
  }

  if (authState.isEmailNotVerified) {
    if (location != RouteNames.emailVerification) {
      return RouteNames.emailVerification;
    }
    return null;
  }

  if (!hasCompletedOnboarding && location != RouteNames.onboarding) {
    return RouteNames.onboarding;
  }

  if (hasCompletedOnboarding &&
      !publicRoutes.contains(location) &&
      location != RouteNames.emailVerification) {
    return RouteNames.login;
  }

  return null;
}
