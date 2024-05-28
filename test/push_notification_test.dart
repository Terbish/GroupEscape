import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_escape/services/push_notifications.dart';
import 'mock.dart';
import 'package:firebase_messaging_platform_interface/firebase_messaging_platform_interface.dart';

void main() {
  setupFirebaseMessagingMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
    FirebaseMessagingPlatform.instance = kMockMessagingPlatform;
  });

  testWidgets('Test Push notification functions', (WidgetTester tester) async {
    PushNotifications pN = PushNotifications();

    pN.sendNotification(topic: '123');
    pN.sendFinalizedNotification(topic: '123');

  });






}
