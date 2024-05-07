
class TripModel{
  final String userId;
  final String tripName;
  final String startDate;
  final String endDate;
  final List<String> locations;

  TripModel({
    required this.userId,
    required this.tripName,
    required this.startDate,
    required this.endDate,
    required this.locations,
  });

  Map<String, dynamic> toJson(){
    return {
      'userId': userId,
      'tripName': tripName,
      'startDate': startDate,
      'endDate': endDate,
      'locations': locations,
    };
  }
}

