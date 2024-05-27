import 'package:flutter/material.dart';
import 'package:group_escape/services/firestore_service.dart';
import '../shared/firebase_authentication.dart';

class JoinTripDialog extends StatefulWidget {
  final FirestoreService firestoreService;
  final FirebaseAuthentication authInstance;
  JoinTripDialog(this.firestoreService, this.authInstance, {super.key});

  @override
  _JoinTripDialogState createState() => _JoinTripDialogState();
}

class _JoinTripDialogState extends State<JoinTripDialog> {
  final _controller = TextEditingController();
  final _locationController = TextEditingController();

  _joinTrip(context) async {
    if (!(await widget.firestoreService.checkIfExists(_controller.text))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid ID')),
      );
    } else {
      await widget.firestoreService.addUserToTrip(
          _controller.text, widget.authInstance.currentUser());
      await widget.firestoreService.sendNotification(topic: _controller.text);
      await widget.firestoreService.subscribeToTopic(_controller.text);

      if (_locationController.text.isNotEmpty) {
        final locations = _locationController.text
            .split(',')
            .map((location) => location.trim())
            .toList();
        for (final location in locations) {
          await widget.firestoreService.addLocationToTrip(
              _controller.text, location);
        }
      }

      Navigator.pop(context, _controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Join Trip'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _controller,
            autovalidateMode: AutovalidateMode.always,
            validator: (text) => text!.isEmpty ? 'ID is required' : null,
            decoration: const InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'Where do you want to go?',
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'cancel'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue,
          ),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            _joinTrip(context);
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue,
          ),
          child: const Text('Join'),
        ),
      ],
    );
  }
}