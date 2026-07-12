import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:venture_link/core/constants/auth_strings.dart';
import 'package:venture_link/core/constants/colors.dart';
import 'package:venture_link/core/routes/route_names.dart';
import 'package:venture_link/features/authentication/presentation/providers/auth_providers.dart';
import 'package:venture_link/shared/widgets/secondary_button.dart';

Future<bool> confirmSignOut(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(AuthStrings.logoutConfirmTitle),
      content: const Text(AuthStrings.logoutConfirmMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(AuthStrings.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text(AuthStrings.logout),
        ),
      ],
    ),
  ).then((value) => value ?? false);
}

Future<void> performSignOut(BuildContext context, WidgetRef ref) async {
  await ref.read(authNotifierProvider.notifier).signOut();
  if (!context.mounted) {
    return;
  }
  context.go(RouteNames.login);
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text(AuthStrings.logoutSuccess)),
  );
}

/// Full-width sign-out button for profile and settings screens.
class SignOutButton extends ConsumerWidget {
  const SignOutButton({super.key});

  Future<void> _onPressed(BuildContext context, WidgetRef ref) async {
    final confirmed = await confirmSignOut(context);
    if (!confirmed || !context.mounted) {
      return;
    }
    await performSignOut(context, ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SecondaryButton(
      label: AuthStrings.logout,
      icon: Icons.logout_rounded,
      onPressed: () => _onPressed(context, ref),
    );
  }
}

/// Compact sign-out control for app bars (admin screens, etc.).
class SignOutIconButton extends ConsumerWidget {
  const SignOutIconButton({super.key});

  Future<void> _onPressed(BuildContext context, WidgetRef ref) async {
    final confirmed = await confirmSignOut(context);
    if (!confirmed || !context.mounted) {
      return;
    }
    await performSignOut(context, ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () => _onPressed(context, ref),
      icon: const Icon(Icons.logout_rounded),
      tooltip: AuthStrings.logout,
      color: AppColors.textSecondary,
    );
  }
}
