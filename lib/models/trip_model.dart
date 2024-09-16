class TripModel {
  TripModel({
    this.status,
    this.error,
    this.message,
    this.data,
  });

  bool? status;
  String? error;
  String? message;
  Trip? data;

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      status: json['status'] as bool?,
      error: json['error']?.toString(),
      message: json['message']?.toString(),
      data: json['data'] != null ? Trip.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'error': error,
    'message': message,
    'data': data?.toJson(),
  };
}

class Trip {
  String? id;
  String? driverId;
  String? customerId;
  String? fromAddress;
  double? fromLat;
  double? fromLng;
  String? toAddress;
  double? toLat;
  double? toLng;
  DateTime? scheduledTime;
  DateTime? fromTime;
  DateTime? toTime;
  DateTime? returnTime;
  bool? roundTrip;
  double? km;
  double? totalAmount;
  String? payment;
  String? tripStatus;
  String? tripType;

  Trip({
    this.id,
    this.driverId,
    this.customerId,
    this.fromAddress,
    this.fromLat,
    this.fromLng,
    this.toAddress,
    this.toLat,
    this.toLng,
    this.scheduledTime,
    this.fromTime,
    this.toTime,
    this.returnTime,
    this.roundTrip,
    this.km,
    this.totalAmount,
    this.payment,
    this.tripStatus,
    this.tripType,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id']?.toString(),
      driverId: json['driver_id']?.toString(),
      customerId: json['customer_id']?.toString(),
      fromAddress: json['from_address']?.toString(),
      fromLat: json['from_lat'] != null ? double.tryParse(json['from_lat'].toString()) : null,
      fromLng: json['from_lng'] != null ? double.tryParse(json['from_lng'].toString()) : null,
      toAddress: json['to_address']?.toString(),
      toLat: json['to_lat'] != null ? double.tryParse(json['to_lat'].toString()) : null,
      toLng: json['to_lng'] != null ? double.tryParse(json['to_lng'].toString()) : null,
      scheduledTime: json['scheduled_time'] != null
          ? DateTime.parse(json['scheduled_time']).toLocal()
          : null,
      fromTime: json['from_time'] != null ? DateTime.tryParse(json['from_time']) : null,
      toTime: json['to_time'] != null ? DateTime.tryParse(json['to_time']) : null,
      returnTime: json['return_time'] != null ? DateTime.tryParse(json['return_time']) : null,
      roundTrip: json['round_trip'] == 1,
      km: json['km'] != null ? double.tryParse(json['km'].toString()) : null,
      totalAmount: json['total_amount'] != null ? double.tryParse(json['total_amount'].toString()) : null,
      payment: json['payment']?.toString(),
      tripStatus: json['trip_status']?.toString(),
      tripType: json['trip_type']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driver_id': driverId,
      'customer_id': customerId,
      'from_address': fromAddress,
      'from_lat': fromLat,
      'from_lng': fromLng,
      'to_address': toAddress,
      'to_lat': toLat,
      'to_lng': toLng,
      'scheduled_time': scheduledTime?.toIso8601String(),
      'from_time': fromTime?.toIso8601String(),
      'to_time': toTime?.toIso8601String(),
      'return_time': returnTime?.toIso8601String(),
      'round_trip': roundTrip,
      'km': km,
      'total_amount': totalAmount,
      'payment': payment,
      'trip_status': tripStatus,
      'trip_type': tripType,
    };
  }
}

class Stop {
  double? latitude;
  double? longitude;
  String? location;

  Stop({
    this.latitude,
    this.longitude,
    this.location,
  });

  factory Stop.fromJson(Map<String, dynamic> json) {
    return Stop(
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
      location: json['location']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'location': location,
    };
  }
}
