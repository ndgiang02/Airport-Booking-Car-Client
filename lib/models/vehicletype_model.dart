class VehicleCategoryModel1 {
  bool? success;
  String? error;
  String? message;
  List<VehicleData1>? data;

  VehicleCategoryModel1({this.success, this.error, this.message, this.data});

  VehicleCategoryModel1.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <VehicleData1>[];
      json['data'].forEach((v) {
        data!.add(VehicleData1.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VehicleData1 {
  int? id;
  String? name;
  String? startingPrice;
  String? ratePerKm;
  int? seatingCapacity;
  String? imageUrl;

  VehicleData1({
    this.id,
    this.name,
    this.startingPrice,
    this.ratePerKm,
    this.seatingCapacity,
    this.imageUrl,
  });

  VehicleData1.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    name = json['name'].toString();
    startingPrice = json['starting_price'].toString();
    ratePerKm = json['rate_per_km'].toString();
    seatingCapacity = int.parse(json['seating_capacity'].toString());
    imageUrl = json['image_url'] != null ? json['image_url'].toString() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['starting_price'] = startingPrice;
    data['rate_per_km'] = ratePerKm;
    data['seating_capacity'] = seatingCapacity;
    data['image_url'] = imageUrl;
    return data;
  }
}
