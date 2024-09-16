import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:customerapp/service/fakeapi.dart';
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

class BookingController extends GetxController {
  var isLoading = true.obs;
  RxString selectedVehicle = "".obs;
  RxDouble distance = 0.0.obs;
  RxDouble duration = 0.0.obs;
  RxInt selectedPassengerCount = 1.obs;

  var pickupLatLong = Rxn<LatLng>();
  var destinationLatLong = Rxn<LatLng>();
  var polylinePoints1 = <LatLng>[].obs;
  var suggestions = <dynamic>[].obs;

  Location location = Location();
  var polylinePoints = <LatLng>[].obs;
  List<LatLng> points = [];
  List<LatLng> stopoverLatLng = [];
  var isMapDrawn = false.obs;
  late VehicleData? vehicleData;
  var isRoundTrip = false.obs;
  var startDateTime = Rx<DateTime?>(null);
  var returnDateTime = Rx<DateTime?>(null);

  final TextEditingController pickupController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController passengerController = TextEditingController();
  final RxList<TextEditingController> stopoverControllers =
      <TextEditingController>[].obs;

  var pickupText = ''.obs;
  var destinationText = ''.obs;
  var stopoverTexts = <RxString>[].obs;
  RxString focusedField = "".obs;

  @override
  void onInit() {
    super.onInit();
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
    selectedVehicle.value = "";
    distance = 0.0.obs;
    duration = 0.0.obs;
    isMapDrawn.value = false;
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

/*  Future<void> setStopoverMarker(List<LatLng> stopovers, VietmapController? mapController) async {

    if (points.length > 2) {
      points.removeRange(1, points.length - 1);
    }

    if (points.length > 1) {
      points.insertAll(1, stopovers);
    } else {
      points.addAll(stopovers);
    }

    if (mapController != null) {
      await fetchRouteData();
      addPolyline(mapController);

      if (pickupLatLong.value != null && destinationLatLong.value != null) {
        isMapDrawn.value = true;
      }
    }

    for (var point in points) {
      debugPrint('Lat: ${point.latitude}, Lng: ${point.longitude}');
    }
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

  Future<void> setDestinationMarker(
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

  Future<void> fetchRouteData() async {
    final url = Uri.parse(
        '${Constant.baseUrl}/route?api-version=1.1&apikey=${Constant.VietMapApiKey}&point=${points.map((p) => '${p.latitude},${p.longitude}').join('&point=')}&points_encoded=false&vehicle=car');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final paths = data['paths'] as List<dynamic>;
        if (paths.isNotEmpty) {
          final firstPath = paths[0];

          final coordinates = firstPath['points']['coordinates'] as List<dynamic>;
          polylinePoints.value = coordinates.map((coordinate) {
            return LatLng(coordinate[1], coordinate[0]);
          }).toList();

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
          west: minLng,
          north: maxLat,
          south: minLat,
          east: maxLng,
          padding: 100);

      await mapController.animateCamera(
        CameraUpdate.newLatLngBounds(bounds),
      );
    }
  }*/

/*
  Future<List<LatLng>> fetchRouteDataForSegment(LatLng start, LatLng end) async {
    final url = Uri.parse(
        '${Constant.baseUrl}/route?api-version=1.1&apikey=${Constant.VietMapApiKey}&point=${start.latitude},${start.longitude}&point=${end.latitude},${end.longitude}&points_encoded=false&vehicle=car');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final paths = data['paths'] as List<dynamic>;
        if (paths.isNotEmpty) {
          final firstPath = paths[0];
          final coordinates = firstPath['points']['coordinates'] as List<dynamic>;
          return coordinates.map((coordinate) {
            return LatLng(coordinate[1], coordinate[0]);
          }).toList();
        } else {
          throw Exception('No paths found in the response');
        }
      } else {
        throw Exception('Failed to load route data');
      }
    } catch (e) {
      print('Error fetching route data for segment: $e');
      return [];
    }
  }


  Future<void> fetchAndDrawRoute(VietmapController? mapController) async {
    polylinePoints.clear();

    // Lặp qua các điểm để lấy dữ liệu cho từng đoạn và vẽ lên bản đồ
    for (int i = 0; i < points.length - 1; i++) {
      final segmentPoints = await fetchRouteDataForSegment(points[i], points[i + 1]);
      polylinePoints.addAll(segmentPoints);

      if (mapController != null && segmentPoints.isNotEmpty) {
        // Vẽ đoạn tuyến đường lên bản đồ
        await mapController.addPolyline(
          PolylineOptions(
            geometry: segmentPoints,
            polylineColor: Colors.blue,
            polylineWidth: 5.0,
          ),
        );
      }
    }

    if (mapController != null && polylinePoints.isNotEmpty) {
      // Thêm biểu tượng cho điểm xuất phát
      await mapController.addSymbol(
        SymbolOptions(
          geometry: polylinePoints.first,
          iconImage: ic_pickup,
          iconSize: 1.5,
        ),
      );

      // Thêm biểu tượng cho điểm đến
      await mapController.addSymbol(
        SymbolOptions(
          geometry: polylinePoints.last,
          iconImage: ic_dropoff,
          iconSize: 1.5,
        ),
      );

      // Tính toán giới hạn bản đồ để bao phủ tất cả các điểm
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

      // Di chuyển camera để hiển thị toàn bộ tuyến đường
      await mapController.animateCamera(
        CameraUpdate.newLatLngBounds(bounds),
      );
    }
  }
*/

  Future<void> setStopoverMarker(List<LatLng> stopovers, VietmapController? mapController) async {
    if (points.length >= 2) {
      points = [points.first, ...stopovers, points.last];
    } else {
      points.addAll(stopovers);
    }

    if (mapController != null) {
      await fetchRouteData();
      addPolyline(mapController);

      if (pickupLatLong.value != null && destinationLatLong.value != null) {
        isMapDrawn.value = true;
      }
    }

    for (var point in points) {
      debugPrint('Lat: ${point.latitude}, Lng: ${point.longitude}');
    }
  }

  Future<void> setPickUpMarker(LatLng pickup, VietmapController? mapController) async {
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

  Future<void> setDestinationMarker(LatLng destination, VietmapController? mapController) async {
    destinationLatLong.value = destination;
    if (points.length >= 2) {
      points[points.length - 1] = destinationLatLong.value!;
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

  Future<void> fetchRouteData() async {
    final url = Uri.parse(
        '${Constant.baseUrl}/route?api-version=1.1&apikey=${Constant.VietMapApiKey}&point=${points.map((p) => '${p.latitude},${p.longitude}').join('&point=')}&points_encoded=false&vehicle=car');

    debugPrint('API URL: $url');

    try {
      final response = await http.get(url);
      debugPrint('API Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final paths = data['paths'] as List<dynamic>;

        if (paths.isNotEmpty) {
          final firstPath = paths[0];
          final coordinates = firstPath['points']['coordinates'] as List<dynamic>;

          polylinePoints.value = coordinates.map((coordinate) {
            return LatLng(coordinate[1], coordinate[0]);
          }).toList();

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
        throw Exception('Failed to load route data: Status code ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching route data: $e');
    } finally {
      isLoading.value = false;
    }
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
          west: minLng,
          north: maxLat,
          south: minLat,
          east: maxLng,
          padding: 100);

      await mapController.animateCamera(
        CameraUpdate.newLatLngBounds(bounds),
      );
    }
  }

  /*
  ** Use API
  */
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

  // getVehicle
  Future<VehicleCategoryModel> getVehicleCategoryModel() async {
    final jsonString = await FakeAPI.fetchVehicleCategoryData();
    final jsonMap = json.decode(jsonString);
    return VehicleCategoryModel.fromJson(jsonMap);
  }

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

  Future<dynamic> bookRide(Map<String, dynamic> bodyParams) async {
    try {
      ShowDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.bookRides),
          headers: API.header, body: jsonEncode(bodyParams));

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
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
      debugPrint('Error: $e');
      return null;
    }
  }

  Future<void> fetchRouteData1(List<LatLng> points) async {
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
          final coordinates = firstPath['points']['coordinates'] as List<dynamic>;

          polylinePoints1.value = coordinates.map((coordinate) {
            return LatLng(coordinate[1], coordinate[0]);
          }).toList();

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
        throw Exception('Failed to load route data: Status code ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching route data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addPolyline1(VietmapController? mapController) async {
    if (mapController != null && polylinePoints1.isNotEmpty) {
      await mapController.addPolyline(
        PolylineOptions(
          geometry: polylinePoints1,
          polylineColor: Colors.blue,
          polylineWidth: 5.0,
        ),
      );

      await mapController.addSymbol(
        SymbolOptions(
          geometry: polylinePoints1.first,
          iconImage: ic_pickup,
          iconSize: 1.5,
        ),
      );

      await mapController.addSymbol(
        SymbolOptions(
          geometry: polylinePoints1.last,
          iconImage: ic_dropoff,
          iconSize: 1.5,
        ),
      );

      double? minLat, minLng, maxLat, maxLng;

      for (var point in polylinePoints1) {
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
        CameraUpdate.newLatLngBounds(bounds),
      );
    }
  }


  Future<void> setPickUpMarker1(VietmapController? mapController) async {
    LatLng? pickup = pickupLatLong.value;

    if (points.isNotEmpty) {
      points[0] =pickup!;
    } else {
      points.insert(0, pickup!);
    }

    await mapController?.addSymbol(
      SymbolOptions(
        geometry: pickupLatLong.value,
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
}
