import 'package:flutter/material.dart';

class JoinTripDialog extends StatelessWidget {
  const JoinTripDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Join Trip'),
      content:
        const TextField(
          decoration: InputDecoration(
            hintText: 'Enter the trip code',
          ),
        ),
      actions: <Widget>[
        TextButton(
          onPressed: () =>
            Navigator.pop(context, 'cancel'),
    child: const Text('Cancel')
        ),
        TextButton(
          onPressed: () =>
              Navigator.pop(context, 'join'),
          child: const Text('Join'),
        ),
      ],

    );
  }
}