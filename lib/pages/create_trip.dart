import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_escape/shared/firebase_authentication.dart';
import 'package:group_escape/util/availability.dart';
import 'package:intl/intl.dart';

import '../models/trip_model.dart';
import '../services/firestore_service.dart';

class CreateTrip extends StatefulWidget {
  final FirebaseAuthentication authInstance;
  final FirestoreService firestoreService;
  CreateTrip(this.authInstance, {super.key, FirestoreService? fS}):
        firestoreService = fS ?? FirestoreService();

  @override
  _CreateTripState createState() => _CreateTripState();
}

class _CreateTripState extends State<CreateTrip> {
  final _formKey = GlobalKey<FormState>();

  String _tripName = '';
  List<String> _locations = [];
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  bool selectedTime = false;

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
        selectedTime = true;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      List<String> userIds = [widget.authInstance.currentUser()];

      Availability availability = Availability(
        userId: widget.authInstance.currentUser(),
        startDate: Timestamp.fromDate(_startDate),
        endDate: Timestamp.fromDate(_endDate),
      );

      TripModel tripModel = TripModel(
        userIds: userIds,
        tripName: _tripName,
        locations: _locations,
        availability: [availability],
      );

      String tripId = await widget.firestoreService.addTrip(tripModel);
      await widget.firestoreService.subscribeToTopic(tripId);

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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTripNameField(),
              _buildLocationsField(),
              const SizedBox(height: 24.0),
              _buildDateRangeButton(context),
              const SizedBox(height: 16.0),
              if (selectedTime) _buildSelectedDatesText(),
              const SizedBox(height: 16.0),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTripNameField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Trip Name',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a trip name';
        }
        return null;
      },
      onSaved: (value) {
        _tripName = value!;
      },
    );
  }

  Widget _buildLocationsField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Locations',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter at least one location';
        }
        return null;
      },
      onSaved: (value) {
        _locations = value!.split(',');
      },
    );
  }

  Widget _buildDateRangeButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48.0,
      child: ElevatedButton(
        onPressed: () => _showDateRangePicker(context),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: const Text(
          'Add Dates',
          style: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildSelectedDatesText() {
    return Text(
      'Selected Dates:\n${DateFormat('MM/dd/yyyy').format(_startDate!)} to ${DateFormat('MM/dd/yyyy').format(_endDate!)}',
      style: TextStyle(fontSize: 16.0),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 48.0,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: const Text(
          'Create Trip',
          style: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }
}