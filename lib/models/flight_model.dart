class FlightInfo {
  final String flightNumber;
  final DateTime date;
  final DateTime scheduledDepartureUtc;
  final DateTime actualDepartureUtc;
  final DateTime scheduledDepartureLocal;
  final DateTime actualDepartureLocal;
  final bool actualDepartureIsEstimated;
  final String departureIcao;
  final String departureIata;
  final String departureName;
  final String departureCity;
  final String departureTerminal;
  final String departureGate;
  final String arrivalIcao;
  final String arrivalIata;
  final String arrivalName;
  final String arrivalCity;
  final String arrivalTerminal;
  final String arrivalGate;
  final DateTime scheduledArrivalUtc;
  final DateTime actualArrivalUtc;
  final DateTime scheduledArrivalLocal;
  final DateTime actualArrivalLocal;
  final bool actualArrivalIsEstimated;
  final String status;
  final String airlineIata;
  final String airlineIcao;
  final String airlineName;

  FlightInfo({
    required this.flightNumber,
    required this.date,
    required this.scheduledDepartureUtc,
    required this.actualDepartureUtc,
    required this.scheduledDepartureLocal,
    required this.actualDepartureLocal,
    required this.actualDepartureIsEstimated,
    required this.departureIcao,
    required this.departureIata,
    required this.departureName,
    required this.departureCity,
    required this.departureTerminal,
    required this.departureGate,
    required this.arrivalIcao,
    required this.arrivalIata,
    required this.arrivalName,
    required this.arrivalCity,
    required this.arrivalTerminal,
    required this.arrivalGate,
    required this.scheduledArrivalUtc,
    required this.actualArrivalUtc,
    required this.scheduledArrivalLocal,
    required this.actualArrivalLocal,
    required this.actualArrivalIsEstimated,
    required this.status,
    required this.airlineIata,
    required this.airlineIcao,
    required this.airlineName,
  });

  factory FlightInfo.fromJson(Map<String, dynamic> json) {
    return FlightInfo(
      flightNumber: json['flnr'],
      date: DateTime.parse(json['date']),
      scheduledDepartureUtc: DateTime.parse(json['scheduled_departure_utc']),
      actualDepartureUtc: DateTime.parse(json['actual_departure_utc']),
      scheduledDepartureLocal: DateTime.parse(json['scheduled_departure_local']),
      actualDepartureLocal: DateTime.parse(json['actual_departure_local']),
      actualDepartureIsEstimated: json['actual_departure_is_estimated'],
      departureIcao: json['departure_icao'],
      departureIata: json['departure_iata'],
      departureName: json['departure_name'],
      departureCity: json['departure_city'],
      departureTerminal: json['departure_terminal'],
      departureGate: json['departure_gate'],
      arrivalIcao: json['arrival_icao'],
      arrivalIata: json['arrival_iata'],
      arrivalName: json['arrival_name'],
      arrivalCity: json['arrival_city'],
      arrivalTerminal: json['arrival_terminal'],
      arrivalGate: json['arrival_gate'],
      scheduledArrivalUtc: DateTime.parse(json['scheduled_arrival_utc']),
      actualArrivalUtc: DateTime.parse(json['actual_arrival_utc']),
      scheduledArrivalLocal: DateTime.parse(json['scheduled_arrival_local']),
      actualArrivalLocal: DateTime.parse(json['actual_arrival_local']),
      actualArrivalIsEstimated: json['actual_arrival_is_estimated'],
      status: json['status'],
      airlineIata: json['airline_iata'],
      airlineIcao: json['airline_icao'],
      airlineName: json['airline_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'flnr': flightNumber,
      'date': date.toIso8601String(),
      'scheduled_departure_utc': scheduledDepartureUtc.toIso8601String(),
      'actual_departure_utc': actualDepartureUtc.toIso8601String(),
      'scheduled_departure_local': scheduledDepartureLocal.toIso8601String(),
      'actual_departure_local': actualDepartureLocal.toIso8601String(),
      'actual_departure_is_estimated': actualDepartureIsEstimated,
      'departure_icao': departureIcao,
      'departure_iata': departureIata,
      'departure_name': departureName,
      'departure_city': departureCity,
      'departure_terminal': departureTerminal,
      'departure_gate': departureGate,
      'arrival_icao': arrivalIcao,
      'arrival_iata': arrivalIata,
      'arrival_name': arrivalName,
      'arrival_city': arrivalCity,
      'arrival_terminal': arrivalTerminal,
      'arrival_gate': arrivalGate,
      'scheduled_arrival_utc': scheduledArrivalUtc.toIso8601String(),
      'actual_arrival_utc': actualArrivalUtc.toIso8601String(),
      'scheduled_arrival_local': scheduledArrivalLocal.toIso8601String(),
      'actual_arrival_local': actualArrivalLocal.toIso8601String(),
      'actual_arrival_is_estimated': actualArrivalIsEstimated,
      'status': status,
      'airline_iata': airlineIata,
      'airline_icao': airlineIcao,
      'airline_name': airlineName,
    };
  }
}
