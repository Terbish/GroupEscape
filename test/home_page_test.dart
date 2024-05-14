
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_escape/pages/home_page.dart';

void main() {
  group('Homepage Test', () {
    testWidgets(
        'CreateTrip widget renders correctly', (WidgetTester tester) async {
      tester.pumpWidget(
          MaterialApp(
              home: HomePage(logOut: () {},)
          ));
    });
  });
}
