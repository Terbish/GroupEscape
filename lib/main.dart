import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:group_escape/pages/home_page.dart';
import 'package:group_escape/pages/login_screen.dart';
import 'package:group_escape/services/push_notifications.dart';
import 'package:group_escape/shared/firebase_authentication.dart';
import 'firebase_options.dart';

Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null){
    print("Message received");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  PushNotifications.init();
  String? token = await FirebaseMessaging.instance.getToken();
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);
  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  String? token;
  MyApp({super.key, required this.token});
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'GroupEscape App',
      theme: ThemeData(
        primaryColor: Colors.blue,
        primarySwatch: Colors.blue,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.blue,
          selectionColor: Colors.blue,
          selectionHandleColor: Colors.blue,
        )
      ),
      home: FirebaseAuth.instance.currentUser!=null
        ? LoginScreen(FirebaseAuthentication(FirebaseAuth.instance, FirebaseFirestore.instance), true ) :
      LoginScreen(FirebaseAuthentication(FirebaseAuth.instance, FirebaseFirestore.instance), false)
    );
  }
}
