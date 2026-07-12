import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venture_link/core/providers/user_context_providers.dart';
import 'package:venture_link/core/constants/user_roles.dart';

enum AppShellRole { student, startup, admin }

final appShellRoleProvider = Provider<AppShellRole>((ref) {
  final profile = ref.watch(userProfileProvider);
  return switch (profile?.role) {
    UserRoles.admin => AppShellRole.admin,
    UserRoles.startup => AppShellRole.startup,
    _ => AppShellRole.student,
  };
});

/// Renders different shell tab content per role (student, startup, admin).
class RoleBranchScreen extends ConsumerWidget {
  const RoleBranchScreen({
    super.key,
    required this.student,
    required this.startup,
    required this.admin,
  });

  final Widget student;
  final Widget startup;
  final Widget admin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(appShellRoleProvider)) {
      AppShellRole.admin => admin,
      AppShellRole.startup => startup,
      AppShellRole.student => student,
    };
  }
}
