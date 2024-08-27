/*
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:vietmap_flutter_plugin/vietmap_flutter_plugin.dart';

import '../../constant/constant.dart';
import '../../controllers/booking_controller.dart';
import '../../utils/themes/button.dart';
import '../../utils/themes/contant_colors.dart';
import '../../utils/themes/text_style.dart';
import '../../utils/themes/textfield_theme.dart';

class AirportScreen extends StatefulWidget {
  @override
  _AirportScreenState createState() => _AirportScreenState();
}

class _AirportScreenState extends State<AirportScreen> {
  final bookController = Get.find<BookingController>();

  String apiKey = Constant.VietMapApiKey;

  final CameraPosition _kInitialPosition =
      const CameraPosition(target: LatLng(10.762317, 106.654551), zoom: 15);

  final TextEditingController pickupController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  final GlobalKey pickupKey = GlobalKey();
  final GlobalKey destinationKey = GlobalKey();

  VietmapController? _mapController;

  LatLng? pickupLatLong;
  LatLng? destinationLatLong;

  final Map<String, StaticMarkerLayer> _markers = {};

  final Location currentLocation = Location();

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
      appBar: AppBar(
        title: Text(
          'Booking'.tr,
          style: CustomTextStyles.header,
        ),
        backgroundColor: ConstantColors.primary,
      ),
      body: Stack(children: [
        VietmapGL(
          dragEnabled: true,
          compassEnabled: false,
          trackCameraPosition: true,
          myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
          myLocationEnabled: true,
          minMaxZoomPreference: MinMaxZoomPreference(0, 18),
          rotateGesturesEnabled: false,
          styleString:
              '${Constant.baseUrl}/maps/light/styles.json?apikey=${Constant.VietMapApiKey}',
          initialCameraPosition: _kInitialPosition,
          onMapCreated: (VietmapController controller) async {
            LocationData location = await currentLocation.getLocation();
            setState(() {
              _mapController = controller;
              _mapController!.moveCamera(CameraUpdate.newLatLngZoom(
                  LatLng(location.latitude ?? 0.0, location.longitude ?? 0.0),
                  14));
            });
          },
        ),
        for (var layer in _markers.values) layer,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            "assets/icons/ic_pic_drop_location.png",
                            height: 80,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                            onTap: () {},
                                            child: buildPickupTypeAhead()),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  InkWell(
                                    child: buildDestinationTypeAhead(),
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
          ],
        )
      ]),
    );
  }

  Future<void> _getCurrentLocation(bool pickup) async {
    final current = await bookController.getCurrentLocation();
    if (current != null) {
      pickupController.text = current['address'];
    }
  }

  setPickUpMarker(LatLng pickup) {
    pickupLatLong = pickup;
    setState(() {
      _markers.remove('Pickup');
      if (_mapController != null)
      _markers['Pickup'] = StaticMarkerLayer(
          ignorePointer: true,
          mapController: _mapController!,
          markers: [
            StaticMarker(child:Container(
          width: 50,
          height: 50,
          child:Icon(Icons.location_on, color: Colors.red,)), latLng:  LatLng(pickup.latitude, pickup.longitude), bearing: 0),
          ]);
    });
    _mapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(pickup.latitude, pickup.longitude), zoom: 14)));
    if (pickupLatLong != null && destinationLatLong != null) {
      conformationBottomSheet(context);
    }
  }

  setDestinationMaker(LatLng destination) {
    setState(() {
      _markers.remove('Destination');
      if (_mapController != null)
        _markers['Destination'] = StaticMarkerLayer(
            ignorePointer: true,
            mapController: _mapController!,
            markers: [
              StaticMarker(child:Container(
                  width: 50,
                  height: 50,
                  child:Icon(Icons.location_on, color: Colors.red,)), latLng:  LatLng(destination.latitude, destination.longitude), bearing: 0),
            ]);
    });
    destinationLatLong = destination;
    _mapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(destination.latitude, destination.longitude),
        zoom: 14)));
    if (pickupLatLong != null && destinationLatLong != null) {
      conformationBottomSheet(context);
    }
  }

  Widget buildPickupTypeAhead() {
    return TypeAheadField<Map<String, String>>(
      controller: pickupController,
      hideOnEmpty: true,
      hideOnLoading: true,
      hideKeyboardOnDrag: true,
      builder: (context, controller, focusNode) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          autofocus: true,
          onChanged: (text) {},
          decoration: InputDecoration(
            isDense: true,
            suffixIcon: pickupController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      pickupController.clear();
                      pickupLatLong = null;
                      setState(() {});
                    },
                  )
                : IconButton(
                    icon: Icon(
                      Icons.my_location,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      _getCurrentLocation(true);
                    }),
            hintText: 'From',
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        );
      },
      suggestionsCallback: (pattern) async {
        return await bookController.getAutocompleteData(pattern);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          leading: Icon(Icons.pin_drop_outlined, color: Colors.blue),
          title: Text(suggestion['display']!),
        );
      },
      onSelected: (suggestion) async {
        pickupController.text = suggestion['display']!;
        pickupLatLong =
            await bookController.reverseGeocode(suggestion['ref_id']!);
        pickupController.selection =
            TextSelection.fromPosition(const TextPosition(offset: 0));
        FocusScope.of(context).unfocus();
        bookController.suggestions.clear();
        setPickUpMarker(pickupLatLong!);
      },
    );
  }

  Widget buildDestinationTypeAhead() {
    return TypeAheadField<Map<String, String>>(
      controller: destinationController,
      hideOnEmpty: true,
      hideOnLoading: true,
      hideKeyboardOnDrag: true,
      builder: (context, controller, focusNode) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          autofocus: true,
          onChanged: (text) {},
          decoration: InputDecoration(
            isDense: true,
            suffixIcon: destinationController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      destinationController.clear();
                      destinationLatLong = null;
                    },
                  )
                : Icon(
                    Icons.access_time_outlined,
                    color: Colors.white,
                  ),
            hintText: 'To',
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        );
      },
      suggestionsCallback: (pattern) async {
        return await bookController.getAutocompleteData(pattern);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          leading: Icon(Icons.pin_drop_outlined, color: Colors.blue),
          title: Text(suggestion['display']!),
        );
      },
      onSelected: (suggestion) async {
        destinationController.text = suggestion['display']!;
        destinationLatLong =
            await bookController.reverseGeocode(suggestion['ref_id']!);
        destinationController.selection =
            TextSelection.fromPosition(TextPosition(offset: 0));
        FocusScope.of(context).unfocus();
        bookController.suggestions.clear();
        setDestinationMaker(destinationLatLong!);
      },
    );
  }

  conformationBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        context: context,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
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
                        title: "Back",
                        btnColor: ConstantColors.cyan,
                        txtColor: Colors.black, onPress: () {
                      Get.back();
                    }),
                  ),
                  Expanded(
                    child: ButtonThem.buildButton(context,
                        btnHeight: 40,
                        title: "Continue".tr,
                        btnColor: ConstantColors.primary,
                        txtColor: Colors.white, onPress: () {
                      debugPrint("Hello Trip");
                      tripOptionBottomSheet(context);
                    }),
                  ),
                ],
              ),
            );
          });
        });
  }

  tripOptionBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            margin: const EdgeInsets.all(10),
            child: StatefulBuilder(builder: (context, setState) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                child: Obx(
                  () => Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "Trip option",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 1.0),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: DropdownButton<String>(
                                items: <String>[
                                  'General',
                                  'Business',
                                  'Executive',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  ); //DropMenuItem
                                }).toList(),
                                value: bookController.tripOptionCategory.value,
                                onChanged: (newValue) {
                                  bookController.tripOptionCategory.value =
                                      newValue!;
                                },
                                underline: Container(),
                                //OnChange
                                isExpanded: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        });
  }
}
*/
