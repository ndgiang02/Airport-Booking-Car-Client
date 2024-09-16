class TripStop {
  final String tripId;
  final double latitude;
  final double longitude;
  final String location;

  TripStop({
    required this.tripId,
    required this.latitude,
    required this.longitude,
    required this.location,
  });

  factory TripStop.fromJson(Map<String, dynamic> json) {
    return TripStop(
      tripId: json['trip_id'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      location: json['location'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trip_id': tripId,
      'latitude': latitude,
      'longitude': longitude,
      'location': location,
    };
  }
}
