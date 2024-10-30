import 'dart:developer';

import 'package:customerapp/controllers/cluster_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

import '../../bindings/navigation_bindings/navigation_binding.dart';
import '../../constant/constant.dart';
import '../../constant/show_dialog.dart';
import '../../models/vehicle_model.dart';
import '../../utils/themes/button.dart';
import '../../utils/themes/dialog_box.dart';
import '../../utils/themes/text_style.dart';
import '../navigation_screen/navigation_bar.dart';

class ClusterMapScreen extends StatefulWidget {
  const ClusterMapScreen({super.key});

  @override
  ClusterMapScreenState createState() => ClusterMapScreenState();
}

class ClusterMapScreenState extends State<ClusterMapScreen> {

  final clusterController = Get.put(ClusterController());

  String apiKey = Constant.VietMapApiKey;

  VietmapController? _mapController;

  final CameraPosition _kInitialPosition =
  const CameraPosition(target: LatLng(10.762317, 106.654551), zoom: 10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: VietmapGL(
              dragEnabled: true,
              compassEnabled: false,
              trackCameraPosition: true,
              myLocationRenderMode: MyLocationRenderMode.COMPASS,
              myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
              minMaxZoomPreference: const MinMaxZoomPreference(0, 24),
              rotateGesturesEnabled: false,
              styleString:
              '${Constant.baseUrl}/maps/light/styles.json?apikey=$apiKey',
              initialCameraPosition: _kInitialPosition,
              onMapCreated: (VietmapController controller) async {
                _mapController = controller;
              },
              onMapIdle: setPickupMaker,
            ),
          ),
          Obx(() {
            switch (clusterController.currentSheetIndex.value) {
              case 0:
                return buildConfirm();
              case 1:
                return buildTripOption();
              case 2:
                return buildChooseVehicle(
                    clusterController.vehicleCategoryModel.value);
              case 3:
                return buildPaymentOption();
              default:
                return buildConfirm();
            }
          }),
        ],
      ),
    );
  }

  Future<void> setPickupMaker() async {
    final LatLng? pickup = clusterController.pickupLatLong.value;

    if (pickup == null ||
        _mapController == null ||
        clusterController.isRouteDrawn.value) {
      return;
    }
    await _mapController?.addSymbol(
      SymbolOptions(
        geometry: pickup,
        iconImage: icPickup,
        iconSize: 1.5,
      ),
    );

    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(pickup.latitude, pickup.longitude),
        zoom: 14,
      )),
    );
  }

  Widget buildConfirm() {
    return DraggableScrollableSheet(
      minChildSize: 0.30,
      initialChildSize: 0.30,
      maxChildSize: 0.30,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'confirmed_pickup'.tr,
                          style: CustomTextStyles.header,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'confirm or change'.tr,
                          style: CustomTextStyles.body,
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Get.back();
                        clusterController.currentSheetIndex.value = -1;
                      },
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.blue,
                  thickness: 1,
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.yellow[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          clusterController.pickupController.value.text,
                          style: CustomTextStyles.regular,
                          maxLines: 1,
                          overflow:  TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ButtonThem.buildCustomButton(
                  label: 'confirmed_pickup'.tr,
                  onPressed: () async {
                    await clusterController.drawRoute(_mapController!);
                    clusterController.isRouteDrawn.value = true;
                    clusterController.currentSheetIndex.value = 1;
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildTripOption() {
    return DraggableScrollableSheet(
      minChildSize:  0.35,
      initialChildSize: 0.35,
      maxChildSize:  0.35,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Obx(
                        () => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                'trip_option'.tr,
                                style: CustomTextStyles.header
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Get.back();
                                clusterController.currentSheetIndex.value = -1;
                              },
                            ),
                          ],
                        ),
                        const Divider(
                          color: Colors.blue,
                          thickness: 1,
                          indent: 16,
                          endIndent: 16,
                          height: 10,
                        ),
                        // Passenger Option
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'passenger'.tr,
                              style: CustomTextStyles.normal,
                            ),
                            DropdownButton<int>(
                              value: clusterController.selectedPassengerCount.value,
                              iconEnabledColor: Colors.green,
                              iconDisabledColor: Colors.grey,
                              items: List.generate(10, (index) {
                                return DropdownMenuItem<int>(
                                  value: index + 1,
                                  child: Text('${index + 1}'),
                                );
                              }),
                              icon: const Icon(
                                Icons.person,
                                color: Colors.cyan,
                              ),
                              onChanged: (value) {
                                if (value != null) {
                                  clusterController.selectedPassengerCount.value =
                                      value;
                                }
                              },
                              borderRadius:
                              const BorderRadius.all(Radius.circular(8.0)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  DateTime now = DateTime.now();
                                  DateTime initialDateTime = clusterController.scheduledTime.value ?? now;
                                  DatePicker.showDateTimePicker(
                                    context,
                                    showTitleActions: true,
                                    minTime: DateTime.now(),
                                    maxTime: DateTime(2101),
                                    onConfirm: (dateTime) {
                                      clusterController.setScheduledTime(dateTime);
                                    },
                                    currentTime: initialDateTime,
                                    locale: LocaleType.vi,
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'scheduled_time'.tr,
                                      style: CustomTextStyles.regular,
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 12.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.cyan,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.access_time,
                                              size: 20.0, color: Colors.cyan),
                                          const SizedBox(width: 8.0),
                                          Expanded(
                                            child: Text(
                                              clusterController.scheduledTime.value ==
                                                  null
                                                  ? DateFormat('HH:mm dd-MM')
                                                  .format(DateTime.now())
                                                  : DateFormat('HH:mm dd-MM')
                                                  .format(clusterController
                                                  .scheduledTime.value!),
                                              style:
                                              const TextStyle(fontSize: 16.0),
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ButtonThem.buildCustomButton(
                label: 'confirmed'.tr,
                onPressed: () async {
                  if (clusterController.scheduledTime.value == null) {
                    ShowDialog.showToast(
                        "select_time".tr);
                  } else if (clusterController.isRoundTrip.value &&
                      clusterController.returnTime.value == null) {
                    ShowDialog.showToast('return_time'.tr);
                  } else {
                    clusterController.fetchVehicleTypes();
                    clusterController.currentSheetIndex.value = 2;
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }

  Widget buildChooseVehicle(VehicleCategoryModel vehicleCategoryModel) {
    return DraggableScrollableSheet(
      minChildSize: 0.4,
      initialChildSize:  0.4,
      maxChildSize: 0.6,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'choose vehicle'.tr,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              clusterController.currentSheetIndex.value=-1;
                              Get.back();
                            },
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.blue,
                        thickness: 1,
                        height: 20,
                      ),
                      // Distance Row
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Distance
                            Row(
                              children: [
                                const Icon(
                                  Icons.social_distance_outlined,
                                  size: 24,
                                  color: Colors.blueAccent,
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'distance'.tr,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Obx(() => Text(
                                      "${clusterController.distance.value.toStringAsFixed(2)} ${Constant.distanceUnit}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    )),
                                  ],
                                ),
                              ],
                            ),

                            // Duration
                            Row(
                              children: [
                                const Icon(
                                  Icons.timer_sharp,
                                  size: 24,
                                  color: Colors.redAccent,
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'duration'.tr,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Obx(() => Text(
                                      "${clusterController.duration.value.toStringAsFixed(2)} ${Constant.durationUnit}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    )),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.blue,
                        thickness: 1,
                        height: 20,
                      ),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          itemCount: vehicleCategoryModel.data!.length,
                          itemBuilder: (context, index) {
                            int tripPrice = clusterController.calculateTripPrice(
                              distance: clusterController.distance.value,
                              startingPrice: double.parse(vehicleCategoryModel
                                  .data![index].startingPrice!),
                              ratePerKm: double.parse(vehicleCategoryModel
                                  .data![index].ratePerKm!),
                            );
                            return Obx(
                                  () => InkWell(
                                onTap: () {
                                  clusterController.vehicleData =
                                  vehicleCategoryModel.data![index];
                                  clusterController.selectedVehicle.value =
                                      vehicleCategoryModel.data![index].id
                                          .toString();
                                  clusterController.totalAmount.value =
                                      tripPrice;
                                },
                                child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: clusterController
                                          .selectedVehicle.value ==
                                          vehicleCategoryModel
                                              .data![index].id
                                          ? Colors.cyan.withOpacity(0.2)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: clusterController
                                            .selectedVehicle.value ==
                                            vehicleCategoryModel
                                                .data![index].id
                                                .toString()
                                            ? Colors.cyan
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                    child: ListTile(
                                      leading: AspectRatio(
                                        aspectRatio: 1,
                                        child: ClipOval(
                                          child: Image.network(
                                            vehicleCategoryModel
                                                .data![index].imageUrl ??
                                                'assets/images/avatar.jpg',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        vehicleCategoryModel.data![index].name
                                            .toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            NumberFormat('#,###')
                                                .format(tripPrice),
                                            style: CustomTextStyles.normal,
                                          ),
                                          const SizedBox(width: 4),
                                          Image.asset(
                                            'assets/icons/dong.png',
                                            width: 12,
                                            height: 12,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ButtonThem.buildCustomButton(
                label: 'confirmed'.tr,
                onPressed: () async {
                  if (clusterController.selectedVehicle.value == '') {
                    ShowDialog.showToast('select a vehicle'.tr);
                    return;
                  }
                  clusterController.currentSheetIndex.value = 3;
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildPaymentOption() {
    return DraggableScrollableSheet(
      minChildSize: 0.35,
      initialChildSize: 0.35,
      maxChildSize: 0.35,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'payment info'.tr,
                            style: CustomTextStyles.header,
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              clusterController.currentSheetIndex.value = -1;
                              Get.back();
                            },
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.blue,
                        thickness: 1,
                        height: 20,
                      ),
                      Text(
                        'payment method'.tr,
                        style: CustomTextStyles.normal,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                clusterController.paymentMethod.value = 'cash';
                              },
                              child: Obx(
                                    () => Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: clusterController.paymentMethod.value ==
                                        'cash'
                                        ? Colors.green.withOpacity(0.5)
                                        : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      const Icon(Icons.money, color: Colors.green),
                                      const SizedBox(height: 8),
                                      Text('cash'.tr),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                clusterController.paymentMethod.value = 'wallet';
                              },
                              child: Obx(
                                    () => Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: clusterController.paymentMethod.value ==
                                        'wallet'
                                        ? Colors.green.withOpacity(0.5)
                                        : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      const Icon(Icons.account_balance_wallet,
                                          color: Colors.green),
                                      const SizedBox(height: 8),
                                      Text('wallet'.tr),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              ButtonThem.buildCustomButton(
                label: 'book_now'.tr,
                onPressed: () async {
                  if (clusterController.paymentMethod.value == '') {
                    ShowDialog.showToast('Please select a Payment method'.tr);
                    return;
                  }
                  clusterController.isMapDrawn.value = false;

                  Map<String, dynamic> bodyParams = {
                    'from_address': clusterController.pickupController.text,
                    'from_lat': clusterController.pickupLatLong.value!.latitude,
                    'from_lng': clusterController.pickupLatLong.value!.longitude,
                    'to_address': clusterController.destinationController.text,
                    'to_lat': clusterController.destinationLatLong.value!.latitude,
                    'to_lng':
                    clusterController.destinationLatLong.value!.longitude,
                    'scheduled_time':
                    clusterController.scheduledTime.value?.toIso8601String(),
                    'vehicle_type':  int.parse(clusterController.selectedVehicle.value),
                    'round_trip': clusterController.isRoundTrip.value ? 1 : 0,
                    'km': clusterController.distance.toString(),
                    'passenger_count': clusterController.selectedPassengerCount.value,
                    'total_amount': clusterController.totalAmount.value.toString(),
                    'payment': clusterController.paymentMethod.value,
                    'trip_type': "airport_sharing",
                  };

                  clusterController.bookRide(bodyParams).then((value) {
                    if (value != null) {
                      log('$value');
                      if (value['status'] == true) {
                        Get.back();
                        clusterController.clearData();
                        // Get.offAll(() => NavigationPage(), arguments: 1);
                        Get.offAll(() => NavigationPage(), binding: NavigationBinding(), arguments: 2);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialogBox(
                              title: "",
                              descriptions: 'successfully'.tr,
                              onPress: () {
                                clusterController.clearData();
                                Get.back();
                              },
                              img: Image.asset(
                                  'assets/images/green_checked.png'),
                            );
                          },
                        );
                      }
                    } else {
                      log('Error: Received null response');
                    }
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
