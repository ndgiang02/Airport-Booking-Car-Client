import 'package:customerapp/controllers/booking_controller.dart';
import 'package:customerapp/utils/themes/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:location/location.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:vietmap_flutter_plugin/vietmap_flutter_plugin.dart';

import '../../constant/constant.dart';
import '../../utils/themes/button.dart';
import '../../utils/themes/contant_colors.dart';

class LongtripScreen extends StatefulWidget {
  @override
  _AirportScreenState createState() => _AirportScreenState();
}

class _AirportScreenState extends State<LongtripScreen> {
  final controller = Get.find<BookingController>();

  String apiKey = Constant.VietMapApiKey;

  final CameraPosition _kInitialPosition =
      const CameraPosition(target: LatLng(10.762317, 106.654551));

  final TextEditingController pickupController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  final FocusNode pickupFocusNode = FocusNode();
  final FocusNode destinationFocusNode = FocusNode();

  final GlobalKey pickupKey = GlobalKey();
  final GlobalKey destinationKey = GlobalKey();

  //LatLng? currentLocation;

  final Map<String, Marker> _markers = {};

  VietmapController? _mapController;

  LatLng? pickupLatLong;
  LatLng? destinationLatLong;

  final Location currentLocation = Location();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    pickupController.dispose();
    destinationController.dispose();
    pickupFocusNode.dispose();
    destinationFocusNode.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('booking'.tr, style: CustomTextStyles.header),
        backgroundColor: ConstantColors.primary,
      ),
      body: Stack(children: [
        /*VietmapGL(
          myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
          myLocationEnabled: true,
          styleString:
              '${Constant.baseUrl}/maps/light/styles.json?apikey=${Constant.VietMapApiKey}',
          initialCameraPosition: _kInitialPosition,
          onMapCreated: (VietmapController controller) async {
            _mapController = controller;
            LocationData location = await currentLocation.getLocation();
            _mapController!.moveCamera(CameraUpdate.newLatLngZoom(
                LatLng(location.latitude ?? 0.0, location.longitude ?? 0.0),
                14));
          },
        ),*/
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
                                          onTap: () async {},
                                          child: buildTextField(
                                            title: "Pick Up",
                                            textController: pickupController,
                                            suffixIcon: pickupController
                                                    .text.isNotEmpty
                                                ? Icons.clear
                                                : Icons.my_location_outlined,
                                            suffixIconColor: Colors.grey,
                                            onSuffixIconPressed: () {
                                              if (pickupController
                                                  .text.isNotEmpty) {
                                                pickupController.clear();
                                                setState(() {
                                                  pickupController.text = '';
                                                });
                                              } else {
                                                _getCurrentLocation(true);
                                              }
                                            },
                                            onChanged: (value) {
                                              _handlePickupTextChange(value);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  InkWell(
                                    onTap: () {
                                      checkTextFieldsAndShowBottomSheet(
                                          context);
                                    },
                                    child: buildTextField(
                                      title: "Where do you want to go?",
                                      textController: destinationController,
                                      suffixIcon:
                                          destinationController.text.isNotEmpty
                                              ? Icons.clear
                                              : null,
                                      suffixIconColor: Colors.grey,
                                      onSuffixIconPressed: () {
                                        if (destinationController
                                            .text.isNotEmpty) {
                                          destinationController.clear();
                                          setState(() {
                                            destinationController.text = '';
                                          });
                                        }
                                      },
                                      onChanged: (value) {
                                        _handleDestinationTextChange(value);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            icon: SvgPicture.asset(
                              'assets/svg/arrow_swap.svg',
                              color: Colors.cyan,
                              height: 30,
                              width: 30,
                            ),
                            onPressed: () {
                            },
                          ),
                        ],
                      ),
                      Obx(() {
                        if (pickupFocusNode.hasFocus) {
                          return buildSuggestionsList(pickupController);
                        } else if (destinationFocusNode.hasFocus) {
                          return buildSuggestionsList(destinationController);
                        } else {
                          return Container();
                        }
                      })
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

  Widget buildSuggestionsList(TextEditingController Controller) {
    return Obx(() => controller.suggestions.isEmpty
        ? Container()
        : Container(
            height: 200,
            child: ListView.separated(
              itemCount: controller.suggestions.length > 5
                  ? 5
                  : controller.suggestions.length,
              itemBuilder: (context, index) {
                final display = controller.suggestions[index]['display']!;
                return ListTile(
                  leading: Icon(Icons.place, color: Colors.blue),
                  title: Text(display),
                  onTap: () {
                    Controller.text = display;
                    Controller.selection =
                        TextSelection.fromPosition(TextPosition(offset: 0));
                    FocusScope.of(context).unfocus();
                    controller.suggestions.clear();
                  },
                );
              },
              separatorBuilder: (context, index) => Divider(
                height: 0.5,
                color: Colors.grey,
                indent: 10,
                endIndent: 10,
              ),
            ),
          ));
  }

  void _handlePickupTextChange(String value) {
    if (value.isNotEmpty) {
      controller.getAutocompleteData(value);
    } else {
      controller.suggestions.clear();
    }
    setState(() {
      pickupController.text = value;
    });
  }

  void _handleDestinationTextChange(String value) {
    if (value.isNotEmpty) {
      controller.getAutocompleteData(value);
    } else {
      controller.suggestions.clear();
    }
    setState(() {
      destinationController.text = value;
    });
  }

  Widget buildTextField({
    Key? key,
    required title,
    required TextEditingController textController,
    Function(String)? onChanged,
    IconData? suffixIcon,
    Color? suffixIconColor,
    VoidCallback? onSuffixIconPressed,
  }) {
    return TextField(
      key: key,
      controller: textController,
      decoration: InputDecoration(
        isDense: true,
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(suffixIcon, color: suffixIconColor),
                onPressed: onSuffixIconPressed,
              )
            : null,
        hintText: title,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabled: true,
      ),
      onChanged: onChanged,
    );
  }

  Future<void> _getCurrentLocation(bool Pickup) async {
    final current = await controller.getCurrentLocation(_mapController!);
    if (current != null) {
      setState(() {
        pickupController.text = current['address'];
      });
    }
  }

  void checkTextFieldsAndShowBottomSheet(BuildContext context) {
    if (pickupController.text.isNotEmpty &&
        destinationController.text.isNotEmpty) {
      conformationBottomSheet(context);
    }
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
                        txtColor: Colors.white,
                        onPress: () async {}),
                  ),
                ],
              ),
            );
          });
        });
  }
}
