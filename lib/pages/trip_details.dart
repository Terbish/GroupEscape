import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

import '../util/availability.dart';

class TripDetailsPage extends StatelessWidget {
  final String tripId;
  final String tripName;
  final List<Availability> availability;
  final List<String> locations;

  const TripDetailsPage({
    super.key,
    required this.tripId,
    required this.tripName,
    required this.availability,
    required this.locations,
  });

  @override
  Widget build(BuildContext context) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Trip Name: $tripName'),
            const SizedBox(height: 8.0),
            // Text('Start Date: $startDate'),
            // const SizedBox(height: 8.0),
            // Text('End Date: $endDate'),
            // const SizedBox(height: 8.0),
            Text('Availability:'),
            for (var avail in availability)
              Text('${DateFormat('MM/dd/yyyy').format(avail.startDate.toDate())} - ${DateFormat('MM/dd/yyyy').format(avail.endDate.toDate())}'),
            Text('Location(s): ${locations.join(', ')}'),
            const SizedBox(height: 16.0),

          ],
        ),
      ),
    );
  }
}