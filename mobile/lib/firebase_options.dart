import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

/// Firebase options generated from the Android app registered in project
/// `dinnar-wise`. Run `flutterfire configure` again when adding another
/// platform; do not hand-copy Android credentials to iOS or web.
class DefaultFirebaseOptions {
  const DefaultFirebaseOptions._();

  static FirebaseOptions get currentPlatform {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return android;
    }
    throw UnsupportedError(
      'Firebase is currently configured for Android only.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCzGlRC2FpGwzTUHvEJnp6P1kzWVcMMGqs',
    appId: '1:509992270139:android:56312d911ef3acfaf19f1e',
    messagingSenderId: '509992270139',
    projectId: 'dinnar-wise',
    storageBucket: 'dinnar-wise.firebasestorage.app',
  );
}
