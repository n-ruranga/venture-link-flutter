import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venture_link/core/providers/user_context_providers.dart';

/// Renders different shell tab content for students vs startups.
class RoleBranchScreen extends ConsumerWidget {
  const RoleBranchScreen({
    super.key,
    required this.student,
    required this.startup,
  });

  final Widget student;
  final Widget startup;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isStartup = ref.watch(isStartupUserProvider);
    return isStartup ? startup : student;
  }
}
