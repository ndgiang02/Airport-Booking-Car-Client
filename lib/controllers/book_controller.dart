import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:vietmap_flutter_plugin/vietmap_flutter_plugin.dart';

import '../constant/constant.dart';
import '../constant/show_dialog.dart';
import '../models/vehicle_model.dart';
import '../service/api.dart';

class BookController extends GetxController {
  var isLoading = true.obs;
  RxString selectedVehicle = "".obs;
  RxDouble distance = 0.0.obs;
  RxDouble duration = 0.0.obs;
  RxInt totalAmount = 0.obs;
  RxInt selectedPassengerCount = 1.obs;

  var currentSheetIndex = 0.obs;
  var vehicleCategoryModel = VehicleCategoryModel().obs;

  var step = 'pickup'.obs;

  var isPickupConfirmed = false.obs;
  var isRouteDrawn = false.obs;

  var pickupLatLong = Rxn<LatLng>();
  var destinationLatLong = Rxn<LatLng>();
  var polylinePoints = <LatLng>[].obs;
  var suggestions = <dynamic>[].obs;

  Location location = Location();
  List<LatLng> stopoverLatLng = [];
  var isMapDrawn = false.obs;
  late VehicleData? vehicleData;
  var isRoundTrip = false.obs;
  var scheduledTime = Rx<DateTime?>(null);
  var returnTime = Rx<DateTime?>(null);

  final TextEditingController pickupController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final RxList<TextEditingController> stopoverControllers =
      <TextEditingController>[].obs;

  var pickupText = ''.obs;
  var destinationText = ''.obs;
  var stopoverTexts = <RxString>[].obs;
  RxString focusedField = "".obs;
  var paymentMethod = ''.obs;

  var staticSuggestionsAirport = [
    {
      'display': 'Cảng Hàng Không Quốc Tế Nội Bài',
      'lat': 21.214138,
      'lng': 105.80334199999999
    },
    {
      'display': 'Cảng Hàng Không Quốc Tế Cát Bi',
      'lat': 20.8224975,
      'lng': 106.72470190000001
    },
    {
      'display': 'Cảng Hàng Không Quốc Tế Đà Nẵng',
      'lat': 16.053276,
      'lng': 108.20319
    },
    {
      'display': 'Cảng Hàng Không Quốc Tế Cam Ranh',
      'lat': 12.243852,
      'lng': 109.19269300000002
    },
    {
      'display': 'Cảng Hàng Không Quốc Tế Tân Sơn Nhất',
      'lat': 10.813373,
      'lng': 106.662531,
    },
    {
      'display': 'Cảng Hàng Không Quốc Tế Cần Thơ',
      'lat': 10.080556,
      'lng': 105.71202199999999,
    },
  ].obs;

  var staticSuggestions = [
    {
      'display': 'Thành phố Bắc Ninh',
      'lat': 21.185607,
      'lng': 106.074448,
    },
    {
      'display': 'Thành phố Vĩnh Yên, Vĩnh Phúc',
      'lat': 21.308948,
      'lng': 105.603597,
    },
    {
      'display': 'Thành phố Hưng Yên',
      'lat': 20.646883,
      'lng': 106.051083,
    },
    {
      'display': 'Thành phố Hải Dương',
      'lat': 20.937341,
      'lng': 106.314435,
    },
    {
      'display': 'Thành phố Việt Trì, Phú Thọ',
      'lat': 21.322739,
      'lng': 105.401291,
    },
    {
      'display': 'Thành phố Thái Nguyên',
      'lat': 21.594219,
      'lng': 105.848526,
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    fetchVehicleTypes();
    pickupController.addListener(() {
      pickupText.value = pickupController.text;
    });
    destinationController.addListener(() {
      destinationText.value = destinationController.text;
    });
  }

  @override
  void onClose() {
    pickupController.dispose();
    destinationController.dispose();
    for (var controller in stopoverControllers) {
      controller.dispose();
    }
    super.onClose();
  }

  void clearData() {
    pickupController.clear();
    destinationController.clear();
    stopoverControllers.clear();
    stopoverLatLng.clear();
    stopoverTexts.clear();
    pickupLatLong.value = null;
    destinationLatLong.value = null;
    scheduledTime.value = null;
    returnTime.value = null;
    isRoundTrip.value = false;
    distance.value = 0.0;
    duration.value = 0.0;
    totalAmount.value = 0;
    selectedVehicle.value = "";
    selectedPassengerCount.value = 1;
    step.value = 'pickup';
    isPickupConfirmed.value = false;
    isRouteDrawn.value = false;
    polylinePoints.clear();
    suggestions.clear();
    isMapDrawn.value = false;
    vehicleData = null;
    paymentMethod.value = 'cash';
    pickupText.value = '';
    destinationText.value = '';
    focusedField.value = '';
  }

  void addStopover() {
    var controller = TextEditingController();
    var text = ''.obs;
    controller.addListener(() {
      text.value = controller.text;
    });
    stopoverControllers.add(controller);
    stopoverTexts.add(text);
  }

  void removeStopover(int index) {
    stopoverControllers[index].dispose();
    stopoverControllers.removeAt(index);
    stopoverTexts.removeAt(index);
  }

  void setRoundTrip(bool value) {
    isRoundTrip.value = value;
  }

  void setScheduledTime(DateTime? dateTime) {
    scheduledTime.value = dateTime;
  }

  void setReturnTime(DateTime? dateTime) {
    returnTime.value = dateTime;
  }

  Future<void> drawRoute(VietmapController mapController) async {
    final LatLng? pickup = pickupLatLong.value;
    final LatLng? destination = destinationLatLong.value;

    if (pickup == null || destination == null) {
      log('Insufficient data to draw the route.');
      return;
    }

    List<LatLng> routePoints = [pickup];

    if (stopoverLatLng.isNotEmpty) {
      routePoints.addAll(stopoverLatLng);
    }

    routePoints.add(destination);

    if (isRoundTrip.value == true) {
      routePoints.add(pickup);
    }

    await fetchRouteData(routePoints);
    addPolyline(mapController);
    isRouteDrawn.value = true;
  }

  /*
  ** Use API
  */
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
    LocationData position = await location.getLocation();
    final result = await Vietmap.autocomplete(VietMapAutoCompleteParams(
        textSearch: value,
        focusLocation: LatLng(position.latitude!, position.longitude!)));
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

  Future<void> fetchVehicleTypes() async {
    try {
      final response = await http.get(
        Uri.parse(API.fetchVehicle),
        headers: API.header,
      );
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        final jsonData = responseBody;
        vehicleCategoryModel.value = VehicleCategoryModel.fromJson(jsonData);
        //return VehicleCategoryModel.fromJson(jsonData);
      } else {
        log('Failed to load vehicle types');
      }
    } catch (e) {
      log('Error: $e');
    }
  }

