import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

import '../util/availability.dart';

class TripDetailsPage extends StatefulWidget {
  final String tripId;
  final String tripName;
  final List<Availability> availability;
  final List<String> locations;
  final db;
  Timestamp? rangeStart;
  Timestamp? rangeEnd;
  final bool isCreator;

  TripDetailsPage({
    super.key,
    required this.tripId,
    required this.tripName,
    required this.availability,
    required this.locations,
    required this.db,
    required this.isCreator,
  });

  @override
  _TripDetailsPageState createState() => _TripDetailsPageState();
}

class _TripDetailsPageState extends State<TripDetailsPage> {
  String? selectedLocation;
  bool showVotingResult = false;
  bool hasVoted = false;

  bool calculateRange(List<Availability> avails) {
    for (int i = 0; i < avails.length; i++) {
      Availability avail = avails[i];
      if (widget.rangeStart == null && widget.rangeEnd == null) {
        widget.rangeStart = avail.startDate;
        widget.rangeEnd = avail.endDate;
      } else {
        int startComparison = widget.rangeStart!.compareTo(avail.startDate);
        int endComparison = widget.rangeEnd!.compareTo(avail.endDate);

        int newEndBeforeStart = widget.rangeStart!.compareTo(avail.endDate);
        int newStartAfterEnd = widget.rangeEnd!.compareTo(avail.startDate);

        if (newEndBeforeStart > 0 || newStartAfterEnd < 0) {
          return false;
        }

        if (startComparison <= 0) {
          widget.rangeStart = avail.startDate;
        }
        if (endComparison >= 0) {
          widget.rangeEnd = avail.endDate;
        }
      }
    }
    return true;
  }

  void voteForLocation(String location) {
    widget.db.voteForLocation(widget.tripId, location);
  }

  void submitVote() {
    if (selectedLocation != null && !hasVoted) {
      voteForLocation(selectedLocation!);
      setState(() {
        hasVoted = true;
      });
    }
  }

  void endVoting() {
    widget.db.endLocationVoting(widget.tripId).then((_) {
      setState(() {
        showVotingResult = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double containerHeight = screenHeight * 0.3;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.tripName,
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
            onPressed: () {
              Share.share('Check out this trip: ${widget.tripId}');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                   Text('Member Availabilities:',
                      style:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  for (var avail in widget.availability)
                    FutureBuilder<String>(
                      future: widget.db.getUserName(avail.userId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text(
                              'Loading...');
                        } else if (snapshot.hasError) {
                          return Text(
                              'Error: ${snapshot.error}');
                        } else {
                          return Text(
                              '${snapshot.data ?? "Unknown User"}: ${DateFormat('MM/dd/yyyy').format(avail.startDate.toDate())} - ${DateFormat('MM/dd/yyyy').format(avail.endDate.toDate())}');
                        }
                      },
                    ),
                  calculateRange(widget.availability)
                      ? Text(
                    "\nAvailable Time-range:\n${DateFormat('MM/dd/yyyy').format(widget.rangeStart!.toDate())} to ${DateFormat('MM/dd/yyyy').format(widget.rangeEnd!.toDate())}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                      : Text(
                    "\nNo overlap in availabilities",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!showVotingResult)
                    Text('Location(s):',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  if (!showVotingResult) const SizedBox(height: 8.0),
                  if (!showVotingResult)
                    for (var location in widget.locations)
                      RadioListTile(
                        title: Text(location),
                        value: location,
                        groupValue: selectedLocation,
                        onChanged: hasVoted
                            ? null
                            : (value) {
                          setState(() {
                            selectedLocation = value as String?;
                          });
                        },
                      ),
                  if (!showVotingResult && !hasVoted)
                    ElevatedButton(
                      onPressed: submitVote,
                      child: Text('Submit Vote'),
                    ),
                  if (hasVoted)
                    Text(
                      'You have already voted.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  if (widget.isCreator && !showVotingResult)
                    ElevatedButton(
                      onPressed: endVoting,
                      child: Text('End Voting'),
                    ),
                  if (showVotingResult)
                    FutureBuilder<String>(
                      future: widget.db.getFinalLocation(widget.tripId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Text(
                            'Final Location: ${snapshot.data}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          );
                        }
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}