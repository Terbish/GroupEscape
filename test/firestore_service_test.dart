import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_escape/models/trip_model.dart';
import 'package:group_escape/services/firestore_service.dart';
import 'package:group_escape/services/push_notifications.dart';
import 'package:group_escape/util/availability.dart';
import 'package:async/async.dart';



import 'package:firebase_messaging_platform_interface/firebase_messaging_platform_interface.dart';
import 'package:mockito/annotations.dart';

import 'firestore_service_test.mocks.dart';
import 'mock.dart';

@GenerateMocks([PushNotifications])
void main() {

  setupFirebaseMessagingMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
    FirebaseMessagingPlatform.instance = kMockMessagingPlatform;
  });

  group('firebase Authentication', () {

    testWidgets('Add trip test', (WidgetTester tester) async {
      final firestore = FakeFirebaseFirestore();
      MockPushNotifications pN = MockPushNotifications();
      FirestoreService fS = FirestoreService(fS: firestore, pN: pN);

      TripModel tP = TripModel(
          userIds: ['1','2'],
          tripName: 'TestTrip',
          locations: ['SEA','FRA'],
          availability: [
            Availability(startDate: Timestamp.now(), endDate: Timestamp.now(), userId: '1'),
            Availability(startDate: Timestamp.now(), endDate: Timestamp.now(), userId: '2'),
          ]
      );
      String tripID = await fS.addTrip(tP);
      expect(tripID,  isA<String>());
    });

    testWidgets('Add Availability test', (WidgetTester tester) async {
      final firestore = FakeFirebaseFirestore();
      MockPushNotifications pN = MockPushNotifications();
      FirestoreService fS = FirestoreService(fS: firestore, pN: pN);

      TripModel tP = TripModel(
          userIds: ['1','2'],
          tripName: 'TestTrip',
          locations: ['SEA','FRA'],
          availability: [
            Availability(startDate: Timestamp.now(), endDate: Timestamp.now(), userId: '1'),
            Availability(startDate: Timestamp.now(), endDate: Timestamp.now(), userId: '2'),
          ]
      );
      String tripID = await fS.addTrip(tP);
      Availability availability = Availability(startDate: Timestamp.now(), endDate: Timestamp.now(), userId: '3');
      fS.addAvailability(tripID, availability);
      expect(tripID,  isA<String>());
    });

    testWidgets('Add Availability test', (WidgetTester tester) async {
      final firestore = FakeFirebaseFirestore();
      MockPushNotifications pN = MockPushNotifications();
      FirestoreService fS = FirestoreService(fS: firestore, pN: pN);

      TripModel tP = TripModel(
          userIds: ['1','2'],
          tripName: 'TestTrip',
          locations: ['SEA','FRA'],
          availability: [
            Availability(startDate: Timestamp.now(), endDate: Timestamp.now(), userId: '1'),
            Availability(startDate: Timestamp.now(), endDate: Timestamp.now(), userId: '2'),
          ]
      );
      String tripID = await fS.addTrip(tP);
      Availability availability = Availability(startDate: Timestamp.now(), endDate: Timestamp.now(), userId: '3');
      fS.addAvailability(tripID, availability);
      expect(tripID,  isA<String>());
    });

    testWidgets('Check if exists test', (WidgetTester tester) async {
      final firestore = FakeFirebaseFirestore();
      MockPushNotifications pN = MockPushNotifications();
      FirestoreService fS = FirestoreService(fS: firestore, pN: pN);

      TripModel tP = TripModel(
          userIds: ['1','2'],
          tripName: 'TestTrip',
          locations: ['SEA','FRA'],
          availability: [
            Availability(startDate: Timestamp.now(), endDate: Timestamp.now(), userId: '1'),
            Availability(startDate: Timestamp.now(), endDate: Timestamp.now(), userId: '2'),
          ]
      );
      String tripID = await fS.addTrip(tP);
      bool exists = await fS.checkIfExists(tripID);
      expect(exists, true);
    });

    testWidgets('delete trip test', (WidgetTester tester) async {
      final firestore = FakeFirebaseFirestore();
      MockPushNotifications pN = MockPushNotifications();
      FirestoreService fS = FirestoreService(fS: firestore, pN: pN);

      TripModel tP = TripModel(
          userIds: ['1','2'],
          tripName: 'TestTrip',
          locations: ['SEA','FRA'],
          availability: [
            Availability(startDate: Timestamp.now(), endDate: Timestamp.now(), userId: '1'),
            Availability(startDate: Timestamp.now(), endDate: Timestamp.now(), userId: '2'),
          ]
      );
      String tripID = await fS.addTrip(tP);
      bool exists = await fS.checkIfExists(tripID);
      expect(exists, true);
      await fS.deleteTrip(tripID, '1');
      exists = await fS.checkIfExists(tripID);
      expect(exists, true);
      await fS.deleteTrip(tripID, '2');
      exists = await fS.checkIfExists(tripID);
      expect(exists, false);
    });

    testWidgets('add user to trip test', (WidgetTester tester) async {
      final firestore = FakeFirebaseFirestore();
      MockPushNotifications pN = MockPushNotifications();
      FirestoreService fS = FirestoreService(fS: firestore, pN: pN);

      TripModel tP = TripModel(
          userIds: ['1'],
          tripName: 'TestTrip',
          locations: ['SEA','FRA'],
          availability: [
            Availability(startDate: Timestamp.now(), endDate: Timestamp.now(), userId: '1'),
          ]
      );
      String tripID = await fS.addTrip(tP);
      bool exists = await fS.checkIfExists(tripID);
      expect(exists, true);
      fS.addUserToTrip(tripID, '2');
      await fS.deleteTrip(tripID, '1');
      exists = await fS.checkIfExists(tripID);
      expect(exists, true);
      await fS.deleteTrip(tripID, '2');
      exists = await fS.checkIfExists(tripID);
      expect(exists, false);
    });

    testWidgets('get user name test', (WidgetTester tester) async {
      final firestore = FakeFirebaseFirestore();
      MockPushNotifications pN = MockPushNotifications();
      DocumentReference doc = await firestore.collection('users').add({'name': 'username'});
      FirestoreService fS = FirestoreService(fS: firestore, pN: pN);
      
      String name = await fS.getUserName(doc.id);
      expect(name, 'username');
    });


    testWidgets('get trips stream test', (WidgetTester tester) async {
      final firestore = FakeFirebaseFirestore();
      MockPushNotifications pN = MockPushNotifications();
      FirestoreService fS = FirestoreService(fS: firestore, pN: pN);

      TripModel tP1 = TripModel(
          userIds: ['1', '2'],
          tripName: 'TestTrip1',
          locations: ['SEA', 'FRA'],
          availability: [
            Availability(startDate: Timestamp.now(),
                endDate: Timestamp.now(),
                userId: '1'),
            Availability(startDate: Timestamp.now(),
                endDate: Timestamp.now(),
                userId: '2'),
          ]
      );
      String tripID1 = await fS.addTrip(tP1);

      TripModel tP2 = TripModel(
          userIds: ['1', '2'],
          tripName: 'TestTrip2',
          locations: ['SEA', 'FRA'],
          availability: [
            Availability(startDate: Timestamp.now(),
                endDate: Timestamp.now(),
                userId: '1'),
            Availability(startDate: Timestamp.now(),
                endDate: Timestamp.now(),
                userId: '2'),
          ]
      );
      String tripID2 = await fS.addTrip(tP2);

      TripModel tP3 = TripModel(
          userIds: ['2'],
          tripName: 'TestTrip3',
          locations: ['SEA', 'FRA'],
          availability: [
            Availability(startDate: Timestamp.now(),
                endDate: Timestamp.now(),
                userId: '2'),
          ]
      );
      String tripID3 = await fS.addTrip(tP3);

      var streamQueue = StreamQueue(fS.getTripsStream('1'));
      List<Map<String, dynamic>> trips = await streamQueue.next;

      expect(trips.length, 2);
    });
  });
}
