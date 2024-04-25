import "package:flutter/material.dart";

import "create_trip.dart";
import "/widgets/join_trip_dialog.dart";

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: const Text('Your Trips'),
      actions: [
        PopupMenuButton(
          child: const Icon(Icons.add),
          onSelected: (result) {
            if (result == 'Create Trip') {
              Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CreateTrip(),
              ),);
            } else if (result == 'Join Trip') {
              showDialog(
                context: context,
                builder: (context) => const JoinTripDialog(),
              );
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem(
              value: 'Create Trip',
              child: Text('Create Trip', style: TextStyle(fontSize: 15)),
            ),
            const PopupMenuItem(
                value: 'Join Trip',
                child: Text('Join Trip', style: TextStyle(fontSize: 15)))
          ],
        ),
      ],
    ));
  }
}
