import 'package:flutter/material.dart';
import 'package:venture_link/shared/extensions/context_extensions.dart';

/// Runs an async action and shows snackbar feedback on success or failure.
Future<void> handleActionResult(
  BuildContext context, {
  required Future<String?> Function() action,
  required String successMessage,
  VoidCallback? onSuccess,
}) async {
  final error = await action();

  if (!context.mounted) {
    return;
  }

  if (error != null) {
    context.showSnackBar(error, isError: true);
    return;
  }

  context.showSnackBar(successMessage);
  onSuccess?.call();
}
