import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class JoinTripDialog extends StatelessWidget {
  final firestoreService;

  JoinTripDialog(this.firestoreService, {super.key});

  final _controller = TextEditingController();

  _joinTrip(context) async {
    if (!(await firestoreService.checkIfExists(_controller.text))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid ID')),
      );
    } else {
      firestoreService.addUserToTrip(
          _controller.text, FirebaseAuth.instance.currentUser!.uid);
      Navigator.pop(context, 'join');
    }
  }

  String? nonEmptyValidator(String? value, context) {
    if (value == null || value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid ID')),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Join Trip'),
      content: TextFormField(
        controller: _controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (text) => text!.isEmpty ? 'Password is required' : null,
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