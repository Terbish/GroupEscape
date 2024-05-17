import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

import '../util/availability.dart';

class TripDetailsPage extends StatelessWidget {
  final String tripId;
  final String tripName;
  final List<Availability> availability;
  final List<String> locations;
  final db;
  Timestamp? rangeStart;
  Timestamp? rangeEnd;

  TripDetailsPage({
    super.key,
    required this.tripId,
    required this.tripName,
    required this.availability,
    required this.locations,
    required this.db
  });

  bool calculateRange(List<Availability> avails){
    for (int i = 0; i < avails.length; i++) {
      Availability avail = avails[i];
      if (rangeStart == null && rangeEnd == null){
        rangeStart = avail.startDate;
        rangeEnd = avail.endDate;
      } else {
        int startComparison = rangeStart!.compareTo(avail.startDate);
        int endComparison =  rangeEnd!.compareTo(avail.endDate);

        int newEndBeforeStart = rangeStart!.compareTo(avail.endDate);
        int newStartAfterEnd =  rangeEnd!.compareTo(avail.startDate);

        if (newEndBeforeStart > 0 || newStartAfterEnd < 0 ){
          return false;
        }

        if (startComparison <= 0){
          rangeStart = avail.startDate;
        }
        if (endComparison >= 0){
          rangeEnd = avail.endDate;
        }

      }
    }
    return true;
  }





  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double containerHeight = screenHeight * 0.3;

    return Scaffold(
      appBar: AppBar(
          title: Text(
            tripName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 25,
            ),
          ),
          backgroundColor: Colors.blue,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.ios_share),
                onPressed:(){
                  Share.share('Check out this trip: $tripId');
                }
            )
          ]
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Container(
            //   padding: const EdgeInsets.all(10.0),
            //   decoration: BoxDecoration(
            //     color: Colors.blue[100],
            //     borderRadius: BorderRadius.circular(10.0),
            //   ),
            //   child: Text('Trip Name: $tripName'),
            // ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  Text('Member Availabilities:', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  for (var avail in availability)
                    FutureBuilder<String>(
                      future: db.getUserName(avail.userId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text('Loading...'); // Display a loading indicator while waiting
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}'); // Display an error message if an error occurs
                        } else {
                          return Text('${snapshot.data ?? "Unknown User"}: ${DateFormat('MM/dd/yyyy').format(avail.startDate.toDate())} - ${DateFormat('MM/dd/yyyy').format(avail.endDate.toDate())}');
                        }
                      },
                    ),
                  calculateRange(availability)
                    ? Text(
                      "\nAvailable Time-range:\n${DateFormat('MM/dd/yyyy').format(rangeStart!.toDate())} to ${DateFormat('MM/dd/yyyy').format(rangeEnd!.toDate())}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                    : Text(
                      "\nNo overlap in availabilities",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                ],
              )
            ),
            // Text('Start Date: $startDate'),
            // const SizedBox(height: 8.0),
            // Text('End Date: $endDate'),
            // const SizedBox(height: 8.0),
            // Text('Availability:'),
            // for (var avail in availability)
            // // Text('${getUserName(avail.userId)}: ${DateFormat('MM/dd/yyyy').format(avail.startDate.toDate())} - ${DateFormat('MM/dd/yyyy').format(avail.endDate.toDate())}'),
            //   FutureBuilder<String>(
            //     future: db.getUserName(avail.userId),
            //     builder: (context, snapshot) {
            //       if (snapshot.connectionState == ConnectionState.waiting) {
            //         return Text('Loading...'); // Display a loading indicator while waiting
            //       } else if (snapshot.hasError) {
            //         return Text('Error: ${snapshot.error}'); // Display an error message if an error occurs
            //       } else {
            //         return Text('${snapshot.data ?? "Unknown User"}: ${DateFormat('MM/dd/yyyy').format(avail.startDate.toDate())} - ${DateFormat('MM/dd/yyyy').format(avail.endDate.toDate())}');
            //       }
            //     },
            //   ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text('Location(s): ${locations.join(', ')}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

}

