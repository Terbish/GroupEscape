import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_escape/models/availability_model.dart';
import 'package:group_escape/util/availability.dart';

import '../models/trip_model.dart';
import '../services/firestore_service.dart';

class CreateTrip extends StatefulWidget {
  const CreateTrip({super.key});

  @override
  _CreateTripState createState() => _CreateTripState();
}
class _CreateTripState extends State<CreateTrip> {
  final _formKey = GlobalKey<FormState>();
  final _firestoreService = FirestoreService();
  String _tripName = '';
  // String _startDate = '';
  // String _endDate = '';
  List<String> _locations = [];
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  void _showDateRangePicker(BuildContext context) async{
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 180)),
    );
    if(picked != null){
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Get currently logged-in user's UID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Create a new TripModel object
      TripModel tripModel = TripModel(
        userId: userId,
        tripName: _tripName,
        startDate: _startDate.toString(),
        endDate: _endDate.toString(),
        locations: _locations,
      );

      String tripId = await _firestoreService.addTrip(tripModel);

      Availability availability = Availability(
        startDate: Timestamp.fromDate(_startDate),
        endDate: Timestamp.fromDate(_endDate),
      );

      AvailabilityModel availabilityModel = AvailabilityModel(
        userId: userId,
        tripId: tripId,
        availability: [availability],
      );

      await _firestoreService.addAvailability(tripId, userId, availabilityModel.toJson());
      // Navigate back to the home page
      Navigator.pop(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Create Trip',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Trip Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a trip name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _tripName = value!;
                },
              ),
              // TextFormField(
              //   decoration: const InputDecoration(labelText: 'Start Date'),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter a start date';
              //     }
              //     return null;
              //   },
              //   onSaved: (value) {
              //     _startDate = value! as DateTime;
              //   },
              // ),
              // TextFormField(
              //   decoration: const InputDecoration(labelText: 'End Date'),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter an end date';
              //     }
              //     return null;
              //   },
              //   onSaved: (value) {
              //     _endDate = value! as DateTime;
              //   },
              // ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Locations'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter at least one location';
                  }
                  return null;
                },
                onSaved: (value) {
                  _locations = value!.split(',');
                },
              ),
              ElevatedButton(
                onPressed: () => _showDateRangePicker(context),
                child: const Text('Select Date Range'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Create Trip'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}