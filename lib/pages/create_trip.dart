import 'package:flutter/material.dart';

class CreateTrip extends StatelessWidget {
  const CreateTrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Trip'),
      ),
      body: const Center(
        child: Text('Create Trip'),
      ),
    );
  }
}
