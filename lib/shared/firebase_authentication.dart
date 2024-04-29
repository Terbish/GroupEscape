import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class FirebaseAuthentication {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<void> addTrip(String tripName, String startDate, String endDate, List<String> locations) async {
    try {
      String? userId = _firebaseAuth.currentUser?.uid;
      if (userId != null) {
        await _firestore.collection('trips').add({
          'userId': userId,
          'tripName': tripName,
          'startDate': startDate,
          'endDate': endDate,
          'locations': locations,
        });
      }
    } catch (e) {
      print('Error adding trip: $e');
    }
  }
}
