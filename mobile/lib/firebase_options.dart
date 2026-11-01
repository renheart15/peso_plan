// This file is a placeholder for firebase_options.dart
// Run: flutterfire configure
// to generate the real options file after setting up Firebase project.
//
// For now, a stub is provided so the project compiles.
// Replace this file before release.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static final bool isConfigured = !_hasPlaceholderValues();

  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform.',
        );
    }
  }

  static bool _hasPlaceholderValues() {
    return _isPlaceholder(android.apiKey) ||
        _isPlaceholder(android.appId) ||
        _isPlaceholder(android.messagingSenderId) ||
        _isPlaceholder(ios.apiKey) ||
        _isPlaceholder(ios.appId) ||
        _isPlaceholder(ios.messagingSenderId);
  }

  static bool _isPlaceholder(String value) {
    final normalized = value.trim();
    return normalized.isEmpty ||
        normalized.startsWith('PLACEHOLDER') ||
        normalized.startsWith('000000000000') ||
        normalized == 'example';
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAc8QC4JVCJeTLb7p1j-GH0KF_ZN6D2TlI',
    appId: '1:147223169958:android:66ee5037a9c866aaa19d67',
    messagingSenderId: '147223169958',
    projectId: 'peso-plan',
    storageBucket: 'peso-plan.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDaF0UeK7nM23wVIK5ZDIMV4RpW8weZ5Ew',
    appId: '1:147223169958:ios:4289fd4845544b8ea19d67',
    messagingSenderId: '147223169958',
    projectId: 'peso-plan',
    storageBucket: 'peso-plan.firebasestorage.app',
    iosBundleId: 'com.pesoplan.app',
  );
}
