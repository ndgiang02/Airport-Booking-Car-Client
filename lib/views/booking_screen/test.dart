import 'package:customerapp/utils/themes/text_style.dart';
import 'package:customerapp/utils/themes/textfield_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

import '../../constant/constant.dart';
import '../../controllers/booking_controller.dart';
import '../../models/vehicle_model.dart';
import '../../utils/themes/button.dart';
import '../../utils/themes/contant_colors.dart';

class AirportScreen extends StatefulWidget {
  const AirportScreen({super.key});

  @override
  _AirportScreenState createState() => _AirportScreenState();
}

class _AirportScreenState extends State<AirportScreen> {
  final bookController = Get.find<BookingController>();

  String apiKey = Constant.VietMapApiKey;

  final Location currentLocation = Location();

  final CameraPosition _kInitialPosition =
  const CameraPosition(target: LatLng(10.762317, 106.654551), zoom: 15);

  final TextEditingController pickupController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController passengerController = TextEditingController();

  VietmapController? _mapController;

  @override
  void initState() {
    super.initState();
    pickupController.addListener(() {
      setState(() {});
    });
    destinationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    pickupController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Booking'.tr,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
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
            '${Constant.baseUrl}/maps/light/styles.json?apikey=$apiKey',
            initialCameraPosition: _kInitialPosition,
            onMapCreated: (VietmapController controller) async {
              _mapController = controller;
            },
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      buildTextField(
                        controller: pickupController,
                        hintText: 'From',
                        onClear: () {
                          pickupController.clear();
                          bookController.clearData();
                          _mapController?.clearLines();
                          _mapController?.clearSymbols();
                          bookController.pickupLatLong.value = null;
                        },
                        onGetCurrentLocation: () => _getCurrentLocation(true),
                      ),
                      const Divider(),
                      Obx(() => Column(
                        children: bookController.stopoverControllers.map((controller) {
                          return Column(
                            children: [
                              buildTextField(
                                controller: controller,
                                hintText: 'Stopover',
                                onClear: () {
                                  controller.clear();
                                },
                                onDeleteStop: () {
                                  bookController.stopoverControllers.remove(controller);
                                  controller.dispose();
                                },
                              ),
                              const Divider(),
                            ],
                          );
                        }).toList(),
                      )),
                      buildTextField(
                        controller: destinationController,
                        hintText: 'To',
                        onClear: () {
                          destinationController.clear();
                          bookController.clearData();
                          _mapController?.clearLines();
                          _mapController?.clearSymbols();
                          bookController.destinationLatLong.value = null;
                        },
                      ),
                      TextButton(
                        onPressed: () {
                          bookController.stopoverControllers.add(TextEditingController());
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 8),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add_circle,
                              color: Colors.blue,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              "Add Stopover",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Obx(() {
            return bookController.isMapDrawn.value
                ? Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: confirmWidget(),
            )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    void Function()? onClear,
    void Function()? onGetCurrentLocation, void Function()? onDeleteStop,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      child: TypeAheadField<Map<String, String>>(
        hideOnEmpty: true,
        hideOnLoading: true,
        textFieldConfiguration: TextFieldConfiguration(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.location_on, color: Colors.grey),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey),
              onPressed: onClear,
            )
                : onDeleteStop != null
                ? IconButton(
              icon: const Icon(Icons.my_location, color: Colors.grey),
              onPressed: onDeleteStop,
            )
                : onGetCurrentLocation != null
                ? IconButton(
              icon: const Icon(Icons.my_location, color: Colors.grey),
              onPressed: onGetCurrentLocation,
            )
                : null,
            hintText: hintText,
            border: InputBorder.none,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
        suggestionsCallback: (pattern) async {
          return await bookController.getAutocompleteData(pattern);
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            leading: const Icon(Icons.pin_drop_outlined, color: Colors.blue),
            title: Text(suggestion['display']!),
          );
        },
        onSuggestionSelected: (suggestion) async {
          controller.text = suggestion['display']!;
          LatLng? latLong =
          await bookController.reverseGeocode(suggestion['ref_id']!);
          controller.selection =
              TextSelection.fromPosition(const TextPosition(offset: 0));
          FocusScope.of(context).unfocus();
          bookController.suggestions.clear();
          if (controller == pickupController) {
            bookController.setPickUpMarker(latLong!, _mapController);
          } else {
            bookController.
            setDestinationMarker(latLong!, _mapController);
          }
        },
      ),
    );
  }

  Future<void> _getCurrentLocation(bool pickup) async {
    final current = await bookController.getCurrentLocation(_mapController!);
    if (current != null) {
      pickupController.text = current['display'];
      pickupController.selection =
          TextSelection.fromPosition(const TextPosition(offset: 0));
    }
  }

  confirmWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ButtonThem.buildIconButton(context,
                iconSize: 16.0,
                icon: Icons.arrow_back_ios,
                iconColor: Colors.black,
                btnHeight: 40,
                btnWidthRatio: 0.25,
                title: "Back".tr,
                btnColor: ConstantColors.cyan,
                txtColor: Colors.black, onPress: () {
                  bookController.isMapDrawn.value = false;
                  _mapController?.clearLines();
                  _mapController?.clearSymbols();
                }),
          ),
          Expanded(
            child: ButtonThem.buildButton(context,
                btnHeight: 40,
                title: "Continue".tr,
                btnColor: ConstantColors.primary,
                txtColor: Colors.white, onPress: () async {
                  tripOptionBottomSheet(context);
                  /* await controller.getDurationDistance(departureLatLong!, destinationLatLong!).then((durationValue) async {
                if (durationValue != null) {
                  await controller.getUserPendingPayment().then((value) async {
                    if (value != null) {
                      if (value['success'] == "success") {
                        if (value['data']['amount'] != 0) {
                          _pendingPaymentDialog(context);
                        } else {
                          if (Constant.distanceUnit == "KM") {
                            controller.distance.value = durationValue['rows'].first['elements'].first['distance']['value'] / 1000.00;
                          } else {
                            controller.distance.value = durationValue['rows'].first['elements'].first['distance']['value'] / 1609.34;
                          }

                          controller.duration.value = durationValue['rows'].first['elements'].first['duration']['text'];
                          // Get.back();
                          controller.confirmWidgetVisible.value = false;
                          tripOptionBottomSheet(context);
                        }
                      } else {
                        if (Constant.distanceUnit == "KM") {
                          controller.distance.value = durationValue['rows'].first['elements'].first['distance']['value'] / 1000.00;
                        } else {
                          controller.distance.value = durationValue['rows'].first['elements'].first['distance']['value'] / 1609.34;
                        }
                        controller.duration.value = durationValue['rows'].first['elements'].first['duration']['text'];
                        controller.confirmWidgetVisible.value = false;
                        // Get.back();
                        tripOptionBottomSheet(context);
                      }
                    }
                  });
                }
              });*/
                }),
          ),
        ],
      ),
    );
  }

  Future<void> tripOptionBottomSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Trip option".tr,
                    style: CustomTextStyles.header,
                  ),
                ),
                Divider(),
                Obx(() {
                  return SwitchListTile(
                    activeColor: Colors.cyan,
                    inactiveTrackColor: Colors.grey.shade50,
                    title: Text("Round Trip".tr, style: CustomTextStyles.body,),
                    value: bookController.isRoundTrip.value,
                    onChanged: (bool value) {
                      bookController.setRoundTrip(value);
                    },
                  );
                }),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              DateTime initialDateTime = bookController.startDateTime.value ??
                                  DateTime.now().add(Duration(minutes: 30));
                              DatePicker.showDateTimePicker(
                                context,
                                showTitleActions: true,
                                minTime: DateTime.now(),
                                maxTime: DateTime(2101),
                                onConfirm: (dateTime) {
                                  bookController.setStartDateTime(dateTime);
                                },
                                currentTime: initialDateTime,
                                locale: LocaleType.vi,
                              );
                            },
                            child: Obx(() {
                              final dateTime = bookController.startDateTime.value;
                              final formattedDateTime = dateTime == null
                                  ? DateFormat('HH:mm dd-MM').format(DateTime.now())
                                  : DateFormat('HH:mm dd-MM').format(dateTime);
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Start',style: CustomTextStyles.tiltle, textAlign: TextAlign.left),
                                  const SizedBox(height: 5,),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: ConstantColors.primary,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.access_time, size: 20.0, color: ConstantColors.primary),
                                        SizedBox(width: 8.0),
                                        Expanded(
                                          child: Text(
                                            formattedDateTime,
                                            style: TextStyle(fontSize: 16.0),
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Obx(() {
                        if (bookController.isRoundTrip.value) {
                          return GestureDetector(
                            onTap: () async {
                              DateTime initialDateTime = bookController.returnDateTime.value ??
                                  DateTime.now().add(Duration(minutes: 30));
                              DatePicker.showDateTimePicker(
                                context,
                                showTitleActions: true,
                                minTime: DateTime.now(),
                                maxTime: DateTime(2101),
                                onConfirm: (dateTime) {
                                  bookController.setReturnDateTime(dateTime);
                                },
                                currentTime: initialDateTime,
                                locale: LocaleType.vi,
                              );
                            },
                            child: Obx(() {
                              final dateTime = bookController.returnDateTime.value;
                              final formattedDateTime = dateTime == null
                                  ? DateFormat('HH:mm dd-MM').format(DateTime.now())
                                  : DateFormat('HH:mm dd-MM').format(dateTime);
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Return',style: CustomTextStyles.tiltle, textAlign: TextAlign.left ,),
                                  const SizedBox(height: 5,),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.redAccent,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.access_time, size: 20.0, color: Colors.redAccent),
                                        SizedBox(width: 8.0),
                                        Expanded(
                                          child: Text(
                                            formattedDateTime,
                                            style: TextStyle(fontSize: 16.0),
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                          );
                        } else {
                          return Container();
                        }
                      }),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ButtonThem.buildIconButton(
                          context,
                          iconSize: 16.0,
                          icon: Icons.arrow_back_ios,
                          iconColor: Colors.black,
                          btnHeight: 40,
                          btnWidthRatio: 0.25,
                          title: "Back".tr,
                          btnColor: ConstantColors.cyan,
                          txtColor: Colors.black,
                          onPress: () {
                            Get.back();
                            tripOptionBottomSheet(context);
                          },
                        ),
                      ),
                      Expanded(
                        child: ButtonThem.buildButton(context,
                            btnHeight: 40,
                            title: "Book Now".tr,
                            btnColor: ConstantColors.primary,
                            txtColor: Colors.white, onPress: () async {
                              /*if (passengerController.text.isEmpty) {
                                  ShowDialog.showToast("Please Enter Passenger".tr);
                                } else if (bookController.departureDate.value == null || bookController.departureTime.value == null) {
                                  ShowDialog.showToast("Please Select Departure Date & Time".tr);
                                } else if (bookController.isRoundTrip.value &&
                                    (bookController.returnDate.value == null || bookController.returnTime.value == null)) {
                                  ShowDialog.showToast("Please Select Return Date & Time".tr);
                                } else {*/
                              await bookController
                                  .getVehicleCategoryModel()
                                  .then((value) {
                                chooseVehicleBottomSheet(context, value);
                              });
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  chooseVehicleBottomSheet(
      BuildContext context, VehicleCategoryModel vehicleCategoryModel) {
    return showModalBottomSheet(
        context: context,
        isDismissible: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Choose Your Vehicle Type".tr,
                      style: CustomTextStyles.header,
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade700,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Image.asset("assets/icons/ic_distance.png",
                                height: 24, width: 24),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text("Distance".tr,
                                  style: CustomTextStyles.normal),
                            )
                          ],
                        ),
                      ),
                      Obx(() => Text(
                        "${bookController.distance.value.toStringAsFixed(2)} ${Constant.distanceUnit}",
                        style: CustomTextStyles.normal_2,
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Image.asset("assets/icons/time.png",
                                height: 24, width: 24),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text("Duration".tr,
                                  style: CustomTextStyles.normal),
                            )
                          ],
                        ),
                      ),
                      Obx(() => Text(
                          "${bookController.duration.value.toStringAsFixed(2)} ${Constant.durationUnit}",
                          style: CustomTextStyles.normal_2)),
                    ],
                  ),
                  Divider(
                    color: Colors.grey.shade700,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: vehicleCategoryModel.data!.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Obx(
                              () => InkWell(
                            onTap: () {
                              bookController.vehicleData =
                              vehicleCategoryModel.data![index];
                              bookController.selectedVehicle.value =
                                  vehicleCategoryModel.data![index].id
                                      .toString();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: bookController.selectedVehicle.value ==
                                      vehicleCategoryModel.data![index].id
                                          .toString()
                                      ? ConstantColors.primary
                                      : Colors.black.withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(
                                                  vehicleCategoryModel
                                                      .data![index].libelle
                                                      .toString(),
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: bookController
                                                        .selectedVehicle
                                                        .value ==
                                                        vehicleCategoryModel
                                                            .data![index].id
                                                            .toString()
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(top: 5),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  /*Obx(() => Text(
                                                      bookController.duration.value,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        color: bookController.selectedVehicle.value ==
                                                            vehicleCategoryModel.data![index].id.toString()
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ),
                                                    )),*/
                                                  Obx(() => Text(
                                                    Constant().amountShow(
                                                        amount:
                                                        "${bookController.calculateTripPrice(
                                                          distance:
                                                          bookController
                                                              .distance
                                                              .value,
                                                          deliveryCharges: double.parse(
                                                              vehicleCategoryModel
                                                                  .data![index]
                                                                  .deliveryCharges!),
                                                          minimumDeliveryCharges:
                                                          double.parse(
                                                              vehicleCategoryModel
                                                                  .data![
                                                              index]
                                                                  .minimumDeliveryCharges!),
                                                          minimumDeliveryChargesWithin:
                                                          double.parse(
                                                              vehicleCategoryModel
                                                                  .data![
                                                              index]
                                                                  .minimumDeliveryChargesWithin!),
                                                        )}"),
                                                    textAlign:
                                                    TextAlign.center,
                                                    style: TextStyle(
                                                      color: bookController
                                                          .selectedVehicle
                                                          .value ==
                                                          vehicleCategoryModel
                                                              .data![
                                                          index]
                                                              .id
                                                              .toString()
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  )),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
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
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ButtonThem.buildIconButton(
                            context,
                            iconSize: 16.0,
                            icon: Icons.arrow_back_ios,
                            iconColor: Colors.black,
                            btnHeight: 40,
                            btnWidthRatio: 0.25,
                            title: "Back".tr,
                            btnColor: ConstantColors.cyan,
                            txtColor: Colors.black,
                            onPress: () {
                              Get.back();
                              tripOptionBottomSheet(context);
                            },
                          ),
                        ),
                        Expanded(
                          child: ButtonThem.buildButton(
                            context,
                            btnHeight: 40,
                            title: "Book Now".tr,
                            btnColor: ConstantColors.primary,
                            txtColor: Colors.white,
                            onPress: () async {
                              // Your booking logic here
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
