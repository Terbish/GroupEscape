import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_escape/models/trip_model.dart';

class FirestoreService{
  final FirebaseFirestore _db = FirebaseFirestore.instance;

    Future<void> addTrip(TripModel trip) async{
      await _db.collection('trips').add(trip.toJson());
    }
}