import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_escape/firebase_options.dart';
import 'package:integration_test/integration_test.dart';
import 'package:group_escape/pages/home_page.dart';
import 'package:group_escape/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  Future<void> signIn(WidgetTester tester) async {
    // Sign in with test credentials
    final Finder emailField = find.widgetWithText(TextField, 'Email');
    await tester.enterText(emailField, 'jerry.test@gmail.com');
    await tester.pumpAndSettle();

    final Finder passwordField = find.widgetWithText(TextField, 'Password');
    await tester.enterText(passwordField, 'mcspar4893');
    await tester.pumpAndSettle();

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    final Finder loginButton = find.widgetWithText(ElevatedButton, "Log in");
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
  }

  Future<void> homePage(WidgetTester tester) async {
    expect(find.text('My Trips'), findsOne);

    final Finder iconFinder = find.byIcon(Icons.add);
    expect(iconFinder, findsOneWidget);
    await tester.tap(iconFinder);
  }

  group('HomePage Integration Tests', () {
    testWidgets('Check if the HomePage widget is rendered', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await signIn(tester);
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 2));
      await homePage(tester);

    });
  });
}
