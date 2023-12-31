// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAGi1EX3a8ZLCN4PWIXAx5-u49RYtt-_qU',
    appId: '1:1039530961439:android:fa41eb48c9cb24a1d8832a',
    messagingSenderId: '1039530961439',
    projectId: 'flutter-bioskop-58bb6',
    storageBucket: 'flutter-bioskop-58bb6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBMNh7Ba9HQ1s8-9cJr6mpAO_auR9NInKQ',
    appId: '1:1039530961439:ios:8937ea1efb9e7c74d8832a',
    messagingSenderId: '1039530961439',
    projectId: 'flutter-bioskop-58bb6',
    storageBucket: 'flutter-bioskop-58bb6.appspot.com',
    iosClientId: '1039530961439-4voincm82rgk9he81e645qnp5ic0fhpt.apps.googleusercontent.com',
    iosBundleId: 'com.example.bioskop',
  );
}
