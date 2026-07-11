import 'package:flutter/foundation.dart';

abstract final class AppLogger {
  static void debug(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('[VentureLink] $message');
      if (error != null) {
        debugPrint('[VentureLink] Error: $error');
      }
      if (stackTrace != null) {
        debugPrint('[VentureLink] StackTrace: $stackTrace');
      }
    }
  }
}
