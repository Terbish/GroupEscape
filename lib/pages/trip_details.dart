import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

import '../util/availability.dart';

class TripDetailsPage extends StatelessWidget {
  final String tripId;
  final String tripName;
  final List<Availability> availability;
  final List<String> locations;
  final List<String> members;
  final db;

  const TripDetailsPage({
    super.key,
    required this.tripId,
    required this.tripName,
    required this.availability,
    required this.locations,
    required this.members,
    required this.db,
  });

  @override
  Widget build(BuildContext context) {
    final startDate = availability.first.startDate.toDate();
    final endDate = availability.first.endDate.toDate();
    final memberCount = members.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tripName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 28,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.ios_share),
            //color: Colors.white, TO DO: decide on button coloring
            onPressed: () {
              Share.share('Check out this trip: $tripId');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                locations.first,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 16.0),
              Text(
                memberCount == 0 ? '1 Person' : '$memberCount People',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  const Icon(Icons.calendar_month, size: 32),
                  const SizedBox(width: 8.0),
                  Text(
                    '${DateFormat('MM/dd/yyyy').format(startDate)} - ${DateFormat('MM/dd/yyyy').format(endDate)}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
              const SizedBox(height: 32.0),
              _buildCard(
                context,
                'Members',
                    () {
                  // Navigate to members screen
                      // ADD ON PRESSED
                },
              ),
              const SizedBox(height: 16.0),
              _buildCard(
                context,
                'Availability',
                    () {
                  // Navigate to availability screen
                      // ADD ON PRESSED
                },
              ),
              const SizedBox(height: 16.0),
              _buildCard(
                context,
                'Locations',
                    () {
                  // Navigate to locations screen
                      // ADD ON PRESSED
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, VoidCallback onTap) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ),
    );
  }
}