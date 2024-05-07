import 'package:group_escape/util/availability.dart';

class AvailabilityModel{
  final String userId;
  final String tripId;
  final List<Availability> availability;

  AvailabilityModel({
    required this.userId,
    required this.tripId,
    required this.availability
  });

  Map<String, dynamic> toJson(){
    return {
      'userId': userId,
      'tripId': tripId,
      'availability': availability.map((e) => e.toJson()).toList(),
    };
  }
}