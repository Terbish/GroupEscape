import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:group_escape/pages/trip_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_escape/services/firestore_service.dart';
import 'package:group_escape/shared/firebase_authentication.dart';
import 'package:group_escape/util/availability.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'trip_details_test.mocks.dart';

@GenerateMocks([FirestoreService])
@GenerateMocks([FirebaseAuthentication])
void main() {
  group('TripDetailsPage', () {
    testWidgets('displays trip details correctly', (WidgetTester tester) async {
      final mockFirestore = MockFirestoreService();
      final authMock = MockFirebaseAuthentication();
      final mockAvailability = [
        Availability(
            userId: '1',
            startDate: Timestamp.fromDate(DateTime.now()),
            endDate: Timestamp.fromDate(DateTime.now())),
        Availability(
            userId: '2',
            startDate: Timestamp.fromDate(DateTime.now()),
            endDate: Timestamp.fromDate(DateTime.now()))
      ];

      when(authMock.login(any, any)).thenAnswer((_) async => "123");
      when(mockFirestore.getUserName(any))
          .thenAnswer((_) => Future.value('User 1'));
      await tester.pumpWidget(MaterialApp(
        home: TripDetailsPage(
            tripId: "123",
            tripName: "test123",
            availability: mockAvailability,
            locations: ['Seattle', 'Frankfurt'],
            db: mockFirestore),
      ));

      await tester.tap(find.byIcon(Icons.ios_share));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.ios_share));
      await tester.pump();

      expect(find.text('test123'), findsOneWidget);
      expect(find.text('Location(s): Seattle, Frankfurt'), findsOneWidget);
      expect(find.byType(Container), findsNWidgets(2));
    });

    testWidgets('displays loading indicator while fetching user name',
        (WidgetTester tester) async {
      final mockAvailability = [
        Availability(
            userId: '1',
            startDate: Timestamp.fromDate(DateTime.now()),
            endDate: Timestamp.fromDate(DateTime.now())),
        Availability(
            userId: '2',
            startDate: Timestamp.fromDate(DateTime.now()),
            endDate: Timestamp.fromDate(DateTime.now()))
      ];

      final mockDb = MockFirestoreService();

      when(mockDb.getUserName('1')).thenAnswer((_) => Future.value('User 1'));
      when(mockDb.getUserName('2')).thenAnswer((_) => Future.value('User 2'));
      await tester.pumpWidget(MaterialApp(
        home: TripDetailsPage(
            tripId: "123",
            tripName: "test123",
            availability: mockAvailability,
            locations: ['Seattle', 'Frankfurt'],
            db: mockDb),
      ));

      expect(find.text('Loading...'), findsNWidgets(2));
    });
  });
}
