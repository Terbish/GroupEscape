import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:group_escape/models/trip_model.dart';
import 'package:group_escape/services/push_notifications.dart';
import 'package:group_escape/util/availability.dart';

class FirestoreService {
  final FirebaseFirestore _db;
  FirebaseMessaging? _messaging;
  PushNotifications? _pushNotifications;


  FirestoreService({FirebaseFirestore? fS, FirebaseMessaging? fM, PushNotifications? pN}):
        _db = fS ?? FirebaseFirestore.instance,
        _messaging = fM ?? FirebaseMessaging.instance,
        _pushNotifications = pN ?? PushNotifications();

  Future<void> subscribeToTopic (tripId) async {
    // _messaging = _messaging ?? FirebaseMessaging.instance;
    await _messaging!.subscribeToTopic(tripId);
  }


  Future<bool> sendNotification ({required String topic}) async {
    return await _pushNotifications!.sendNotification(topic: topic);
  }

  // Future<bool> sendNotification ({required String topic}) async {
  //   HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
  //       'sendNotification');
  //
  //   final response = await callable.call(<String, dynamic>{
  //     'topic': topic,
  //   });
  //
  //   print('result is ${response.data ?? 'No data came back'}');
  //   if (response.data == null) {
  //     return false;
  //   }
  //   return true;
  // }

  Future<String> addTrip(TripModel trip) async {
    DocumentReference docRef = await _db.collection('trips').add(trip.toJson());
    return docRef.id;
  }

  Future<void> addAvailability(String tripId, Availability availability) async {
    await _db.collection('trips').doc(tripId).update({
      'availability': FieldValue.arrayUnion([availability.toJson()]),
    });
  }

  Future<void> deleteTrip(String tripId, String userId) async{
    _messaging!.unsubscribeFromTopic(tripId);
    final emptyTrip = await _db.collection('trips').doc(tripId).get().then((doc){
      final data = doc.data() as Map<String, dynamic>;
      return data['userId'].length ==  1;
    });
    if (emptyTrip == true){
      await _db.collection('trips').doc(tripId).delete();
    }
    else {
      await _db.collection('trips').doc(tripId).update({
        'userId': FieldValue.arrayRemove([userId])
      });

      List availability = await _db.collection('trips').doc(tripId).get().then((doc){
        final data = doc.data() as Map<String, dynamic>;
        return data['availability'];
      });

      Map<String, dynamic> userMap = availability.firstWhere(
            (map) => map['userID'] == userId,
        orElse: () => null,
      );

      await _db.collection('trips').doc(tripId).update({
        'availability': FieldValue.arrayRemove([userMap])
      });
    }
  }

  Future<bool> checkIfExists(String tripId) async {
    var doc = await _db.collection('trips').doc(tripId).get();
    return doc.exists;
  }

  Future<void> addUserToTrip(String tripId, String userId) async {
    await _db.collection('trips').doc(tripId).update({
      'userId': FieldValue.arrayUnion([userId]),
    });
  }

  Future<String> getUserName(String userId) async {
    return await _db.collection("users").doc(userId).get().then((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return data['name'];
    });
  }


  Stream<List<Map<String, dynamic>>> getTripsStream(String userId) {
    return _db
        .collection('trips')
        .where('userId', arrayContains: userId)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((doc) {
      final dict = doc.data();
      dict['tripId'] = doc.id;
      return dict;
    }).toList());
  }


  Future<void> addLocationToTrip(String tripId, String location) async {
    await _db.collection('trips').doc(tripId).update({
      'locations': FieldValue.arrayUnion([location]),
    });
  }

  Future<void> voteForLocation(String tripId, String location) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final tripDoc = await _db.collection('trips').doc(tripId).get();
    final userVotes = tripDoc.data()!['userVotes'] as Map<String, dynamic>? ?? {};
    if (userVotes[userId] != true) {
      await _db.collection('trips').doc(tripId).update({
        'locationVotes.$location': FieldValue.arrayUnion([userId]),
        'userVotes.$userId': true,
      });
    }
  }

  Future<void> endLocationVoting(String tripId) async {
    final tripDoc = await _db.collection('trips').doc(tripId).get();
    final locationVotes =
    tripDoc.data()!['locationVotes'] as Map<String, dynamic>;
    String finalLocation = '';
    int maxVotes = 0;
    locationVotes.forEach((location, votes) {
      final votesList = votes as List<dynamic>;
      if (votesList.length > maxVotes) {
        maxVotes = votesList.length;
        finalLocation = location;
      }
    });
    await _db.collection('trips').doc(tripId).update({
      'finalLocation': finalLocation,
    });
    await _pushNotifications!.sendFinalizedNotification(topic: tripId);
  }

  Future<String> getFinalLocation(String tripId) async {
    final tripDoc = await _db.collection('trips').doc(tripId).get();
    return tripDoc.data()!['finalLocation'] as String;
  }

  Future<DocumentSnapshot> getTripDetails(String tripId) async {
    return await _db.collection('trips').doc(tripId).get();
  }

}