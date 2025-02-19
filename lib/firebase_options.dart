// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyCioF2ZCE_LDg6Od0zLe5_BzJ6P-9yxiTA',
    appId: '1:1095079858429:web:beac90f4cd381b527bae94',
    messagingSenderId: '1095079858429',
    projectId: 'tokyo-memory',
    authDomain: 'tokyo-memory.firebaseapp.com',
    storageBucket: 'tokyo-memory.appspot.com',
    measurementId: 'G-DB3W8675VL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCXOzz_XgmI11yChmeHR0oEo0B6h1Fs0iA',
    appId: '1:1095079858429:android:8a79e4330748d0e87bae94',
    messagingSenderId: '1095079858429',
    projectId: 'tokyo-memory',
    storageBucket: 'tokyo-memory.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCUGyy5H6DOnQNVRU4pJsodsSzVANum4u8',
    appId: '1:1095079858429:ios:779b6ca4f66ac4337bae94',
    messagingSenderId: '1095079858429',
    projectId: 'tokyo-memory',
    storageBucket: 'tokyo-memory.appspot.com',
    iosBundleId: 'com.tokyomemory.mapapp0918',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCUGyy5H6DOnQNVRU4pJsodsSzVANum4u8',
    appId: '1:1095079858429:ios:7dbdcd2276460a3b7bae94',
    messagingSenderId: '1095079858429',
    projectId: 'tokyo-memory',
    storageBucket: 'tokyo-memory.appspot.com',
    iosBundleId: 'com.example.mapapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCioF2ZCE_LDg6Od0zLe5_BzJ6P-9yxiTA',
    appId: '1:1095079858429:web:96a5237ec9992cf67bae94',
    messagingSenderId: '1095079858429',
    projectId: 'tokyo-memory',
    authDomain: 'tokyo-memory.firebaseapp.com',
    storageBucket: 'tokyo-memory.appspot.com',
    measurementId: 'G-W25S1XT03S',
  );
}
