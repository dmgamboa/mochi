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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBcWyZNMJ8CM619x5iu2xktIAkvGQd0MzM',
    appId: '1:699417011577:web:b72daa9d09ad02fc22bba8',
    messagingSenderId: '699417011577',
    projectId: 'mochi-c4c75',
    authDomain: 'mochi-c4c75.firebaseapp.com',
    storageBucket: 'mochi-c4c75.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC0d4WX6QFlt9k51gwfQE7kXQIW8-qzLig',
    appId: '1:699417011577:android:360d20675a4b93ad22bba8',
    messagingSenderId: '699417011577',
    projectId: 'mochi-c4c75',
    storageBucket: 'mochi-c4c75.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAJYF85OiCfnBZwr4wvFS-2xO_K24ix6F0',
    appId: '1:699417011577:ios:f0145b845e35ae4222bba8',
    messagingSenderId: '699417011577',
    projectId: 'mochi-c4c75',
    storageBucket: 'mochi-c4c75.appspot.com',
    iosClientId: '699417011577-ae4d6ulcd4heeaa70vqm8m5ufi20omb4.apps.googleusercontent.com',
    iosBundleId: 'BCIT.mochi',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAJYF85OiCfnBZwr4wvFS-2xO_K24ix6F0',
    appId: '1:699417011577:ios:f0145b845e35ae4222bba8',
    messagingSenderId: '699417011577',
    projectId: 'mochi-c4c75',
    storageBucket: 'mochi-c4c75.appspot.com',
    iosClientId: '699417011577-ae4d6ulcd4heeaa70vqm8m5ufi20omb4.apps.googleusercontent.com',
    iosBundleId: 'BCIT.mochi',
  );
}
