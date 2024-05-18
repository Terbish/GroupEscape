import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_escape/pages/create_trip.dart';
import 'package:group_escape/services/firestore_service.dart';
import 'package:group_escape/shared/firebase_authentication.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'trip_details_test.mocks.dart';


@GenerateMocks([FirebaseAuthentication, FirestoreService])
void main() {
  group('Create Trip Test', () {
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

      expect(find.byType(AppBar), findsOneWidget);
      expect(
          find.descendant(
              of: find.byType(AppBar), matching: find.text('Create Trip')),
          findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(
          find.descendant(
              of: find.byType(ElevatedButton),
              matching: find.text('Add Dates')),
          findsOneWidget);
      expect(
          find.descendant(
              of: find.byType(ElevatedButton),
              matching: find.text('Create Trip')),
          findsOneWidget);
    });

  });
}
