// firebase_init.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:single_radio/config/constant.dart';

Future<void> initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDJjLCq6HBCe7xae6l0D9DWpE4900GU",
        appId: "1:728921419683:android:3b93ab123978aeb70db416",
        messagingSenderId: Constant.messagingSenderId, // Hardcode this value
        projectId: "juvofood",
      ),
    );
    debugPrint('Firebase initialized successfully in firebase_init.dart');
  } catch (e) {
    debugPrint('Failed to initialize Firebase: $e');
    rethrow;
  }
}
