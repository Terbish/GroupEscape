import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';


import 'package:flutter_test/flutter_test.dart';

import 'package:group_escape/services/firestore_service.dart';
import 'package:group_escape/shared/firebase_authentication.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('firebase Authentication', () {

    MockUser user = MockUser(
        isAnonymous: false,
        email: 'test@gmail.com',
        uid: 'test_uid'
    );


    testWidgets('CurrentUser test', (WidgetTester tester) async {
      final auth = MockFirebaseAuth(mockUser: user, signedIn: true);
      final firestore = FakeFirebaseFirestore();
      FirebaseAuthentication firebase = await FirebaseAuthentication(
          auth, firestore);
      final uid = firebase.currentUser();
      expect(uid, 'test_uid');
    });

    testWidgets('successful login test', (WidgetTester tester) async {
      final auth = MockFirebaseAuth(mockUser: user, signedIn: false);
      final firestore = FakeFirebaseFirestore();
      FirebaseAuthentication firebase = await FirebaseAuthentication(auth, firestore);
      final uid = await firebase.login('test@gmail.com', 'password');
      expect(uid, 'test_uid');
    });
    //
    // testWidgets('unsuccessful login test', (WidgetTester tester) async {
    //   final auth = MockFirebaseAuth(mockUser: user, signedIn: false);
    //   final firestore = FakeFirebaseFirestore();
    //   FirebaseAuthentication firebase = await FirebaseAuthentication(auth, firestore);
    //   when(auth.signInWithEmailAndPassword(email: '123@gmail.com',password: 'p'  ))
    //       .thenThrow(FirebaseAuthException(code: 'bla'));
    //
    //   final uid = await firebase.login('test@gmail.com', 'password');
    //   expect(uid, 'test_uid');
    // });

    testWidgets('successful createUser test', (WidgetTester tester) async {
      final auth = MockFirebaseAuth(mockUser: user, signedIn: false);
      final firestore = FakeFirebaseFirestore();
      FirebaseAuthentication firebase = await FirebaseAuthentication(auth, firestore);
      final uid = await firebase.createUser('test@gmail.com', 'password');
      expect(uid, isA<String>());
    });

    testWidgets('Successful logout test', (WidgetTester tester) async {
      final auth = MockFirebaseAuth(mockUser: user, signedIn: true);
      final firestore = FakeFirebaseFirestore();
      FirebaseAuthentication firebase = await FirebaseAuthentication(
          auth, firestore);
      final loggedOut = await firebase.logout();
      expect(loggedOut, true);
    });



  });
}