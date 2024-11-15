import 'package:customerapp/controllers/flight_controller.dart';
import 'package:customerapp/utils/themes/textfield_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

import '../../utils/extensions/load.dart';
import '../../utils/themes/button.dart';
import '../../utils/themes/contant_colors.dart';
import '../../utils/themes/text_style.dart';

class FlightScreen extends StatefulWidget {
  const FlightScreen({super.key});

  @override
  FlightState createState() => FlightState();
}

class FlightState extends State<FlightScreen> {
  final TextEditingController codeController = TextEditingController();

  final homeController = Get.put(FlightController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('show_info_fly'.tr, style: CustomTextStyles.app),
        elevation: 0,
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
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFieldTheme.boxBuildTextField(
                    hintText: 'flight_code'.tr,
                    controller: codeController,
                    onChanged: homeController.updateFlightCode,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: TimePickerSpinnerPopUp(
                    mode: CupertinoDatePickerMode.date,
                    initTime: homeController.date.value,
                    maxTime: DateTime.now().add(const Duration(days: 30)),
                    cancelText: 'cancel'.tr,
                    confirmText: 'yes'.tr,
                    pressType: PressType.singlePress,
                    timeFormat: 'dd-MM-yyyy',
                    onChange: (dateTime) {
                      homeController.date.value = dateTime;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            ButtonThem.buildBorderButton(
              context,
              title: 'fetch'.tr,
              btnBorderColor: ConstantColors.primary,
              btnColor: Colors.white,
              txtColor: ConstantColors.primary,
              onPress: () {
                homeController.fetchFlight(
                  homeController.flightCode.value,
                  homeController.formatDate(homeController.date.value),
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            _buildFlightInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              padding: const EdgeInsets.all(5),
              height: 230,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: child),
        ],
      ),
    );
  }

  Widget _buildFlightInfo() {
    return Obx(() {
      if (homeController.isLoading.value) {
        return _buildInfoBox(
          child: Center(child: Loading()),
        );
      }

      if (homeController.errorMessage.value.isNotEmpty) {
        return _buildInfoBox(child: Text(homeController.errorMessage.value));
      }

      final flightInfo = homeController.flightInfo;

      if (flightInfo.isEmpty) {
        return _buildInfoBox(
          child: Center(child: Text('no_flight_information_available'.tr)),
        );
      }

      return _buildInfoBox(child: _buildFlight(flightInfo));
    });
  }

  Widget _buildFlight(Map<String, dynamic> flightInfo) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
        Row(
          children: [
            Text(flightInfo['departure_iata'] ?? 'Unknown'.tr,
                style: CustomTextStyles.header.copyWith(color: Colors.indigo)),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SizedBox(
                height: 8,
                width: 8,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade400,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Stack(children: [
                      SizedBox(
                        height: 24,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Flex(
                              direction: Axis.horizontal,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                  (constraints.constrainWidth() / 6).floor(),
                                  (index) => SizedBox(
                                        height: 1,
                                        width: 3,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade300),
                                        ),
                                      )),
                            );
                          },
                        ),
                      ),
                      Center(
                          child: Transform.rotate(
                              angle: 1.5,
                              child: Icon(
                                Icons.local_airport,
                                size: 24,
                                color: Colors.indigo.shade300,
                              )))
                    ]))),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SizedBox(
                height: 8,
                width: 8,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.pink.shade400,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            Text(flightInfo['arrival_iata'] ?? 'Unknown'.tr,
                style: CustomTextStyles.header.copyWith(color: Colors.pink))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 100,
              child: Text(flightInfo['departure_city'] ?? 'Unknown'.tr,
                  style: CustomTextStyles.body),
            ),
            Text(
              flightInfo['flnr'] ?? "",
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 100,
              child: Text(flightInfo['arrival_city'] ?? 'Unknown'.tr,
                  textAlign: TextAlign.end, style: CustomTextStyles.body),
            ),
          ],
        ),
        const SizedBox(
          height: 6,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                homeController.convertTo12HourFormat(
                    flightInfo['scheduled_departure_local'] ?? 'Unknown'.tr),
                style: CustomTextStyles.normal),
            Text('plan'.tr, style: CustomTextStyles.body),
            Text(
                homeController.convertTo12HourFormat(
                    flightInfo['scheduled_arrival_local'] ?? 'Unknown'.tr),
                style: CustomTextStyles.normal),
          ],
        ),
        const SizedBox(
          height: 6,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                homeController.convertTo12HourFormat(
                    flightInfo['actual_departure_local'] ?? 'Unknown'.tr),
                style: CustomTextStyles.normal),
            Text('scheduled'.tr, style: CustomTextStyles.normal),
            Text(
                homeController.convertTo12HourFormat(
                    flightInfo['actual_arrival_local'] ?? 'Unknown'.tr),
                style: CustomTextStyles.normal),
          ],
        ),
        const SizedBox(
          height: 2,
        ),
        Expanded(
            child: Padding(
                padding: const EdgeInsets.all(8),
                child: Stack(children: [
                  SizedBox(
                    height: 16,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Flex(
                          direction: Axis.horizontal,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                              (constraints.constrainWidth() / 6).floor(),
                              (index) => SizedBox(
                                    height: 1,
                                    width: 3,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade500),
                                    ),
                                  )),
                        );
                      },
                    ),
                  ),
                ]))),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Icon(
                    Icons.flight_takeoff,
                    color: Colors.lightBlue,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(flightInfo['airline_name'] ?? "Unknown".tr,
                    style: CustomTextStyles.title),
              ],
            ),
            Text(
              homeController.calculateDelay(
                  flightInfo['scheduled_departure_local'] ?? 'Unknown'.tr,
                  flightInfo['actual_departure_local'] ?? 'Unknown'.tr),
              style: CustomTextStyles.normal.copyWith(color: Colors.red),
            ),
          ],
        )
      ]),
    );
  }
}
