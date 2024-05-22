import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_escape/services/firestore_service.dart';
import 'package:group_escape/util/availability.dart';

import '../shared/firebase_authentication.dart';

class JoinTripDialog extends StatelessWidget {
  final FirestoreService firestoreService;
  final FirebaseAuthentication authInstance;
  JoinTripDialog(this.firestoreService, this.authInstance, {super.key});

  final _controller = TextEditingController();

  _joinTrip(context) async {
    if (!(await firestoreService.checkIfExists(_controller.text))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid ID')),
      );
    } else {
      await firestoreService.addUserToTrip(
          _controller.text, authInstance.currentUser());
      await firestoreService.sendNotification(topic: _controller.text);
      await firestoreService.subscribeToTopic(_controller.text);
      Navigator.pop(context, _controller.text);
    }
  }

  // String? nonEmptyValidator(String? value, context) {
  //   if (value == null || value.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Invalid ID')),
  //     );
  //   }
  //   return null;
  // }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Join Trip'),
      content: TextFormField(
        controller: _controller,
        autovalidateMode: AutovalidateMode.always,
        validator: (text) => text!.isEmpty ? 'ID is required' : null,
        decoration: const InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
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