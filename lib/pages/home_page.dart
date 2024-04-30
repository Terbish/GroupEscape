import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'trip_details.dart';
import "../model/user_model.dart";
import "create_trip.dart";
import "/widgets/join_trip_dialog.dart";

class HomePage extends StatelessWidget {
  final void Function() logOut;
  final User? currentUser;
  const HomePage({super.key, required this.logOut, required this.currentUser});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Trips'),
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
                    builder: (context) => const JoinTripDialog(),
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
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return ListTile(
                title: Text(doc['tripName']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TripDetailsPage(
                        tripId: doc.id,
                        tripName: doc['tripName'],
                        startDate: doc['startDate'],
                        endDate: doc['endDate'],
                        locations: List<String>.from(doc['locations']),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}