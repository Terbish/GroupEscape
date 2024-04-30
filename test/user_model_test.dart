import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:group_escape/model/user_model.dart';

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {
  @override
  String get id => 'userId';
}

void main() {
  group('User Model Test', (){
    test('User object should be created from Firestore data', (){
      final userDocSnapshot = MockDocumentSnapshot();
      when(userDocSnapshot.data()).thenReturn({
        'name': 'Test User',
        'email': 'test@testing.com',
      });

      final user = User.fromFirestore(userDocSnapshot);

      if (kDebugMode) {
        print('User name: ${user.name}');
        print('User email: ${user.email}');
        print('User uid: ${user.uid}');
      }


      expect(user.name, equals('Test User'));
      expect(user.email, equals('test@testing.com'));
      expect(user.uid, equals('userId'));
    });
  });

  test('User object should be converted to Firestore data', (){
    final user = User(
      uid: 'userId',
      email: 'test@testing.com',
      name: 'Test User'
    );

    final userData = user.toMap();

    if (kDebugMode) {
      print('User Data: $userData');
    }

    expect(userData, equals({
      'uid': 'userId',
      'email': 'test@testing.com',
      'name': 'Test User',
    }));
  });

}