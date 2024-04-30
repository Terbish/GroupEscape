import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateTrip extends StatefulWidget {
  const CreateTrip({super.key});

  @override
  _CreateTripState createState() => _CreateTripState();
}
class _CreateTripState extends State<CreateTrip> {
  final _formKey = GlobalKey<FormState>();
  String _tripName = '';
  String _startDate = '';
  String _endDate = '';
  List<String> _locations = [];

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Get currently logged-in user's UID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Create a new document in the "trips" collection with the user's UID
      await FirebaseFirestore.instance.collection('trips').add({
        'userId': userId,
        'tripName': _tripName,
        'startDate': _startDate,
        'endDate': _endDate,
        'locations': _locations,
      });

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
              TextFormField(
                decoration: const InputDecoration(labelText: 'Start Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a start date';
                  }
                  return null;
                },
                onSaved: (value) {
                  _startDate = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'End Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an end date';
                  }
                  return null;
                },
                onSaved: (value) {
                  _endDate = value!;
                },
              ),
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