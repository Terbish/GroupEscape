import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_escape/pages/home_page.dart';
import 'package:group_escape/pages/login_screen.dart';
import 'package:group_escape/pages/trip_details.dart';
import 'package:mockito/mockito.dart';

import 'create_trip_test.mocks.dart';


main() {
  group('LoginScreen Validator Tests', () {
    testWidgets('test log out button', (WidgetTester tester) async {
      // Build the LoginScreen widget
      bool gotCalled = false;
      final logOut = () {gotCalled = true;};

      final MockFirebaseAuthentication firebaseInstance = MockFirebaseAuthentication();
      final MockFirestoreService fS = MockFirestoreService();

      when(firebaseInstance.currentUser()).thenReturn("123");
      // when(fS.getTripsStream('123')).thenReturn(  );

      when(fS.getTripsStream(any)).thenAnswer((_) {
        return Stream.value([
          {
            'tripName': 'Trip 1',
            'availability': [
              {'userID': '123', 'startDate': '2024-05-15', 'endDate': '2024-05-20'},
              {'userID': 'user2', 'startDate': '2024-05-18', 'endDate': '2024-05-25'},
            ],
            'locations': ['Location 1', 'Location 2'],
            'tripId': '123456',
            'userId': ['123','user2']// Replace with actual trip ID
          },
          {
            'tripName': 'Trip 2',
            'availability': [
              {'userID': '123', 'startDate': '2024-06-01', 'endDate': '2024-06-10'},
            ],
            'locations': ['Location 3'],
            'tripId': '789012',
            'userId': ['123'],// Replace with actual trip ID
          },
          // Add more trips as needed
        ]);
      });


      await tester.pumpWidget(
        MaterialApp( // Add MaterialApp widget
          home: HomePage(firebaseInstance, logOut: logOut, fS: fS),
        ),
      );

      await tester.pump();
      expect(find.text('My Trips'), findsOneWidget);
      expect(find.text('Trip 1'), findsOneWidget);
      expect(find.text('Trip 2'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.logout));
      expect(gotCalled, true);

    });



    testWidgets('Test Pop up menu', (WidgetTester tester) async {
      // Build the LoginScreen widget
      bool gotCalled = false;
      final logOut = () {gotCalled = true;};

      final MockFirebaseAuthentication firebaseInstance = MockFirebaseAuthentication();
      final MockFirestoreService fS = MockFirestoreService();

      when(firebaseInstance.currentUser()).thenReturn("123");

      when(fS.getTripsStream(any)).thenAnswer((_) {
        return Stream.value([
          {
            'tripName': 'Trip 1',
            'availability': [
              {'userID': '123', 'startDate': '2024-05-15', 'endDate': '2024-05-20'},
              {'userID': 'user2', 'startDate': '2024-05-18', 'endDate': '2024-05-25'},
            ],
            'locations': ['Location 1', 'Location 2'],
            'tripId': '123456',
            'userId': ['123','user2']// Replace with actual trip ID
          },
          {
            'tripName': 'Trip 2',
            'availability': [
              {'userID': '123', 'startDate': '2024-06-01', 'endDate': '2024-06-10'},
            ],
            'locations': ['Location 3'],
            'tripId': '789012',
            'userId': ['123'],
          },
        ]);
      });

      await tester.pumpWidget(
        MaterialApp( // Add MaterialApp widget
          home: HomePage(firebaseInstance, logOut: logOut, fS: fS),
        ),
      );

      await tester.pump();
      expect(find.text('My Trips'), findsOneWidget);
      expect(find.text('Trip 1'), findsOneWidget);
      expect(find.text('Trip 2'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(find.text('Create Trip'), findsOneWidget);
      expect(find.text('Join Trip'), findsOneWidget);

    });

    testWidgets('Test Clicking on trip', (WidgetTester tester) async {
      // Build the LoginScreen widget
      bool gotCalled = false;
      final logOut = () {gotCalled = true;};

      final MockFirebaseAuthentication firebaseInstance = MockFirebaseAuthentication();
      final MockFirestoreService fS = MockFirestoreService();

      when(firebaseInstance.currentUser()).thenReturn("123");

      when(fS.getUserName(any)).thenAnswer((_){
        return Future.value(('UserName'));
      });

      when(fS.getTripsStream(any)).thenAnswer((_) {
        return Stream.value([
          {
            'tripName': 'Trip 1',
            'availability': [
              {'userID': '123', 'startDate': Timestamp.fromDate(DateTime.now()), 'endDate': Timestamp.fromDate(DateTime.now())},
              {'userID': 'user2', 'startDate': Timestamp.fromDate(DateTime.now()), 'endDate': Timestamp.fromDate(DateTime.now())},
            ],
            'locations': ['Location 1', 'Location 2'],
            'tripId': '123456',
            'userId': ['123','user2']
          },
          {
            'tripName': 'Trip 2',
            'availability': [
              {'userID': '123', 'startDate': '2024-06-01', 'endDate': '2024-06-10'},
            ],
            'locations': ['Location 3'],
            'tripId': '789012',
            'userId': ['123'],
          },

        ]);
      });

      await tester.pumpWidget(
        MaterialApp( // Add MaterialApp widget
          home: HomePage(firebaseInstance, logOut: logOut, fS: fS),
        ),
      );


      await tester.pump();
      expect(find.text('My Trips'), findsOneWidget);
      expect(find.text('Trip 1'), findsOneWidget);
      expect(find.text('Trip 2'), findsOneWidget);

      await tester.tap(find.text('Trip 1'));
      await tester.pumpAndSettle();
      expect(find.byType(TripDetailsPage), findsOneWidget);
      expect(find.text('Trip 1'), findsOneWidget);
    });
  });
}
