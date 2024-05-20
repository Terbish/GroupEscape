import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:group_escape/pages/home_page.dart';
import '../shared/firebase_authentication.dart';

class LoginScreen extends StatefulWidget {
  final FirebaseAuthentication auth;
  const LoginScreen(this.auth, {super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loggedIn = false;

  String _message = '';
  bool _isLogin = true;
  final TextEditingController txtUserName = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();


  void _logOut() {
    widget.auth.logout().then((value) {
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
        ? HomePage(widget.auth, logOut: _logOut)
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
                child: Container(
                  padding: const EdgeInsets.all(36),
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
      padding: const EdgeInsets.only(top: 128),
      child: TextFormField(
        controller: txtUserName,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          hintText: 'Email',
          icon: Icon(Icons.email),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
        cursorColor: Colors.blue,
        validator: (text) {
          if (text!.isEmpty) {
            return 'Email is required';
          } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(text)) {
            return 'Please enter a valid email address';
          }
          return null;
        },
      ),
    );
  }


  Widget passwordInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: TextFormField(
        controller: txtPassword,
        keyboardType: TextInputType.emailAddress,
        obscureText: true,
        decoration: const InputDecoration(
          hintText: 'Password',
          icon: Icon(Icons.lock),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
        cursorColor: Colors.blue,
        validator: (text) => text!.isEmpty ? 'Password is required' : null,
      ),
    );
  }


  Widget btnMain() {
    String btnText = _isLogin ? 'Log in' : 'Sign Up';
    return Padding(
        padding: const EdgeInsets.only(top: 128),
        child: Container(
            height: 60,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).primaryColorLight),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      side: const BorderSide(color: Colors.black)),
                ),
              ),
              child: Text(btnText,
                  style: const TextStyle(fontSize: 18, color: Colors.black)),
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  if (_isLogin) {
                    widget.auth
                        .login(txtUserName.text, txtPassword.text)
                        .then((value) async {
                      if (value == null) {
                        setState(() {
                          _message = 'Login Error';
                        });
                      } else {
                        final userId = value;
                        // final userDoc = FirebaseFirestore.instance
                        //     .collection('users')
                        //     .doc(userId);
                        // await userDoc.update({
                        //   'tokens': FieldValue.arrayUnion([widget.token]),
                        // });
                        setState(() {
                          _message = 'User $userId successfully logged in';
                          loggedIn = true;
                        });
                      }
                    });
                  } else {
                    widget.auth
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
                          // 'tokens': [widget.token],
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
      child: Text(
        buttonText,
        style: const TextStyle(
          color: Colors.blue,
        ),
      ),
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
