import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import '../../controllers/book_controller.dart';
import '../../utils/themes/text_style.dart';
import 'map_screen.dart';

class AirportScreen1 extends StatefulWidget {
  const AirportScreen1({super.key});

  @override
  State<AirportScreen1> createState() => _AirportScreen1State();
}

class _AirportScreen1State extends State<AirportScreen1> {

  final bookController = Get.find<BookController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Ban muon di dau ?',
          style: CustomTextStyles.header,
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
            // Stopover TextFields
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
                  Icon(
                    Icons.add_circle,
                    color: Colors.blue,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'add stopover'.tr,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Điểm đến phổ biến',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: bookController.suggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = bookController.suggestions[index];
                    return ListTile(
                      leading: const Icon(Icons.pin_drop_outlined,
                          color: Colors.blue),
                      title: Text(suggestion['display']!),
                      onTap: () async {
                        final selectedText = suggestion['display']!;
                        LatLng? latLong = await bookController
                            .reverseGeocode(suggestion['ref_id']!);
                        if (bookController.focusedField.value == 'pickup') {
                          bookController.pickupController.text = selectedText;
                          bookController.pickupLatLong.value = latLong;
                        } else if (bookController.focusedField.value ==
                            'destination') {
                          bookController.destinationController.text =
                              selectedText;
                          bookController.destinationLatLong.value = latLong;
                          bookController.isMapDrawn.value = true;
                          Get.to(() => const MapScreen(),
                              duration: const Duration(milliseconds: 400),
                              transition: Transition.rightToLeft);
                        } else if (bookController.focusedField.value
                            .startsWith('stopover_')) {
                          try {
                            final index = int.parse(bookController
                                .focusedField.value
                                .split('_')[1]);
                            while (bookController.stopoverControllers.length <=
                                index) {
                              bookController.stopoverControllers
                                  .add(TextEditingController());
                            }
                            while (
                                bookController.stopoverLatLng.length <= index) {
                              bookController.stopoverLatLng.add(LatLng(0, 0));
                            }
                            bookController.stopoverControllers[index].text =
                                selectedText;
                            bookController.stopoverLatLng[index] = latLong!;
                          } catch (e) {
                            debugPrint('$e');
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
