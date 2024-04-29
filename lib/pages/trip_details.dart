import 'package:flutter/material.dart';

class TripDetailsPage extends StatelessWidget {
  final String tripId;
  final String tripName;
  final String startDate;
  final String endDate;
  final List<String> locations;

  const TripDetailsPage({
    super.key,
    required this.tripId,
    required this.tripName,
    required this.startDate,
    required this.endDate,
    required this.locations,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tripName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Trip Name: $tripName'),
            const SizedBox(height: 8.0),
            Text('Start Date: $startDate'),
            const SizedBox(height: 8.0),
            Text('End Date: $endDate'),
            const SizedBox(height: 8.0),
            Text('Location(s): ${locations.join(', ')}'),
          ],
        ),
      ),
    );
  }
}