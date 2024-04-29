import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:group_escape/pages/home_page.dart';
import 'package:group_escape/pages/login_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   bool loggedIn = false;
//
//   void _logIn(){
//     loggedIn = true;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'GroupEscape App',
//       home: loggedIn ? HomePage()
//       : LoginScreen(logIn: _logIn),
//     );
//   }
// }



class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'GroupEscape App',
      home: LoginScreen(),
    );
  }
}
