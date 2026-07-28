import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../firebase_options.dart';

class FirebaseBootstrap {
  static bool enabled = false;

  static Future<void> init() async {
    if (!DefaultFirebaseOptions.isConfigured) {
      debugPrint('Firebase: offline mode (run flutterfire configure to enable)');
      enabled = false;
      return;
    }

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      enabled = true;
      debugPrint('Firebase: connected');
    } catch (error) {
      enabled = false;
      debugPrint('Firebase init failed: $error');
    }
  }
}
