import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_escape/firebase_options.dart';
import 'package:group_escape/pages/create_trip.dart';
import 'package:group_escape/pages/login_screen.dart';
import 'package:group_escape/services/firestore_service.dart';
import 'package:group_escape/shared/firebase_authentication.dart';
import 'package:mockito/annotations.dart';

import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:mockito/mockito.dart';

import 'trip_details_test.mocks.dart';


@GenerateMocks([FirebaseAuthentication, FirestoreService])
void main() {
  group('Create Trip Test', () {
    // setUpAll(() async {
    //   // Initialize Firebase app

    //   await Firebase.initializeApp(
    //     options: DefaultFirebaseOptions.currentPlatform,
    //   );
    // });

    testWidgets('CreateTrip widget renders correctly',
        (WidgetTester tester) async {

      final MockFirebaseAuthentication firebaseInstance = MockFirebaseAuthentication();
      final MockFirestoreService fS = MockFirestoreService();


      when(firebaseInstance.currentUser()).thenReturn("123");

      await tester.pumpWidget(
        MaterialApp(
          home: CreateTrip(firebaseInstance, fS: fS),
        ),
      );

      // expect(find.byType(AppBar), findsOneWidget);
      // expect(
      //     find.descendant(
      //         of: find.byType(AppBar), matching: find.text('Create Trip')),
      //     findsOneWidget);
      // expect(find.byType(TextFormField), findsNWidgets(4));
      // expect(find.byType(ElevatedButton), findsOneWidget);
      // expect(
      //     find.descendant(
      //         of: find.byType(ElevatedButton),
      //         matching: find.text('Create Trip')),
      //     findsOneWidget);
    });

  });
}
