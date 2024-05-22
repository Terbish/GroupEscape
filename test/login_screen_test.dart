import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_escape/pages/login_screen.dart';

import 'create_trip_test.mocks.dart';


main() {
  group('LoginScreen Validator Tests', () {
    testWidgets('User input validator test', (WidgetTester tester) async {
    // Build the LoginScreen widget
      final MockFirebaseAuthentication firebaseInstance = MockFirebaseAuthentication();
      await tester.pumpWidget(
        MaterialApp( // Add MaterialApp widget
          home: LoginScreen(firebaseInstance, false),
        ),
      );

      // Get the password input field
      final passwordField = find
          .byType(TextFormField)
          .first;

      // Perform input validation
      String? errorMessage = (passwordField
          .evaluate()
          .single
          .widget as TextFormField).validator!(''); // Empty input
      expect(errorMessage, 'Email is required');

      errorMessage = (passwordField
          .evaluate()
          .single
          .widget as TextFormField).validator!('test@example.com'); // Valid input
      expect(errorMessage, null);
    });

    testWidgets('Password input validator test', (WidgetTester tester) async {
      // Build the LoginScreen widget
      final MockFirebaseAuthentication firebaseInstance = MockFirebaseAuthentication();
      await tester.pumpWidget(
        MaterialApp( // Add MaterialApp widget
          home: LoginScreen(firebaseInstance, false),
        ),
      );

      // Get the password input field
      final passwordField = find
          .byType(TextFormField)
          .last;

      // Perform input validation
      String? errorMessage = (passwordField
          .evaluate()
          .single
          .widget as TextFormField).validator!(''); // Empty input
      expect(errorMessage, 'Password is required');

      errorMessage = (passwordField
          .evaluate()
          .single
          .widget as TextFormField).validator!('password123'); // Valid input
      expect(errorMessage, null);
    });
  });
}
