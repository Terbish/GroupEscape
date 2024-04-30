import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:group_escape/pages/home_page.dart';
import '../shared/firebase_authentication.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loggedIn = false;

  late FirebaseAuthentication auth;
  String _message = '';
  bool _isLogin = true;
  final TextEditingController txtUserName = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  @override
  void initState() {
    Firebase.initializeApp().whenComplete(() {
      auth = FirebaseAuthentication();
      setState(() {});
    });
    super.initState();
  }

  void _logOut() {
    auth.logout().then((value) {
      if (value) {
        setState(() {
          _message = 'User Logged Out';
          loggedIn = false;
        });
      } else {
        _message = 'Unable to Log Out';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return loggedIn
        ? HomePage(logOut: _logOut)
        : Scaffold(
            appBar: AppBar(
              title: const Text(
                  'Chat Escape',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
              backgroundColor: Colors.blue,
            ),
            body: Form(
              key: _formKey,
              child:Container(
              padding: EdgeInsets.all(36),
              child: ListView(
                children: [
                  userInput(),
                  passwordInput(),
                  btnMain(),
                  btnSecondary(),
                  txtMessage(),
                ],
              ),
            )));
  }

  Widget userInput() {
    return Padding(
        padding: EdgeInsets.only(top: 128),
        child: TextFormField(
          controller: txtUserName,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              hintText: 'Email', icon: Icon(Icons.verified_user)),
          // validator: (text) => text.isEmpty ? 'User Name is required'
          //     : '',
          validator: (text) => text!.isEmpty ? 'Email is required' : null,
        ));
  }

  Widget passwordInput() {
    return Padding(
        padding: EdgeInsets.only(top: 24),
        child: TextFormField(
          controller: txtPassword,
          keyboardType: TextInputType.emailAddress,
          obscureText: true,
          decoration: InputDecoration(
              hintText: 'password', icon: Icon(Icons.enhanced_encryption)),
          // validator: (text) => text.isEmpty ? 'Password is required'
          //     : '',
          validator: (text) => text!.isEmpty ? 'Password is required' : null,
        ));
  }

  Widget btnMain() {
    String btnText = _isLogin ? 'Log in' : 'Sign up';
    return Padding(
        padding: EdgeInsets.only(top: 128),
        child: Container(
            height: 60,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).primaryColorLight),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      side: BorderSide(color: Colors.black)),
                ),
              ),
              child: Text(btnText,
                  style: const TextStyle(fontSize: 18, color: Colors.black)),
              onPressed: () {
                if(_formKey.currentState?.validate() ?? false) {
                  if (_isLogin) {
                    auth
                        .login(txtUserName.text, txtPassword.text)
                        .then((value) async {
                      if (value == null) {
                        setState(() {
                          _message = 'Login Error';
                        });
                      } else {
                        final userId = value;
                        setState(() {
                          _message = 'User $userId successfully logged in';
                          loggedIn = true;
                        });
                      }
                    });
                  } else {
                    auth
                        .createUser(txtUserName.text, txtPassword.text)
                        .then((value) async {
                      if (value == null) {
                        setState(() {
                          _message = 'Registration Error';
                        });
                      } else {
                        final userId = value;
                        final userDoc = FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId);
                        await userDoc.set({
                          'email': txtUserName.text,
                          'name': txtUserName.text.split('@')[0],
                        });
                        setState(() {
                          _message = 'User $userId successfully signed in';
                          loggedIn = true;
                        });
                      }
                    });
                  }
                }
              },
            )));
  }

  Widget btnSecondary() {
    String buttonText = _isLogin ? 'Sign up' : 'Log In';
    return TextButton(
      child: Text(buttonText),
      onPressed: () {
        setState(() {
          _isLogin = !_isLogin;
        });
      },
    );
  }

  Widget txtMessage() {
    return Text(
      _message,
      style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).primaryColorDark,
          fontWeight: FontWeight.bold),
    );
  }
}
