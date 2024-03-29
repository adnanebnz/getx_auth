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
    apiKey: 'AIzaSyAbt6o5AVZFQ7tmc7sge1zenPdEPOt1KAQ',
    appId: '1:657051586188:web:11b1922f13cee4d6c0b5a9',
    messagingSenderId: '657051586188',
    projectId: 'fluttertodo-8aa29',
    authDomain: 'fluttertodo-8aa29.firebaseapp.com',
    storageBucket: 'fluttertodo-8aa29.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCjvmJB_4CAipMU4ywMNlC1VH8WMZIHwTQ',
    appId: '1:657051586188:android:47440183a03037afc0b5a9',
    messagingSenderId: '657051586188',
    projectId: 'fluttertodo-8aa29',
    storageBucket: 'fluttertodo-8aa29.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDe7kfUKCxLcUZQx9eSN4nnK2iJS9SR8UQ',
    appId: '1:657051586188:ios:e695a004660d0d74c0b5a9',
    messagingSenderId: '657051586188',
    projectId: 'fluttertodo-8aa29',
    storageBucket: 'fluttertodo-8aa29.appspot.com',
    iosBundleId: 'com.example.flutterFirebaseApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDe7kfUKCxLcUZQx9eSN4nnK2iJS9SR8UQ',
    appId: '1:657051586188:ios:ca8b323b9286e276c0b5a9',
    messagingSenderId: '657051586188',
    projectId: 'fluttertodo-8aa29',
    storageBucket: 'fluttertodo-8aa29.appspot.com',
    iosBundleId: 'com.example.flutterFirebaseApp.RunnerTests',
  );
}
