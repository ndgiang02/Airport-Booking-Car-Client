import 'package:customerapp/utils/themes/contant_colors.dart';
import 'package:customerapp/utils/themes/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/activities_controller.dart';
import '../../models/trip_model.dart';
import '../../utils/extensions/load.dart';

class ActivitiesScreen extends StatelessWidget {

  ActivitiesScreen({Key? key}) : super(key: key);

  final ActivitiesController controller = Get.put(ActivitiesController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(width: 8),
                  Text(
                    'Activities',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: const [Colors.blueAccent, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 50,
              child: TabBar(
                indicatorWeight: 1,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.schedule),
                        SizedBox(width: 5),
                        Text(
                          'Sắp tới',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history),
                        SizedBox(width: 5),
                        Text(
                          'Lịch sử',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                labelColor: ConstantColors.primary,
                unselectedLabelColor: Colors.grey,
                indicatorColor: ConstantColors.primary,
                labelPadding: EdgeInsets.symmetric(horizontal: 5.0),
                onTap: (index) {
                  controller.updateIndex(index);
                },
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: Loading());
                }

                return TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    buildTripList(controller.upcomingTrips),
                    buildTripList(controller.historyTrips),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTripList(List<Trip> trips) {
    if (trips.isEmpty) {
      return Center(child: Text("Không có chuyen di nao"));
    }
    return ListView.builder(
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        String formattedTime = DateFormat('HH:mm, dd/MM').format(trip.scheduledTime!);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First Row: Time and Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formattedTime,
                        style: CustomTextStyles.regular,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusInfo(trip.tripStatus)['backgroundColor'],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getStatusInfo(trip.tripStatus)['statusText'],
                          style: TextStyle(
                            fontSize: 14,
                            color: _getStatusInfo(trip.tripStatus)['textColor'],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      // Icon
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.local_taxi,
                          color: Colors.blue[500],
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Addresses
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.circle, size: 10, color: Colors.blue),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    _getLimitedText(trip.fromAddress, 25),
                                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.circle, size: 10, color: Colors.orange),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    _getLimitedText(trip.toAddress, 25),
                                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Price
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            trip.totalAmount != null
                                ? NumberFormat('#,###').format(trip.totalAmount)
                                : '0.00',
                            style: CustomTextStyles.normal,
                          ),

                          const SizedBox(width: 2),
                          Image.asset(
                            'assets/icons/dong.png',
                            width: 16.0,
                            height: 16.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Third Row: Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        trip.tripType == 'airport' ? 'airport'.tr : 'longtrip'.tr,
                        style: CustomTextStyles.normal,
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Handle "Chi tiết"
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
                            ),
                            child: const Row(
                              children: [
                                Text('Chi tiết', style: TextStyle(color: Colors.black)),
                                Icon(Icons.chevron_right_rounded, color: Colors.black),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getLimitedText(String? text, int maxLength) {
    if (text == null || text.length <= maxLength) {
      return text ?? '';
    }
    return text.substring(0, maxLength) + '...';
  }

  Map<String, dynamic> _getStatusInfo(String? status) {
    switch (status) {
      case 'requested':
        return {
          'backgroundColor': Colors.blue[100]!,
          'textColor': Colors.blue,
          'statusText': 'Đã yêu cầu',
        };
      case 'accepted':
        return {
          'backgroundColor': Colors.orange[100]!,
          'textColor': Colors.orange,
          'statusText': 'Đã chấp nhận',
        };
      case 'completed':
        return {
          'backgroundColor': Colors.green[100]!,
          'textColor': Colors.green,
          'statusText': 'Hoàn thành',
        };
      case 'cancelled':
        return {
          'backgroundColor': Colors.red[100]!,
          'textColor': Colors.red,
          'statusText': 'Đã hủy',
        };
      default:
        return {
          'backgroundColor': Colors.grey[100]!,
          'textColor': Colors.grey,
          'statusText': 'Không xác định',
        };
    }
  }


}
