import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import '../../../models/trip_model.dart';
import 'package:http/http.dart' as http;

import '../constant/constant.dart';
import '../models/tripstop_model.dart';
import '../service/api.dart';
import '../utils/preferences/preferences.dart';

class DriverMapController extends GetxController {
  int? userId = Preferences.getInt(Preferences.userId);

  Rx<LatLng> driverPosition = LatLng(0, 0).obs;
  var driverRotation = 0.0.obs;
  late PusherChannelsFlutter pusher;
  late String channelName;

  var isLoading = true.obs;
  var shouldRefresh = false.obs;

  var stops = <TripStop>[].obs;
  var pickupPoints = <LatLng>[].obs;
  var destinationPoints = <LatLng>[].obs;
  var stopsPoints = <LatLng>[].obs;
  var polylinePoints = <LatLng>[].obs;
  List<LatLng> stopoverLatLng = [];

  @override
  void onInit() {
    super.onInit();
    _initializePusher();
    final trip = Get.arguments as Trip?;
    if (trip != null && trip.driverId != null) {
      startListeningToDriverLocation(trip.driverId!);
    } else {
      debugPrint("No valid trip or driverId provided");
    }
  }

  void _initializePusher() async {
    try {
      pusher = PusherChannelsFlutter.getInstance();

      await pusher.init(
        apiKey: "43f94013ba721f8848a8",
        cluster: "ap1",
        useTLS: true,
        onAuthorizer:
            (String channelName, String socketId, dynamic options) async {
          final response = await http.post(
            Uri.parse("http://appbooking.xyz/broadcasting/auth"),
            headers: API.header,
            body: jsonEncode({
              'channel_name': channelName,
              'socket_id': socketId,
            }),
          );
          if (response.statusCode == 200) {
            return jsonDecode(response.body);
          } else {
            throw Exception('Authorization failed');
          }
        },
        onSubscriptionSucceeded: (String channelName, dynamic data) {
          //log("Successfully subscribed to $channelName");
        },
        onSubscriptionError: (String message, dynamic error) {
          //log("Error subscribing to channel: $message, error: $error");
        },
        onEvent: (PusherEvent event) {
          //log("Event received: ${event.eventName} on channel: ${event.channelName}");
        },
        onError: (String message, int? code, dynamic error) {
          //log("Pusher error: $message, code: $code, error: $error");
        },
      );

      await pusher.connect();
      //log("Pusher connected");
    } catch (e) {
      debugPrint("Pusher initialization failed: $e");
    }
  }

  // show location driver
  void startListeningToDriverLocation(String driverId) async {
    try {
      channelName = "private-driver-location.$driverId";
      if (pusher.getChannel(channelName) != null) {
        pusher.unsubscribe(channelName: channelName);
      }

      await pusher.subscribe(channelName: channelName).then((_) {
        //log("Successfully subscribed to $channelName");
      }).catchError((error) {
        //log("Error subscribing to channel: $error");
      });

      pusher.onEvent = (PusherEvent event) {
        if (event.channelName == channelName &&
            event.eventName == "DriverLocationUpdated") {
          final Map<String, dynamic> data = jsonDecode(event.data);
          final latitude =
              double.tryParse(data['latitude']?.toString() ?? '') ?? 0.0;
          final longitude =
              double.tryParse(data['longitude']?.toString() ?? '') ?? 0.0;
          driverPosition.value = LatLng(latitude, longitude);
        }
      };
    } catch (e) {
      debugPrint("HELOO Pusher : $e");
    }
  }

  void stopListeningToDriverLocation() async {
    try {
      await pusher.unsubscribe(channelName: channelName);
    } catch (e) {
      debugPrint("$e");
    }
  }

  Future<void> fetchRouteData(List<LatLng> points) async {
    final url = Uri.parse(
        '${Constant.baseUrl}/route?api-version=1.1&apikey=${Constant.VietMapApiKey}&point=${points.map((p) => '${p.latitude},${p.longitude}').join('&point=')}&points_encoded=false&vehicle=car');
    try {
      final response = await http.get(url);
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
        } else {
          throw Exception('No paths found in the response');
        }
      } else {
        throw Exception(
            'Failed to load route data: Status code ${response.statusCode}');
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
          polylineColor: Colors.black38,
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

  void updateDriverPosition(LatLng newPosition) {
    LatLng oldPosition = driverPosition.value;
    driverPosition.value = newPosition;
    updateDriverRotation(oldPosition, newPosition);
  }

  void updateDriverRotation(LatLng oldPosition, LatLng newPosition) {
    double deltaLat = newPosition.latitude - oldPosition.latitude;
    double deltaLng = newPosition.longitude - oldPosition.longitude;
    double rotation = atan2(deltaLng, deltaLat);

    driverRotation.value = rotation;
  }

  @override
  void onClose() {
    pusher.unsubscribe(channelName: channelName);
    pusher.disconnect();
    super.onClose();
  }
}