  int calculateTripPrice({
    required double distance,
    required double startingPrice,
    required double ratePerKm,
    double firstDiscountThreshold = 15.0,
    double secondDiscountThreshold = 30.0,
    double firstDiscountPercentage = 10.0,
    double secondDiscountPercentage = 20.0,
  }) {
    double totalCost = 0.0;
    if (distance <= 0) {
      totalCost = startingPrice;
    } else {
      totalCost = startingPrice + (distance * ratePerKm);
      if (distance > firstDiscountThreshold &&
          distance <= secondDiscountThreshold) {
        totalCost = totalCost * (1 - firstDiscountPercentage / 100);
      } else if (distance > secondDiscountThreshold) {
        totalCost = totalCost * (1 - secondDiscountPercentage / 100);
      }
    }
    int roundedCost = (totalCost / 1000).round() * 1000;

    return roundedCost;
  }

  Future<dynamic> bookRide(Map<String, dynamic> bodyParams) async {
    try {
      ShowDialog.showLoader('please_wait'.tr);
      final response = await http.post(Uri.parse(API.bookTrip),
          headers: API.header, body: jsonEncode(bodyParams));
      Map<String, dynamic> responseBody = json.decode(response.body);
      log('$responseBody');
      if (response.statusCode == 201) {
        ShowDialog.closeLoader();
        return responseBody;
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
  }

  Future<Map<String, dynamic>?> currentLocation() async {
    try {
      LocationData position = await location.getLocation();
      pickupLatLong.value = LatLng(position.latitude!, position.longitude!);
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
      log('Error: $e');
      return null;
    }
  }

  Future<void> fetchRouteData(List<LatLng> points) async {
    final url = Uri.parse(
        '${Constant.baseUrl}/route?api-version=1.1&apikey=${Constant.VietMapApiKey}&point=${points.map((p) => '${p.latitude},${p.longitude}').join('&point=')}&points_encoded=false&vehicle=car');
    try {
      final response = await http.get(url);
      debugPrint('API Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final paths = data['paths'] as List<dynamic>;

        if (paths.isNotEmpty) {
          final firstPath = paths[0];
          final coordinates =
              firstPath['points']['coordinates'] as List<dynamic>;

          polylinePoints.value = coordinates.map((coordinate) {
            return LatLng(coordinate[1], coordinate[0]);
          }).toList();

          final distanceInMeters = (firstPath['distance'] as num).toDouble();
          final timeInMillis = (firstPath['time'] as num).toInt();

          distance.value = distanceInMeters / 1000.0;
          duration.value = timeInMillis / 60000.0;

          log("Distance: ${distance.value} km");
          log("Duration: ${duration.value} minutes");
        } else {
          throw Exception('No paths found in the response');
        }
      } else {
        throw Exception(
            'Failed to load route data: Status code ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching route data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addPolyline(VietmapController? mapController) async {
    if (mapController != null && polylinePoints.isNotEmpty) {
      await mapController.addPolyline(
        PolylineOptions(
          geometry: polylinePoints,
          polylineColor: Colors.black,
          polylineWidth: 5.0,
        ),
      );

      await mapController.addSymbol(
        SymbolOptions(
          geometry: polylinePoints.first,
          iconImage: icPickup,
          iconSize: 1.5,
        ),
      );

      for (int i = 0; i < stopoverLatLng.length; i++) {
        final LatLng stopover = stopoverLatLng[i];
        await mapController.addSymbol(
          SymbolOptions(
            geometry: stopover,
            iconImage: icStop,
            iconSize: 1.3,
          ),
        );
      }

      await mapController.addSymbol(
        SymbolOptions(
          geometry: polylinePoints.last,
          iconImage: icDropoff,
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
          west: minLng,
          north: maxLat,
          south: minLat,
          east: maxLng,
          padding: 100);

      await mapController.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, bottom: 1000),
      );
    }
  }
}
