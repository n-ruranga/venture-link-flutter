import 'package:firebase_core/firebase_core.dart';
import 'package:venture_link/core/utils/logger.dart';
import 'package:venture_link/firebase_options.dart';

Future<void> initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    AppLogger.debug('Firebase initialized successfully');
  } catch (e, stackTrace) {
    AppLogger.debug('Firebase initialization failed', e, stackTrace);
    rethrow;
  }
}
