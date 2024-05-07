import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_escape/models/trip_model.dart';

class FirestoreService{
  final FirebaseFirestore _db = FirebaseFirestore.instance;

    Future<String> addTrip(TripModel trip) async{
      DocumentReference docRef = await _db.collection('trips').add(trip.toJson());
      return docRef.id;
    }

    Future<void> addAvailability(String tripId, String userId, Map<String, dynamic> availability) async{
      await _db.collection('trips').doc(tripId).collection('availability').doc(userId).set(availability);
    }
}