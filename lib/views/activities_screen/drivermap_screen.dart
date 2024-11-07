import 'dart:developer';

import 'package:customerapp/controllers/drivermap_controller.dart';
import 'package:customerapp/models/tripstop_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

import '../../constant/constant.dart';
import '../../controllers/activities_controller.dart';
import '../../models/trip_model.dart';
import '../../utils/themes/button.dart';
import '../../utils/themes/text_style.dart';

class DriverMapScreen extends StatefulWidget {
  const DriverMapScreen({super.key});

  @override
  DriverMapScreenState createState() => DriverMapScreenState();
}

class DriverMapScreenState extends State<DriverMapScreen> {
  final Trip trip = Get.arguments;
  VietmapController? _mapController;

  final ActivitiesController controller = Get.find<ActivitiesController>();
  final DriverMapController drController = Get.put(DriverMapController());

  final CameraPosition _kInitialPosition =
      const CameraPosition(target: LatLng(10.762317, 106.654551), zoom: 10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          VietmapGL(
            dragEnabled: true,
            compassEnabled: false,
            trackCameraPosition: true,
            myLocationRenderMode: MyLocationRenderMode.COMPASS,
            myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
            minMaxZoomPreference: const MinMaxZoomPreference(0, 24),
            rotateGesturesEnabled: false,
            styleString:
                '${Constant.baseUrl}/maps/light/styles.json?apikey=${Constant.VietMapApiKey}',
            initialCameraPosition: _kInitialPosition,
            onMapCreated: (VietmapController controller) async {
              _mapController = controller;
              // controller.animateCamera(CameraUpdate.newLatLng(position));
            },
          ),
          Obx(() {
            LatLng position = drController.driverPosition.value;
            double rotation = drController.driverRotation.value;

            return _mapController != null
                ? MarkerLayer(
                    ignorePointer: true,
                    mapController: _mapController!,
                    markers: [
                      Marker(
                        child: Transform.rotate(
                          angle: rotation,
                          child: Image.asset(icDriver, scale: 2),
                        ),
                        latLng: LatLng(position.latitude, position.longitude),
                      ),
                    ],
                  )
                : Container();
          }),
          buildInFormation(),
          Positioned(
            top: 50,
            right: 20,
            child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  onTap: () {
                    drawRoute();
                  },
                  child: Image.asset(
                    icRoute,
                    width: 40,
                    height: 40,
                    color: Colors.lightBlue,
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Future<void> drawRoute() async {
    final LatLng pickup = LatLng(trip.fromLat!, trip.fromLng!);
    final LatLng destination = LatLng(trip.toLat!, trip.toLng!);

    List<LatLng> routePoints = [pickup];
    List<TripStop> stops = trip.tripStops ?? [];

    List<LatLng> stopoverLatLng = stops.map((stop) {
      return LatLng(stop.latitude!, stop.longitude!);
    }).toList();

    if (stopoverLatLng.isNotEmpty) {
      routePoints.addAll(stopoverLatLng);
    }

    routePoints.add(destination);

    await drController.fetchRouteData(routePoints);
    drController.addPolyline(_mapController);
  }

  Widget buildInFormation() {
    return DraggableScrollableSheet(
      initialChildSize: 0.27,
      minChildSize: 0.27,
      maxChildSize: 0.27,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /* Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),*/
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'driver'.tr,
                                style: CustomTextStyles.header.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.blueAccent,
                        thickness: 1,
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor:
                                      Colors.blueAccent.withOpacity(0.1),
                                  child: const Icon(Icons.person,
                                      color: Colors.blueAccent),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      trip.driverName!,
                                      style: CustomTextStyles.normal,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        final phoneNumber =
                                            trip.driverPhoneNumber!;
                                        final encodedPhoneNumber = phoneNumber
                                            .replaceFirst("+", "%2B");
                                        launchUrl(Uri.parse(
                                            "tel://$encodedPhoneNumber"));
                                      },
                                      child: Image.asset(
                                        icCall,
                                        width: 40,
                                        height: 40,
                                      ),
                                    )),
                                const SizedBox(width: 10),
                                Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: InkWell(
                                      onTap: () async {
                                        String phoneNumber =
                                            trip.driverPhoneNumber!;
                                        String smsUrl = 'sms:$phoneNumber';

                                        Uri smsUri = Uri.parse(smsUrl);

                                        if (await canLaunchUrl(smsUri)) {
                                          await launchUrl(smsUri);
                                        } else {
                                          log('Could not launch $smsUrl');
                                        }
                                      },
                                      child: Image.asset(
                                        icChat,
                                        width: 40,
                                        height: 40,
                                      ),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ButtonThem.buildCustomButton(
                label: 'back'.tr,
                onPressed: () async {
                  controller.refreshData();
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
