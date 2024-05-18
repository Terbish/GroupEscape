import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_escape/models/trip_model.dart';
import 'package:group_escape/util/availability.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;


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
}