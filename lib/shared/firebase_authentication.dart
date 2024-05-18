import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';


class FirebaseAuthentication {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  String currentUser(){
    return _firebaseAuth.currentUser!.uid;
  }

  FirebaseAuthentication(this._firebaseAuth, this._firestore);

  Future<String?> createUser(String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return credential.user?.uid;
    } on FirebaseAuthException {
      return null;
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return credential.user?.uid;
    } on FirebaseAuthException {
      return null;
    }
  }

  Future<bool> logout() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } on FirebaseAuthException {
      return false;
    }
  }
}
