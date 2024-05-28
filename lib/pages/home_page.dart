import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_escape/services/firestore_service.dart';
import 'package:group_escape/shared/firebase_authentication.dart';
import '../util/availability.dart';
import 'create_trip.dart';
import '/widgets/join_trip_dialog.dart';
import 'trip_details.dart';

class HomePage extends StatelessWidget {
  final void Function() logOut;
  final FirebaseAuthentication authInstance;
  final FirestoreService _firestoreService;

  HomePage(this.authInstance, {super.key, required this.logOut, FirestoreService? fS}):
        _firestoreService = fS ?? FirestoreService();

  Future<void> _showAvailabilityDialog(BuildContext context, String tripId) async {
    final DateTimeRange? dateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (dateRange == null) return;

    final availability = Availability(
      userId: authInstance.currentUser(),
      startDate: Timestamp.fromDate(dateRange.start),
      endDate: Timestamp.fromDate(dateRange.end),
    );

    await _firestoreService.addAvailability(tripId, availability);
  }

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
          _buildPopupMenuButton(context),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logOut,
          ),
        ],
      ),
      body: _buildTripsStreamBuilder(),
    );
  }

  Widget _buildPopupMenuButton(BuildContext context) {
    return PopupMenuButton(
      child: const Icon(Icons.add),
      onSelected: (result) async {
        if (result == 'Create Trip') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreateTrip(authInstance),
            ),
          );
        } else if (result == 'Join Trip') {
          final result = await showDialog(
            context: context,
            builder: (context) => JoinTripDialog(_firestoreService, authInstance),
          );
          if (result != null && result != 'cancel') {
            await _showAvailabilityDialog(context, result);
          }
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem(
          value: 'Create Trip',
          child: Text('Create Trip', style: TextStyle(fontSize: 15)),
        ),
        const PopupMenuItem(
          value: 'Join Trip',
          child: Text('Join Trip', style: TextStyle(fontSize: 15)),
        ),
      ],
    );
  }

  Widget _buildTripsStreamBuilder() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _firestoreService.getTripsStream(authInstance.currentUser()),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            color: Colors.blue,
          );
        }

        return _buildTripsList(context, snapshot.data!);
      },
    );
  }

  Widget _buildTripsList(BuildContext context, List<Map<String, dynamic>> trips) {
    return ListView(
      children: trips.map((doc) {
        final isCreator = doc['userId'][0] == authInstance.currentUser();
        return Card(
          child: ListTile(
            title: Text(
              doc['tripName'],
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_sharp),
              onPressed: () => _firestoreService.deleteTrip(
                  doc['tripId'], authInstance.currentUser()),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TripDetailsPage(
                    tripId: doc['tripId'],
                    tripName: doc['tripName'],
                    availability: List<Availability>.from(
                        doc['availability'].map((e) => Availability(
                          userId: e['userID'],
                          startDate: e['startDate'],
                          endDate: e['endDate'],
                        ))),
                    locations: List<String>.from(doc['locations']),
                    db: _firestoreService,
                    isCreator: isCreator, userId: authInstance.currentUser(),
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}