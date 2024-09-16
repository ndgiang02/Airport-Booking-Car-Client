import 'package:customerapp/utils/themes/custom_dialog_box.dart';
import 'package:customerapp/utils/themes/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

import '../../constant/constant.dart';
import '../../constant/show_dialog.dart';
import '../../controllers/booking_controller.dart';
import '../../models/vehicle_model.dart';
import '../../utils/preferences/preferences.dart';
import '../../utils/themes/button.dart';
import '../../utils/themes/contant_colors.dart';
import '../../utils/themes/dialog_box.dart';

class AirportScreen extends StatefulWidget {
  const AirportScreen({super.key});

  @override
  _AirportScreenState createState() => _AirportScreenState();
}

class _AirportScreenState extends State<AirportScreen> {
  final bookController = Get.put(BookingController());

  String apiKey = Constant.VietMapApiKey;

  final Location currentLocation = Location();

  final CameraPosition _kInitialPosition =
      const CameraPosition(target: LatLng(10.762317, 106.654551));

  VietmapController? _mapController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        controller: bookController.pickupController,
                        textObserver: bookController.pickupText,
                        prefixIcon: const Icon(
                          Icons.location_on,
                          size: 20,
                          color: Colors.redAccent,
                        ),
                        hintText: 'From',
                        onClear: () {
                          bookController.pickupController.clear();
                          bookController.pickupLatLong.value = null;
                          if (bookController.points.isNotEmpty) {
                            bookController.points.removeAt(0);
                          }
                          bookController.clearData();
                          _mapController?.clearLines();
                          _mapController?.clearSymbols();
                          if (bookController.points.isNotEmpty) {
                            bookController.fetchRouteData();
                            bookController.addPolyline(_mapController);
                          }
                          debugPrint(
                              "Cancel ${bookController.pickupLatLong.value}");
                        },
                        onGetCurrentLocation: () => _getCurrentLocation(true),
                      ),
                      const Divider(),
                      Obx(() => Column(
                            children: List.generate(
                                bookController.stopoverControllers.length,
                                (index) {
                              return Column(
                                children: [
                                  buildTextField(
                                    controller: bookController
                                        .stopoverControllers[index],
                                    prefixIcon: const Icon(
                                      Icons.pin_drop,
                                      size: 20,
                                      color: Colors.amber,
                                    ),
                                    hintText: 'Stopover ${index + 1}',
                                    onClear: () {
                                      bookController.stopoverControllers[index]
                                          .clear();
                                      if (bookController.points.length >
                                          index + 1) {
                                        bookController.points
                                            .removeAt(index + 1);
                                      }
                                      bookController.clearData();
                                      _mapController?.clearLines();
                                      _mapController?.clearSymbols();
                                      if (bookController.points.isNotEmpty) {
                                        bookController.fetchRouteData();
                                        bookController
                                            .addPolyline(_mapController);
                                      }
                                    },
                                    onDeleteStop: () {
                                      bookController.removeStopover(index);

                                      if (bookController.points.length >
                                          index + 1) {
                                        bookController.points
                                            .removeAt(index + 1);
                                      }

                                      bookController.clearData();
                                      _mapController?.clearLines();
                                      _mapController?.clearSymbols();

                                      if (bookController.points.isNotEmpty) {
                                        bookController.fetchRouteData();
                                        bookController
                                            .addPolyline(_mapController);
                                      }
                                    },
                                    textObserver:
                                        bookController.stopoverTexts[index],
                                  ),
                                  const Divider(),
                                ],
                              );
                            }),
                          )),
                      buildTextField(
                        controller: bookController.destinationController,
                        textObserver: bookController.destinationText,
                        prefixIcon: const Icon(
                          Icons.flag_circle,
                          size: 20,
                          color: Colors.cyan,
                        ),
                        hintText: 'To',
                        onClear: () {
                          bookController.destinationController.clear();
                          bookController.destinationLatLong.value = null;

                          if (bookController.points.isNotEmpty) {
                            bookController.points.removeLast();
                          }
                          bookController.clearData();
                          _mapController?.clearLines();
                          _mapController?.clearSymbols();
                          if (bookController.points.isNotEmpty) {
                            bookController.fetchRouteData();
                            bookController.addPolyline(_mapController);
                          }
                        },
                      ),
                      TextButton(
                        onPressed: () {
                          bookController.addStopover();
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
    RxString? textObserver,
    Widget? prefixIcon,
    void Function()? onClear,
    void Function()? onGetCurrentLocation,
    void Function()? onDeleteStop,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      child: Obx(() {
        return TypeAheadField<Map<String, String>>(
          hideOnEmpty: true,
          hideOnLoading: true,
          textFieldConfiguration: TextFieldConfiguration(
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              suffixIcon: textObserver?.value.isNotEmpty ?? false
                  ? IconButton(
                      icon: const Icon(Icons.cancel,
                          color: Colors.grey, size: 20),
                      onPressed: onClear,
                    )
                  : onDeleteStop != null
                      ? IconButton(
                          icon: const Icon(Icons.clear,
                              color: Colors.grey, size: 20),
                          onPressed: onDeleteStop,
                        )
                      : onGetCurrentLocation != null
                          ? IconButton(
                              icon: const Icon(Icons.my_location,
                                  color: Colors.grey, size: 20),
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
            if (controller == bookController.destinationController) {
              if (pattern.isEmpty) {
                return await bookController.getAutocompleteData('San bay');
              } else {
                return await bookController.getAutocompleteData(pattern);
              }
            } else {
              return await bookController.getAutocompleteData(pattern);
            }
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
            if (controller == bookController.pickupController) {
              bookController.setPickUpMarker(latLong!, _mapController);
            } else if (bookController.stopoverControllers
                .contains(controller)) {
              bookController.setStopoverMarker([latLong!], _mapController);
            } else {
              bookController.setDestinationMarker(latLong!, _mapController);
            }
          },
        );
      }),
    );
  }

  Future<void> _getCurrentLocation(bool pickup) async {
    final current = await bookController.getCurrentLocation(_mapController!);
    if (current != null) {
      bookController.pickupController.text = current['display'];
      bookController.pickupController.selection =
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
      isScrollControlled: true,
      isDismissible: false,
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
                const Divider(),
                Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // Space between the title and switch
                    children: [
                      Text(
                        "Round Trip".tr,
                        style: CustomTextStyles.normal,
                      ),
                      Switch(
                        activeColor: Colors.cyan,
                        inactiveTrackColor: Colors.grey.shade50,
                        value: bookController.isRoundTrip.value,
                        onChanged: (bool value) {
                          bookController.setRoundTrip(value);
                        },
                      ),
                    ],
                  );
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Passenger ",
                      style: CustomTextStyles.normal,
                    ),
                    SizedBox(width: 10),
                    Obx(() => DropdownButton<int>(
                          value: bookController.selectedPassengerCount.value,
                          iconEnabledColor: Colors.green,
                          iconDisabledColor: Colors.grey,
                          items: List.generate(10, (index) {
                            return DropdownMenuItem<int>(
                              value: index + 1,
                              child: Text('${index + 1}'),
                            );
                          }),
                          icon: Icon(
                            Icons.person,
                            color: ConstantColors.primary,
                          ),
                          onChanged: (value) {
                            if (value != null) {
                              bookController.selectedPassengerCount.value =
                                  value;
                            }
                          },
                          borderRadius:
                              BorderRadius.all(Radius.circular(8.0)), //,
                        )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              DateTime initialDateTime =
                                  bookController.startDateTime.value ??
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
                              final dateTime =
                                  bookController.startDateTime.value;
                              final formattedDateTime = dateTime == null
                                  ? DateFormat('HH:mm dd-MM')
                                      .format(DateTime.now())
                                  : DateFormat('HH:mm dd-MM').format(dateTime);
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Start',
                                      style: CustomTextStyles.title,
                                      textAlign: TextAlign.left),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 12.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: ConstantColors.primary,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.access_time,
                                            size: 20.0,
                                            color: ConstantColors.primary),
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
                              DateTime initialDateTime =
                                  bookController.returnDateTime.value ??
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
                              final dateTime =
                                  bookController.returnDateTime.value;
                              final formattedDateTime = dateTime == null
                                  ? DateFormat('HH:mm dd-MM')
                                      .format(DateTime.now())
                                  : DateFormat('HH:mm dd-MM').format(dateTime);
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Return',
                                    style: CustomTextStyles.title,
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 12.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.redAccent,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.access_time,
                                            size: 20.0,
                                            color: Colors.redAccent),
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
                            confirmWidget();
                          },
                        ),
                      ),
                      Expanded(
                        child: ButtonThem.buildButton(context,
                            btnHeight: 40,
                            title: "Book Now".tr,
                            btnColor: ConstantColors.primary,
                            txtColor: Colors.white, onPress: () async {
                          if (bookController.startDateTime.value == null ||
                              bookController.startDateTime.value == null) {
                            ShowDialog.showToast(
                                "Please Select Start Date Time".tr);
                          } else if (bookController.isRoundTrip.value &&
                              (bookController.returnDateTime.value == null ||
                                  bookController.returnDateTime.value ==
                                      null)) {
                            ShowDialog.showToast(
                                "Please Select Return Date & Time".tr);
                          } else {
                            await bookController
                                .getVehicleCategoryModel()
                                .then((value) {
                              chooseVehicleBottomSheet(context, value);
                            });
                          }
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
        enableDrag: true,
        isDismissible: false,
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
                            const Icon(
                                color: Colors.black12,
                                Icons.social_distance_outlined,
                                size: 20),
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
                            style: CustomTextStyles.body,
                          )),
                    ],
                  ),
                  Divider(
                    indent: 10,
                    endIndent: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(
                                color: Colors.red, Icons.timer_sharp, size: 20),
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
                          style: CustomTextStyles.normal)),
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
                                                      .data![index].name
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
                                                  Obx(() => Text(
                                                    'Hello',
                                                        /*Constant().amountShow(
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
                                                        )}"),*/
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
                              bookController.isMapDrawn.value = false;
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomDialogBox(
                                      title: "",
                                      descriptions:
                                          "Your booking has been sent successfully",
                                      onPress: () {
                                        Get.back();
                                      },
                                      img: Image.asset(
                                          'assets/images/green_checked.png'),
                                    );
                                  });
                              List stopsList = [];
                              /* for (var i = 0; i < controller.multiStopListNew.length; i++) {
                                stopsList.add({
                                  "latitude": controller.multiStopListNew[i].latitude.toString(),
                                  "longitude": controller.multiStopListNew[i].longitude.toString(),
                                  "location": controller.multiStopListNew[i].editingController.text.toString()
                                });
                              }*/

                              Map<String, dynamic> bodyParams = {
                                'user_id':
                                    Preferences.getInt(Preferences.userId)
                                        .toString(),
                                'lat1': bookController
                                    .pickupLatLong.value!.latitude
                                    .toString(),
                                'lng1': bookController
                                    .destinationLatLong.value!.longitude
                                    .toString(),
                                'lat2': bookController
                                    .pickupLatLong.value!.latitude
                                    .toString(),
                                'lng2': bookController
                                    .destinationLatLong.value!.longitude
                                    .toString(),
                                //'cout': tripPrice.toString(),
                                'distance': bookController.distance.toString(),
                                'distance_unit':
                                    Constant.distanceUnit.toString(),
                                'duree': bookController.duration.toString(),
                                'depart_name':
                                    bookController.pickupController.text,
                                'destination_name':
                                    bookController.destinationController.text,
                                'stops': stopsList,
                                'place': '',
                                'number_poeple': bookController
                                    .selectedPassengerCount
                                    .toString(),
                                'image': '',
                                'image_name': "",
                                'statut_round': 'no',
                                // 'trip_objective': bookController.tripOptionCategory.value,
                              };

                              /*  bookController.bookRide(bodyParams).then((value) {
                                if (value != null) {
                                  if (value['success'] == "success") {
                                    Get.back();
                                    bookController.pickupController.clear();
                                    bookController.destinationController.clear();
                                    bookController.polylinePoints.clear();
                                    bookController.pickupLatLong.value = null;
                                    bookController.destinationLatLong.value = null;
                                    //passengerController.clear();
                                    //tripPrice = 0.0;
                                    bookController.clearData();
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CustomDialogBox(
                                            title: "",
                                            descriptions: "Your booking has been sent successfully",
                                            onPress: () {
                                              Get.back();
                                            },
                                            img: Image.asset('assets/images/green_checked.png'),
                                          );
                                        });
                                  }
                                }
                              });*/
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
