class VehicleCategoryModel {
  bool? status;
  String? message;
  List<VehicleData>? data;

  VehicleCategoryModel({this.status, this.message, this.data});

  VehicleCategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <VehicleData>[];
      json['data'].forEach((v) {
        data!.add(VehicleData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VehicleData {
  int? id;
  String? name;
  String? startingPrice;
  String? ratePerKm;
  int? seatingCapacity;
  String? imageUrl;

  VehicleData({
    this.id,
    this.name,
    this.startingPrice,
    this.ratePerKm,
    this.seatingCapacity,
    this.imageUrl,
  });

  VehicleData.fromJson(Map<String, dynamic> json) {
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
