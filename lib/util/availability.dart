import 'package:cloud_firestore/cloud_firestore.dart';

class Availability {
  final String userId;
  final Timestamp startDate;
  final Timestamp endDate;

  Availability({
    required this.startDate,
    required this.endDate,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'userID': userId,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}