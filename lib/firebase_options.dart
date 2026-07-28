// File in `lib/firebase_options.dart`.
// Run `flutterfire configure` to replace this file with your project keys.
//
// Setup:
//   dart pub global activate flutterfire_cli
//   flutterfire configure

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static bool get isConfigured => _apiKey != 'YOUR_API_KEY';

  static const String _apiKey = 'YOUR_API_KEY';
  static const String _appId = 'YOUR_APP_ID';
  static const String _messagingSenderId = 'YOUR_SENDER_ID';
  static const String _projectId = 'YOUR_PROJECT_ID';
  static const String _storageBucket = 'YOUR_PROJECT_ID.appspot.com';

  static FirebaseOptions get currentPlatform {
    if (!isConfigured) {
      throw UnsupportedError(
        'Firebase is not configured yet.\n'
        'Run: dart pub global activate flutterfire_cli\n'
        'Then: flutterfire configure',
      );
    }

    if (kIsWeb) {
      return web;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.windows:
        return windows;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: _apiKey,
    appId: _appId,
    messagingSenderId: _messagingSenderId,
    projectId: _projectId,
    storageBucket: _storageBucket,
    authDomain: '$_projectId.firebaseapp.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: _apiKey,
    appId: _appId,
    messagingSenderId: _messagingSenderId,
    projectId: _projectId,
    storageBucket: _storageBucket,
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: _apiKey,
    appId: _appId,
    messagingSenderId: _messagingSenderId,
    projectId: _projectId,
    storageBucket: _storageBucket,
    iosBundleId: 'com.example.aptitudeTestApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: _apiKey,
    appId: _appId,
    messagingSenderId: _messagingSenderId,
    projectId: _projectId,
    storageBucket: _storageBucket,
  );
}
