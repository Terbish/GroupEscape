import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  final String uid;
  final String email;
  final String name;

  User({required this.uid, required this.email, required this.name});

  factory User.fromFirestore(DocumentSnapshot userSnapshot){
    final userData = userSnapshot.data() as Map<String, dynamic>?;
    return User(
      uid: userSnapshot.id,
      email: userData?['email'] ?? '',
      name: userData?['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'uid': uid,
      'email': email,
      'name': name,
    };
  }
}