import 'dart:developer';

import 'package:customerapp/views/longtrip_screen/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import '../../controllers/book_controller.dart';
import '../../utils/themes/text_style.dart';
import '../airport_screen/airport_mapscreen.dart';

class LongTripScreen extends StatefulWidget {

  const LongTripScreen({super.key});

  @override
  State<LongTripScreen> createState() => _LongTripScreenState();
}

class _LongTripScreenState extends State<LongTripScreen> {

  final bookController = Get.find<BookController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'where do you want to go?'.tr,
          style: CustomTextStyles.header.copyWith(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pickup TextField
            buildTextField(
              controller: bookController.pickupController,
              textObserver: bookController.pickupText,
              prefixIcon: const Icon(
                Icons.location_on,
                size: 20,
                color: Colors.redAccent,
              ),
              hintText: 'from'.tr,
              onClear: () {
                bookController.pickupController.clear();
                bookController.pickupLatLong.value = null;
                bookController.clearData();
              },
              onGetCurrentLocation: () => _getCurrentLocation(true),
              focusedFieldName: 'pickup',
            ),
            const Divider(),
            Obx(() => Column(
              children: List.generate(
                bookController.stopoverControllers.length,
                    (index) {
                  return Column(
                    children: [
                      buildTextField(
                        controller:
                        bookController.stopoverControllers[index],
                        prefixIcon: const Icon(
                          Icons.pin_drop,
                          size: 20,
                          color: Colors.amber,
                        ),
                        hintText: 'Stopover ${index + 1}',
                        onClear: () {
                          bookController.stopoverControllers[index].clear();
                        },
                        onDeleteStop: () {
                          bookController.removeStopover(index);
                          if (bookController.stopoverLatLng.length >
                              index + 1) {
                            bookController.stopoverLatLng
                                .removeAt(index + 1);
                          }
                        },
                        textObserver: bookController.stopoverTexts[index],
                        focusedFieldName: 'stopover_$index'.tr,
                      ),
                      const Divider(),
                    ],
                  );
                },
              ),
            )),
            // Destination TextField
            buildTextField(
              controller: bookController.destinationController,
              textObserver: bookController.destinationText,
              prefixIcon: const Icon(
                Icons.flag_circle,
                size: 20,
                color: Colors.cyan,
              ),
              hintText: 'to'.tr,
              onClear: () {
                bookController.destinationController.clear();
                bookController.destinationLatLong.value = null;
                bookController.clearData();
              },
              focusedFieldName: 'destination',
            ),
            const SizedBox(height: 10.0),
            TextButton(
              onPressed: () {
                bookController.addStopover();
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.add_circle,
                    color: Colors.blue,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'add stopover'.tr,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Popular Destinations'.tr,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Obx(() {
                final isStaticList = (bookController.focusedField.value == 'pickup' &&
                    bookController.pickupController.text.isEmpty) ||
                    (bookController.focusedField.value == 'destination' &&
                        bookController.destinationController.text.isEmpty) ||
                    (bookController.focusedField.value.startsWith('stopover_') &&
                        bookController.stopoverControllers.isNotEmpty &&
                        bookController
                            .stopoverControllers[int.parse(bookController.focusedField.value
                            .split('_')[1])]
                            .text
                            .isEmpty);

                final suggestions = isStaticList
                    ? bookController.staticSuggestions
                    : bookController.suggestions;

                final displaySuggestions = suggestions.isEmpty
                    ? bookController.staticSuggestions
                    : suggestions;

                return ListView.builder(
                  itemCount: displaySuggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = displaySuggestions[index];
                    return ListTile(
                      leading: const Icon(Icons.pin_drop_outlined, color: Colors.blue),
                      title: Text(suggestion['display']!),
                      onTap: () async {
                        final selectedText = suggestion['display']!;
                        LatLng? latLong;
                        if (isStaticList) {
                          latLong = LatLng(suggestion['lat'], suggestion['lng']);
                        } else {
                          latLong = await bookController.reverseGeocode(suggestion['ref_id']!);
                        }
                        if (bookController.focusedField.value == 'pickup') {
                          bookController.pickupController.text = selectedText;
                          bookController.pickupLatLong.value = latLong;
                        } else if (bookController.focusedField.value == 'destination') {
                          bookController.destinationController.text = selectedText;
                          bookController.destinationLatLong.value = latLong;
                          bookController.isMapDrawn.value = true;
                          Get.to(() => const LongTripMapScreen(),
                              duration: const Duration(milliseconds: 400),
                              transition: Transition.rightToLeft);
                        } else if (bookController.focusedField.value.startsWith('stopover_')) {
                          try {
                            final index = int.parse(bookController.focusedField.value.split('_')[1]);
                            while (bookController.stopoverControllers.length <= index) {
                              bookController.stopoverControllers.add(TextEditingController());
                            }
                            while (bookController.stopoverLatLng.length <= index) {
                              bookController.stopoverLatLng.add(const LatLng(0, 0));
                            }
                            bookController.stopoverControllers[index].text = selectedText;
                            bookController.stopoverLatLng[index] = latLong!;
                          } catch (e) {
                            log('$e');
                          }
                        }
                        bookController.suggestions.clear();
                        FocusScope.of(context).unfocus();
                      },
                    );
                  },
                );
              }),
            ),

          ],
        ),
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
    void Function()? onFocus,
    void Function()? onDeleteStop,
    required String focusedFieldName,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      child: Obx(() {
        return Focus(
          onFocusChange: (hasFocus) {
            if (hasFocus) {
              bookController.focusedField.value = focusedFieldName;
              if (onFocus != null) {
                onFocus();
              }
            }
          },
          child: TextField(
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            onChanged: (pattern) async {
              if (controller == bookController.destinationController) {
                bookController.suggestions.value = await bookController
                    .getAutocompleteData(pattern.isEmpty ? 'San bay' : pattern);
              } else {
                bookController.suggestions.value =
                await bookController.getAutocompleteData(pattern);
              }
            },
          ),
        );
      }),
    );
  }

  Future<void> _getCurrentLocation(bool pickup) async {
    final current = await bookController.currentLocation();
    if (current != null) {
      bookController.pickupController.text = current['display'];
      bookController.pickupController.selection =
          TextSelection.fromPosition(const TextPosition(offset: 0));
    }
  }
}
