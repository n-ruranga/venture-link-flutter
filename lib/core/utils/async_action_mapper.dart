import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venture_link/core/utils/firebase_auth_exception_mapper.dart';

/// Maps async notifier failures to user-facing messages.
String? mapAsyncActionError(AsyncValue<void> state) {
  if (!state.hasError) {
    return null;
  }

  final error = state.error!;
  if (error is StateError) {
    return error.message;
  }
  return FirebaseAuthExceptionMapper.mapGeneric(error);
}
