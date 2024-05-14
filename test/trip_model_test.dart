

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_escape/models/trip_model.dart';
import 'package:group_escape/util/availability.dart';

void main() {
  group('Create Trip Test', (){
    testWidgets('CreateTrip widget renders correctly', (WidgetTester tester) async {

      //setup
      final userIds = ['user1', 'user2'];
      final tripName = 'test';
      final locations = ['seattle'];
      final availability = [
        Availability(
        startDate: Timestamp.fromDate(DateTime(2024, 1, 1)),
        endDate: Timestamp.fromDate(DateTime(2024, 1, 7)),
        userId: 'user1',),
        Availability(
          startDate: Timestamp.fromDate(DateTime(2024, 1, 1)),
          endDate: Timestamp.fromDate(DateTime(2024, 1, 7)),
          userId: 'user2',
        )];

      final tripModel = TripModel(userIds: userIds,
          tripName: tripName,
          locations: locations,
          availability: availability);


      //execute
      final jsonMap = tripModel.toJson();

      //verify
      expect(jsonMap['userId'], equals(userIds));
      expect(jsonMap['tripName'], equals(tripName));
      expect(jsonMap['locations'], equals(locations));
      expect(jsonMap['availability'].length, equals(2));
    });


  });
}
