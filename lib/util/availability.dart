import 'package:cloud_firestore/cloud_firestore.dart';

class Availability {
  final Timestamp startDate;
  final Timestamp endDate;

  Availability({
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}