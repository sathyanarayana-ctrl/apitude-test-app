import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'firebase_bootstrap.dart';

class AuthService extends ChangeNotifier {
  AuthService() {
    if (FirebaseBootstrap.enabled) {
      _auth.authStateChanges().listen((_) => notifyListeners());
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => FirebaseBootstrap.enabled ? _auth.currentUser : null;
  bool get isLoggedIn => currentUser != null;
  bool get isFirebaseReady => FirebaseBootstrap.enabled;
  String get displayName =>
      currentUser?.displayName ?? currentUser?.email ?? 'Guest';

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    if (!FirebaseBootstrap.enabled) {
      return 'Firebase is not configured. Run flutterfire configure first.';
    }

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (error) {
      return error.message ?? 'Sign in failed';
    }
  }

  Future<String?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    if (!FirebaseBootstrap.enabled) {
      return 'Firebase is not configured. Run flutterfire configure first.';
    }

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(name);
      await credential.user?.reload();
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (error) {
      return error.message ?? 'Sign up failed';
    }
  }

  Future<void> signOut() async {
    if (FirebaseBootstrap.enabled) {
      await _auth.signOut();
    }
  }
}
