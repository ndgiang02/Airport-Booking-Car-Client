import 'package:customerapp/controllers/cluster_controller.dart';
import 'package:customerapp/views/cluster_screen/cluster_mapscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import '../../utils/themes/text_style.dart';

class ClusterScreen extends StatefulWidget {
  const ClusterScreen({super.key});

  @override
  State<ClusterScreen> createState() => _ClusterScreenState();
}

class _ClusterScreenState extends State<ClusterScreen> {

  final clusterController = Get.find<ClusterController>();

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
              controller: clusterController.pickupController,
              textObserver: clusterController.pickupText,
              prefixIcon: const Icon(
                Icons.location_on,
                size: 20,
                color: Colors.redAccent,
              ),
              hintText: 'from'.tr,
              onClear: () {
                clusterController.pickupController.clear();
                clusterController.pickupLatLong.value = null;
                clusterController.clearData();
              },
              onGetCurrentLocation: () => _getCurrentLocation(true),
              focusedFieldName: 'pickup',
            ),
            const Divider(),
            // Destination TextField
            buildTextField(
              controller: clusterController.destinationController,
              textObserver: clusterController.destinationText,
              prefixIcon: const Icon(
                Icons.flag_circle,
                size: 20,
                color: Colors.cyan,
              ),
              hintText: 'to'.tr,
              onClear: () {
                clusterController.destinationController.clear();
                clusterController.destinationLatLong.value = null;
                clusterController.clearData();
              },
              focusedFieldName: 'destination',
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Điểm đến phổ biến',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Obx(() {
                final isStaticList = (clusterController.focusedField.value == 'pickup' &&
                    clusterController.pickupController.text.isEmpty) ||
                    (clusterController.focusedField.value == 'destination' &&
                        clusterController.destinationController.text.isEmpty);

                final suggestions = isStaticList
                    ? clusterController.staticSuggestions
                    : clusterController.suggestions;

                final displaySuggestions = suggestions.isEmpty
                    ? clusterController.staticSuggestions
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
                          latLong = await clusterController.reverseGeocode(suggestion['ref_id']!);
                        }
                        if (clusterController.focusedField.value == 'pickup') {
                          clusterController.pickupController.text = selectedText;
                          clusterController.pickupLatLong.value = latLong;
                        } else {
                          clusterController.destinationController.text = selectedText;
                          clusterController.destinationLatLong.value = latLong;
                          clusterController.isMapDrawn.value = true;
                          Get.to(() => const ClusterMapScreen(),
                              duration: const Duration(milliseconds: 400),
                              transition: Transition.rightToLeft);
                        }
                        clusterController.suggestions.clear();
                        FocusScope.of(context).unfocus();
                      },
                    );
                  },
                );
              }),
            ),

            /*Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: clusterController.suggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = clusterController.suggestions[index];
                    return ListTile(
                      leading: const Icon(Icons.pin_drop_outlined,
                          color: Colors.blue),
                      title: Text(suggestion['display']!),
                      onTap: () async {
                        final selectedText = suggestion['display']!;
                        LatLng? latLong = await clusterController
                            .reverseGeocode(suggestion['ref_id']!);
                        if (clusterController.focusedField.value == 'pickup') {
                          clusterController.pickupController.text = selectedText;
                          clusterController.pickupLatLong.value = latLong;
                        } else if (clusterController.focusedField.value ==
                            'destination') {
                          clusterController.destinationController.text =
                              selectedText;
                          clusterController.destinationLatLong.value = latLong;
                          clusterController.isMapDrawn.value = true;
                          Get.to(() => const MapScreen(),
                              duration: const Duration(milliseconds: 400),
                              transition: Transition.rightToLeft);
                        } else if (clusterController.focusedField.value
                            .startsWith('stopover_')) {
                          try {
                            final index = int.parse(clusterController
                                .focusedField.value
                                .split('_')[1]);
                            while (clusterController.stopoverControllers.length <=
                                index) {
                              clusterController.stopoverControllers
                                  .add(TextEditingController());
                            }
                            while (
                                clusterController.stopoverLatLng.length <= index) {
                              clusterController.stopoverLatLng.add(LatLng(0, 0));
                            }
                            clusterController.stopoverControllers[index].text =
                                selectedText;
                            clusterController.stopoverLatLng[index] = latLong!;
                          } catch (e) {
                            debugPrint('$e');
                          }
                        }
                        clusterController.suggestions.clear();
                        FocusScope.of(context).unfocus();
                      },
                    );
                  },
                );
              }),
            ),*/
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
              clusterController.focusedField.value = focusedFieldName;
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
              if (controller == clusterController.destinationController) {
                clusterController.suggestions.value = await clusterController
                    .getAutocompleteData(pattern.isEmpty ? 'San bay' : pattern);
              } else {
                clusterController.suggestions.value =
                await clusterController.getAutocompleteData(pattern);
              }
            },
          ),
        );
      }),
    );
  }

  Future<void> _getCurrentLocation(bool pickup) async {
    final current = await clusterController.currentLocation();
    if (current != null) {
      clusterController.pickupController.text = current['display'];
      clusterController.pickupController.selection =
          TextSelection.fromPosition(const TextPosition(offset: 0));
    }
  }
}
