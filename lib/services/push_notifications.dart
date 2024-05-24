import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_functions/cloud_functions.dart';

class PushNotifications {
  static final _firebaseMessaging = FirebaseMessaging.instance;


  static Future init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    final token = await _firebaseMessaging.getToken();
  }

  Future<bool> sendNotification ({required String topic}) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'sendNotification');

    final response = await callable.call(<String, dynamic>{
      'topic': topic,
    });

    if (response.data == null) {
      return false;
    }
    return true;
  }

  Future<bool> sendFinalizedNotification ({required String topic}) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'sendFinalizedNotification');

    final response = await callable.call(<String, dynamic>{
      'topic': topic,
    });
    if (response.data == null) {
      return false;
    }
    return true;
  }
}