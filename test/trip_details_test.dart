import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_escape/pages/trip_details.dart';

main() {
  group('Trip Details Test', () {
    testWidgets('display trip details', (WidgetTester tester) async {
      TripDetailsPage(
        tripId: "123",
        tripName: "test123",
        startDate: "05/07",
        endDate: "05/08",
        locations: ['Seattle','Frankfurt']);

      await tester.pumpWidget(MaterialApp(
          home: TripDetailsPage(
              tripId: "123",
              tripName: "test123",
              startDate: "05/07",
              endDate: "05/08",
              locations: ['Seattle','Frankfurt']
          )
      ));
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.descendant(of: find.byType(AppBar), matching: find.text('test123')), findsOneWidget);
      expect(find.text('Trip Name: test123'), findsOneWidget);
      expect(find.text("Start Date: 05/07"), findsOneWidget);
      expect(find.text("End Date: 05/08"), findsOneWidget);
      expect(find.text('Location(s): Seattle, Frankfurt'), findsOneWidget);
    });
  });
}