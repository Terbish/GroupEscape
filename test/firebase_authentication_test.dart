import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_escape/shared/firebase_authentication.dart';
import 'package:mockito/mockito.dart';
import 'package:mock_exceptions/mock_exceptions.dart';


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

    testWidgets('unsuccessful login test', (WidgetTester tester) async {
      final auth = MockFirebaseAuth(mockUser: user, signedIn: false);
      final firestore = FakeFirebaseFirestore();
      FirebaseAuthentication firebase = await FirebaseAuthentication(
          auth, firestore);

      whenCalling(Invocation.method(#signInWithEmailAndPassword, null))
          .on(auth)
          .thenThrow(FirebaseAuthException(code: 'bla'));

      final result = await firebase.login(
          'test@gmail.com', 'password');
      expect(result, null);
    });

    testWidgets('successful createUser test', (WidgetTester tester) async {
      final auth = MockFirebaseAuth(mockUser: user, signedIn: false);
      final firestore = FakeFirebaseFirestore();
      FirebaseAuthentication firebase = await FirebaseAuthentication(auth, firestore);
      final uid = await firebase.createUser('test@gmail.com', 'password');
      expect(uid, isA<String>());
    });

    testWidgets('unsuccessful createUser test', (WidgetTester tester) async {
      final auth = MockFirebaseAuth(mockUser: user, signedIn: false);
      final firestore = FakeFirebaseFirestore();
      FirebaseAuthentication firebase = await FirebaseAuthentication(
          auth, firestore);

      whenCalling(Invocation.method(#createUserWithEmailAndPassword, null))
          .on(auth)
          .thenThrow(FirebaseAuthException(code: 'bla'));

      final result = await firebase.createUser(
          'test@gmail.com', 'password');
      expect(result, null);
    });

    testWidgets('Successful logout test', (WidgetTester tester) async {
      final auth = MockFirebaseAuth(mockUser: user, signedIn: true);
      final firestore = FakeFirebaseFirestore();
      FirebaseAuthentication firebase = FirebaseAuthentication(
          auth, firestore);
      final loggedOut = await firebase.logout();
      expect(loggedOut, true);
    });

    // testWidgets('Unsuccessful logout test', (WidgetTester tester) async {
    //   final auth = MockFirebaseAuth(mockUser: user, signedIn: true);
    //   final firestore = FakeFirebaseFirestore();
    //   whenCalling(Invocation.method(#signOut, null))
    //       .on(auth)
    //       .thenThrow(FirebaseAuthException(code: 'error'));
    //   FirebaseAuthentication firebase = FirebaseAuthentication(
    //       auth, firestore);
    //
    //   final result = await firebase.logout();
    //   expect(result, false);
    // });
  });
}



