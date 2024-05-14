import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_escape/pages/create_trip.dart';
import 'package:group_escape/services/firestore_service.dart';
import 'package:group_escape/shared/firebase_authentication.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([FirestoreService])
void main() {
  group('Create Trip Test', () {
    testWidgets('CreateTrip widget renders correctly',
        (WidgetTester tester) async {
      final mockFirestore = MockFirestoreService();
      await tester.pumpWidget(
        const MaterialApp(
          home: CreateTrip(),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
      expect(
          find.descendant(
              of: find.byType(AppBar), matching: find.text('Create Trip')),
          findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(4));
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(
          find.descendant(
              of: find.byType(ElevatedButton),
              matching: find.text('Create Trip')),
          findsOneWidget);
    });

  });
}
