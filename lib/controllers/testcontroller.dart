import 'dart:async';
import 'dart:convert';

import 'package:customerapp/service/fakeapi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:vietmap_flutter_plugin/vietmap_flutter_plugin.dart';

import '../constant/constant.dart';
import '../models/vehicle_model.dart';

class TC extends GetxController {
  var isLoading = true.obs;
  RxString selectedVehicle = "".obs;
  RxString tripOptionCategory = "General".obs;
  RxDouble distance = 0.0.obs;
  RxDouble duration = 0.0.obs;
  var pickupLatLong = Rxn<LatLng>();
  var destinationLatLong = Rxn<LatLng>();
  var suggestions = <dynamic>[].obs;
  Location location = Location();
  var polylinePoints = <LatLng>[].obs;
  List<LatLng> points = [];
  var isMapDrawn = false.obs;
  late VehicleData? vehicleData;
  var isRoundTrip = false.obs;
  var startDateTime = Rx<DateTime?>(null);
  var returnDateTime = Rx<DateTime?>(null);
  Map<String, Symbol> symbols = {};
  var stopoverControllers = <TextEditingController>[].obs;
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController passengerController = TextEditingController();

  var pickupText = ''.obs;
  var destinationText = ''.obs;
  var passengerText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    pickupController.addListener(() {
      pickupText.value = pickupController.text;
    });

    destinationController.addListener(() {
      destinationText.value = destinationController.text;
    });

