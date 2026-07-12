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
import 'package:venture_link/features/applications/presentation/screens/applications_screen.dart';
import 'package:venture_link/features/home/presentation/screens/explore_screen.dart';
import 'package:venture_link/features/home/presentation/screens/home_screen.dart';
import 'package:venture_link/features/home/presentation/screens/main_shell.dart';
import 'package:venture_link/features/opportunities/presentation/screens/opportunity_details_screen.dart';
import 'package:venture_link/features/startup/presentation/screens/create_opportunity_screen.dart';
import 'package:venture_link/features/startup/presentation/screens/edit_opportunity_screen.dart';
import 'package:venture_link/features/startup/presentation/screens/startup_applicants_screen.dart';
import 'package:venture_link/features/startup/presentation/screens/startup_dashboard_screen.dart';
import 'package:venture_link/features/startup/presentation/screens/startup_listings_screen.dart';
import 'package:venture_link/features/startup/presentation/screens/startup_profile_screen.dart';
import 'package:venture_link/shared/widgets/role_branch_screen.dart';
import 'package:venture_link/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:venture_link/features/admin/presentation/screens/admin_profile_screen.dart';
import 'package:venture_link/features/admin/presentation/screens/verify_users_screen.dart';
import 'package:venture_link/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:venture_link/features/profile/presentation/screens/profile_screen.dart';
import 'package:venture_link/features/profile/presentation/providers/profile_providers.dart';
import 'package:venture_link/core/constants/user_roles.dart';

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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.home,
                name: 'home',
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: RoleBranchScreen(
                    student: const HomeScreen(),
                    startup: const StartupDashboardScreen(),
                    admin: const AdminDashboardScreen(),
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.search,
                name: 'search',
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: RoleBranchScreen(
                    student: const ExploreScreen(),
                    startup: const StartupListingsScreen(),
                    admin: const VerifyUsersScreen(),
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.applications,
                name: 'applications',
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: RoleBranchScreen(
                    student: const ApplicationsScreen(),
                    startup: const StartupApplicantsScreen(),
                    admin: const ExploreScreen(),
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.profile,
                name: 'profile',
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: RoleBranchScreen(
                    student: const ProfileScreen(),
                    startup: const StartupProfileScreen(),
                    admin: const AdminProfileScreen(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.opportunityDetails,
        name: 'opportunityDetails',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return slideTransitionPage(
            key: state.pageKey,
            child: OpportunityDetailsScreen(opportunityId: id),
          );
        },
      ),
      GoRoute(
        path: RouteNames.editProfile,
        name: 'editProfile',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => slideTransitionPage(
          key: state.pageKey,
          child: const EditProfileScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.startupDashboard,
        name: 'startupDashboard',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => slideTransitionPage(
          key: state.pageKey,
          child: const StartupDashboardScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.createOpportunity,
        name: 'createOpportunity',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => slideTransitionPage(
          key: state.pageKey,
          child: const CreateOpportunityScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.editOpportunity,
        name: 'editOpportunity',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return slideTransitionPage(
            key: state.pageKey,
            child: EditOpportunityScreen(opportunityId: id),
          );
        },
      ),
      GoRoute(
        path: RouteNames.startupApplicants,
        name: 'startupApplicants',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final opportunityId = state.extra as String?;
          return slideTransitionPage(
            key: state.pageKey,
            child: StartupApplicantsScreen(
              initialOpportunityId: opportunityId,
            ),
          );
        },
      ),
      GoRoute(
        path: RouteNames.adminDashboard,
        name: 'adminDashboard',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => slideTransitionPage(
          key: state.pageKey,
          child: const AdminDashboardScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.verifyStartups,
        name: 'verifyStartups',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => slideTransitionPage(
          key: state.pageKey,
          child: const VerifyUsersScreen(),
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
    if (location.startsWith('/admin/')) {
      final profile = ref.read(userProfileStreamProvider).value;
      if (profile?.role != UserRoles.admin) {
        return RouteNames.home;
      }
    }

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

  const authPublicRoutes = {
    RouteNames.login,
    RouteNames.register,
    RouteNames.forgotPassword,
  };

  if (hasCompletedOnboarding && !authPublicRoutes.contains(location)) {
    return RouteNames.login;
  }

  return null;
}
