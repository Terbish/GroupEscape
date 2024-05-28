import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_escape/pages/create_trip.dart';
import 'package:group_escape/services/firestore_service.dart';
import 'package:group_escape/shared/firebase_authentication.dart';
import 'package:intl/intl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'create_trip_test.mocks.dart';

// import 'trip_details_test.mocks.dart';


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

    testWidgets('Form validation works correctly', (WidgetTester tester) async {
      final MockFirebaseAuthentication firebaseInstance = MockFirebaseAuthentication();
      final MockFirestoreService fS = MockFirestoreService();

      when(firebaseInstance.currentUser()).thenReturn("123");
      when(fS.addTrip(any)).thenAnswer((_) async => "trip_id");
      when(fS.subscribeToTopic(any)).thenAnswer((_) async {});

      await tester.pumpWidget(
        MaterialApp(
          home: CreateTrip(firebaseInstance, fS: fS),
        ),
      );

      // Trigger form validation by tapping the Create Trip button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Trip'));
      await tester.pump();

      expect(find.text('Please enter a trip name'), findsOneWidget);
      expect(find.text('Please enter at least one location'), findsOneWidget);

      // Enter valid data
      await tester.enterText(find.byType(TextFormField).first, 'My Trip');
      await tester.enterText(find.byType(TextFormField).last, 'New York, Los Angeles');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add Dates'));
      await tester.pumpAndSettle();

      // Close the date picker
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Trip'));
      await tester.pump();

      expect(find.text('Please enter a trip name'), findsNothing);
      expect(find.text('Please enter at least one location'), findsNothing);
    });
  });
}
