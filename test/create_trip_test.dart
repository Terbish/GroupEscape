import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_escape/pages/create_trip.dart';

void main() {
  testWidgets('CreateTrip widget renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CreateTrip(),
      ),
    );

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.descendant(of: find.byType(AppBar), matching: find.text('Create Trip')), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.descendant(of: find.byType(ElevatedButton), matching: find.text('Create Trip')), findsOneWidget);
  });
}