    passengerController.addListener(() {
      passengerText.value = passengerController.text;
    });
  }

  @override
  void onClose() {
    pickupController.dispose();
    destinationController.dispose();
    passengerController.dispose();
    super.onClose();
  }

  void clearData() {
    selectedVehicle.value = "";
    tripOptionCategory = "General".obs;
    distance = 0.0.obs;
    duration = 0.0.obs;
    isMapDrawn.value = false;
  }

  var textStatus = ''.obs;

  void addStopover() {
    var controller = TextEditingController();
    controller.addListener(() {
      textStatus.value = controller.text;
    });
    stopoverControllers.add(controller);
  }

  void removeStopover(int index) {
    stopoverControllers[index].dispose();
    stopoverControllers.removeAt(index);
    if (stopoverControllers.isEmpty) {
      textStatus.value = '';
    }
  }

  void clearText(int index) {
    stopoverControllers[index].clear();
    textStatus.value = '';
  }


  /////////////////////////////////

  void setRoundTrip(bool value) {
    isRoundTrip.value = value;
  }

  void setStartDateTime(DateTime? dateTime) {
    startDateTime.value = dateTime;
  }

  void setReturnDateTime(DateTime? dateTime) {
    returnDateTime.value = dateTime;
  }

  Future<void> setPickUpMarker(
      LatLng pickup, VietmapController? mapController) async {
    pickupLatLong.value = pickup;

    if (points.isNotEmpty) {
      points[0] = pickupLatLong.value!;
    } else {
      points.insert(0, pickupLatLong.value!);
    }

    await mapController?.addSymbol(
      SymbolOptions(
        geometry: pickup,
        iconImage: ic_pickup,
        iconSize: 1.5,
      ),
    );

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(pickup.latitude, pickup.longitude),
        zoom: 14,
      )),
    );
    await fetchRouteData();
    addPolyline(mapController);
  }

  Future<void> setDestinationMaker(
      LatLng destination, VietmapController? mapController) async {
    destinationLatLong.value = destination;
    if (points.length >= 2) {
      points[1] = destinationLatLong.value!;
    } else {
      points.add(destinationLatLong.value!);
    }

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(destination.latitude, destination.longitude),
        zoom: 14,
      )),
    );
    await fetchRouteData();
    addPolyline(mapController);

    if (pickupLatLong.value != null && destinationLatLong.value != null) {
      isMapDrawn.value = true;
    }
    for (var point in points) {
      debugPrint('Lat: ${point.latitude}, Lng: ${point.longitude}');
    }
  }

  Future<Map<String, dynamic>?> getCurrentLocation(
      VietmapController mapController) async {
    try {
      LocationData position = await location.getLocation();
      pickupLatLong.value = LatLng(position.latitude!, position.longitude!);
      setPickUpMarker(pickupLatLong.value!, mapController);
      final result = await Vietmap.reverse(
          LatLng(position.latitude!, position.longitude!));
      return result.fold(
            (failure) {
          debugPrint('Error: $failure');
          return null;
        },
            (VietmapReverseModel) {
          return {
            'lat': VietmapReverseModel.lat.toString(),
            'lng': VietmapReverseModel.lng.toString(),
            'display': VietmapReverseModel.display ?? '',
          };
        },
      );
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  Future<LatLng?> reverseGeocode(String refId) async {
    final url =
        '${Constant.baseUrl}/place/v3?apikey=${Constant.VietMapApiKey}&refid=$refId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data != null && data['lat'] != null && data['lng'] != null) {
          double lat = data['lat'];
          double lng = data['lng'];
          return LatLng(lat, lng);
        }
      } else {
        debugPrint('Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return null;
  }

  Future<List<Map<String, String>>> getAutocompleteData(String value) async {
    final result = await Vietmap.autocomplete(
        VietMapAutoCompleteParams(textSearch: value));
    return result.fold(
          (failure) {
        debugPrint('Error: $failure');
        return [];
      },
          (autocompleteList) {
        var resultList = <Map<String, String>>[];
        for (var item in autocompleteList) {
          final refId = item.refId ?? '';
          final display = item.display ?? '';

          resultList.add({
            'ref_id': refId,
            'display': display,
          });
        }
        suggestions.value =
            resultList.where((item) => item['ref_id']!.isNotEmpty).toList();
        return resultList;
      },
    );
  }

  ///Route

  Future<void> fetchRouteData() async {
    final url = Uri.parse(
        '${Constant.baseUrl}/route?api-version=1.1&apikey=${Constant.VietMapApiKey}&point=${points.map((p) => '${p.latitude},${p.longitude}').join('&point=')}&points_encoded=true&vehicle=car');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final paths = data['paths'] as List<dynamic>;
        if (paths.isNotEmpty) {
          final firstPath = paths[0];

          final encodedPolyline = firstPath['points'];
          polylinePoints.value = decodePolyline(encodedPolyline);

          final distanceInMeters = (firstPath['distance'] as num).toDouble();
          final timeInMillis = (firstPath['time'] as num).toInt();

          distance.value = distanceInMeters / 1000.0;
          duration.value = timeInMillis / 60000.0;

          debugPrint("Distance: ${distance.value} km");
          debugPrint("Duration: ${duration.value} minutes");
        } else {
          throw Exception('No paths found in the response');
        }
      } else {
        throw Exception('Failed to load route data');
      }
    } catch (e) {
      print('Error fetching route data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;
      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      points.add(LatLng(
        (lat / 1E5).toDouble(),
        (lng / 1E5).toDouble(),
      ));
    }
    return points;
  }

  Future<void> addPolyline(VietmapController? mapController) async {

    if (mapController != null && polylinePoints.isNotEmpty) {
      await mapController.addPolyline(
        PolylineOptions(
          geometry: polylinePoints,
          polylineColor: Colors.blue,
          polylineWidth: 5.0,
        ),
      );

      await mapController.addSymbol(
        SymbolOptions(
          geometry: polylinePoints.first,
          iconImage: ic_pickup,
          iconSize: 1.5,
        ),
      );

      await mapController.addSymbol(
        SymbolOptions(
          geometry: polylinePoints.last,
          iconImage: ic_dropoff,
          iconSize: 1.5,
        ),
      );

      double? minLat, minLng, maxLat, maxLng;

      for (var point in polylinePoints) {
        if (minLat == null || point.latitude < minLat) {
          minLat = point.latitude;
        }
        if (minLng == null || point.longitude < minLng) {
          minLng = point.longitude;
        }
        if (maxLat == null || point.latitude > maxLat) {
          maxLat = point.latitude;
        }
        if (maxLng == null || point.longitude > maxLng) {
          maxLng = point.longitude;
        }
      }

      final bounds = LatLngBounds(
        southwest: LatLng(minLat!, minLng!),
        northeast: LatLng(maxLat!, maxLng!),
      );

      await mapController.setCameraBounds(
          west: minLng, // minLng
          north: maxLat, // maxLat
          south: minLat, // minLat
          east: maxLng, // maxLng
          padding: 100);

      await mapController.animateCamera(
        CameraUpdate.newLatLngBounds(bounds),
      );
    }
  }

  // getVehicle
  Future<VehicleCategoryModel> getVehicleCategoryModel() async {
    final jsonString = await FakeAPI.fetchVehicleCategoryData();
    final jsonMap = json.decode(jsonString);
    return VehicleCategoryModel.fromJson(jsonMap);
  }

/*  Future<VehicleCategoryModel?> getVehicleCategory() async {
    try {
      ShowDialog.showLoader("Please wait");
      final response = await http.get(Uri.parse(API.getVehicleCategory), headers: API.header);
      log(response.body);
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        update();
        ShowDialog.closeLoader();
        return VehicleCategoryModel.fromJson(responseBody);
      } else {
        ShowDialog.closeLoader();
        ShowDialog.showToast('Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowDialog.closeLoader();
      ShowDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowDialog.closeLoader();
      ShowDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowDialog.closeLoader();
      ShowDialog.showToast(e.toString());
    } catch (e) {
      ShowDialog.closeLoader();
      ShowDialog.showToast(e.toString());
    }
    return null;
  }*/

  double calculateTripPrice(
      {required double distance,
        required double minimumDeliveryChargesWithin,
        required double minimumDeliveryCharges,
        required double deliveryCharges}) {
    double cout = 0.0;

    if (distance > minimumDeliveryChargesWithin) {
      cout = (distance * deliveryCharges).toDouble();
    } else {
      cout = minimumDeliveryCharges;
    }
    return cout;
  }
}
