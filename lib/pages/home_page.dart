import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_escape/services/firestore_service.dart';
import '../util/availability.dart';
import 'create_trip.dart';
import '/widgets/join_trip_dialog.dart';
import 'trip_details.dart';


class HomePage extends StatelessWidget {
  final void Function() logOut;
  final FirestoreService _firestoreService = FirestoreService();

  HomePage({super.key, required this.logOut});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
              'My Trips',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 25,
            ),
          ),
          backgroundColor: Colors.blue,
          actions: [
            PopupMenuButton(
              child: const Icon(Icons.add),
              onSelected: (result) {
                if (result == 'Create Trip') {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CreateTrip(),
                    ),);
                } else if (result == 'Join Trip') {
                  showDialog(
                    context: context,
                    builder: (context) => JoinTripDialog(_firestoreService),
                  );
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem(
                  value: 'Create Trip',
                  child: Text('Create Trip', style: TextStyle(fontSize: 15)),
                ),
                const PopupMenuItem(
                    value: 'Join Trip',
                    child: Text('Join Trip', style: TextStyle(fontSize: 15)))
              ],
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: logOut,
            ),
          ],
        ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('trips')
            .where('userId', arrayContains: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(color: Colors.blue,);
          }
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return Card(
                child: ListTile(
                  title: Text(
                    doc['tripName'],
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_sharp),
                    onPressed: () => _firestoreService.deleteTrip(doc.id),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TripDetailsPage(
                          tripId: doc.id,
                          tripName: doc['tripName'],
                          availability: List<Availability>.from(doc['availability'].map((e) => Availability(
                            userId: e['userID'],
                            startDate: e['startDate'],
                            endDate: e['endDate'],
                          ))),
                          locations: List<String>.from(doc['locations']),
                          db: _firestoreService, members: [],
                        ),
                      ),
                    );
                  },
                )
              );
            }).toList(),
          );
        },
      ),
    );
  }
}