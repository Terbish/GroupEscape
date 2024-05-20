import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_escape/widgets/join_trip_dialog.dart';

import 'package:mockito/mockito.dart';
import 'mock.dart';
import 'trip_details_test.mocks.dart';
import 'package:firebase_messaging_platform_interface/firebase_messaging_platform_interface.dart';

void main() {

  setupFirebaseMessagingMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
    FirebaseMessagingPlatform.instance = kMockMessagingPlatform;
  });

  group('Create Trip Test', () {
    final MockFirebaseAuthentication firebaseInstance = MockFirebaseAuthentication();
    final MockFirestoreService fS = MockFirestoreService();

    testWidgets('JoinTripDialog widget rendering test ', (WidgetTester tester) async {
      await tester.pumpWidget(
          MaterialApp(
            home: JoinTripDialog(fS, firebaseInstance),
          )
      );

      expect(find.text('Join Trip'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Join'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('Test Cancel button', (WidgetTester tester) async {
      await tester.pumpWidget(
          MaterialApp(
            home: JoinTripDialog(fS, firebaseInstance),
          )
      );

      await tester.tap(find.text("Cancel"));
      await tester.pumpAndSettle();
      expect(find.text('Join'), findsNothing);
    });

    testWidgets('Test Validator', (WidgetTester tester) async {
      await tester.pumpWidget(
          MaterialApp(
            home: JoinTripDialog(fS, firebaseInstance),
          )
      );




      expect(find.text('ID is required'), findsOneWidget);
      await tester.enterText(find.byType(TextFormField),"xyz");
      await tester.pumpAndSettle();

      expect(find.text('ID is required'), findsNothing);
      // await tester.tap(find.text("Join"));
      // tester.pump;
      // expect(find.text('Join'), findsNothing);
    });

    testWidgets('Test Join Button successful', (WidgetTester tester) async {
      await tester.pumpWidget(
          MaterialApp(
            home: JoinTripDialog(fS, firebaseInstance),
          )
      );
      when(fS.checkIfExists(any)).thenAnswer((_){ return Future.value(true);});
      when(fS.addUserToTrip(any, any)).thenAnswer((_) async {});
      when(firebaseInstance.currentUser()).thenReturn('user1');

      await tester.enterText(find.byType(TextFormField),"xyz");
      await tester.pumpAndSettle();

      expect(find.text('ID is required'), findsNothing);
      await tester.tap(find.text("Join"));
      await tester.pumpAndSettle();
      expect(find.text('Join'), findsNothing);
    });

    testWidgets('Test Join Button failed', (WidgetTester tester) async {
      await tester.pumpWidget(
          MaterialApp(
              home: Scaffold(
                body:JoinTripDialog(fS, firebaseInstance),
              )
          )
      );
      when(fS.checkIfExists(any)).thenAnswer((_){ return Future.value(false);});
      when(fS.addUserToTrip(any, any)).thenAnswer((_) async {});
      when(firebaseInstance.currentUser()).thenReturn('user1');

      await tester.enterText(find.byType(TextFormField),"xyz");
      await tester.pumpAndSettle();

      expect(find.text('ID is required'), findsNothing);
      await tester.tap(find.text("Join"));
      await tester.pumpAndSettle();
      expect(find.text('Invalid ID'), findsOneWidget);
    });
  });
}

