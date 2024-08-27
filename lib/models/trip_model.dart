class Trip {
  final String id;
  final String type;
  final DateTime startDate;
  final DateTime endDate;
  final String departureLocation;
  final String destinationLocation;
  final double distance;
  final bool isCompleted;

  Trip({
    required this.id,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.departureLocation,
    required this.destinationLocation,
    required this.distance,
    required this.isCompleted,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'] as String,
      type: json['type'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      departureLocation: json['departureLocation'] as String,
      destinationLocation: json['destinationLocation'] as String,
      distance: (json['distance'] as num).toDouble(),
      isCompleted: json['isCompleted'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'departureLocation': departureLocation,
      'destinationLocation': destinationLocation,
      'distance': distance,
      'isCompleted': isCompleted,
    };
  }
}
