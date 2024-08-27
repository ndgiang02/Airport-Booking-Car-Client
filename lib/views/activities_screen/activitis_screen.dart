import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/activities_controller.dart';


class ActivitiesScreen extends StatelessWidget {

  ActivitiesScreen({Key? key}) : super(key: key);

  final ActivitiesController controller = Get.put(ActivitiesController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Activities'),
          elevation: 5,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 50,
              child: TabBar(
                indicatorWeight: 1,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.schedule),
                        SizedBox(width: 5),
                        Text('Sắp tới'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history),
                        SizedBox(width: 5),
                        Text('Lịch sử'),
                      ],
                    ),
                  ),
                ],
                labelColor: Colors.orangeAccent,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.orangeAccent,
                labelPadding: EdgeInsets.symmetric(horizontal: 5.0),
                onTap: (index) {
                  controller.updateIndex(index);
                },
              ),
            ),
            Expanded(
              child: Obx(() {
                return TabBarView(
                  children: [
                    // Danh sách chuyến đi sắp tới
                    ListView.builder(
                      itemCount: controller.upcomingTrips.length,
                      itemBuilder: (context, index) {
                        final trip = controller.upcomingTrips[index];
                        return ListTile(
                          title: Text(trip.type),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.calendar_today, size: 16),
                                  SizedBox(width: 5),
                                  Text('Ngày giờ bắt đầu: ${trip.startDate}'),
                                ],
                              ),
                              if (trip.isCompleted)
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today, size: 16),
                                    SizedBox(width: 5),
                                    Text('Ngày giờ kết thúc: ${trip.endDate}'),
                                  ],
                                ),
                              Row(
                                children: [
                                  Icon(Icons.location_on, size: 16),
                                  SizedBox(width: 5),
                                  Text('Địa điểm đi: ${trip.departureLocation}'),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.location_on, size: 16),
                                  SizedBox(width: 5),
                                  Text('Địa điểm đến: ${trip.destinationLocation}'),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.directions, size: 16),
                                  SizedBox(width: 5),
                                  Text('Khoảng cách: ${trip.distance} km'),
                                ],
                              ),
                            ],
                          ),
                          trailing: trip.isCompleted
                              ? Icon(Icons.check, color: Colors.green)
                              : Icon(Icons.arrow_forward),
                          onTap: () {
                            // Xử lý khi bấm vào một chuyến đi
                          },
                        );
                      },
                    ),
                    // Danh sách chuyến đi đã hoàn thành
                    ListView.builder(
                      itemCount: controller.completedTrips.length,
                      itemBuilder: (context, index) {
                        final trip = controller.completedTrips[index];
                        return ListTile(
                          title: Text(trip.type),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.calendar_today, size: 16),
                                  SizedBox(width: 5),
                                  Text('Ngày giờ bắt đầu: ${trip.startDate}'),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.calendar_today, size: 16),
                                  SizedBox(width: 5),
                                  Text('Ngày giờ kết thúc: ${trip.endDate}'),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.location_on, size: 16),
                                  SizedBox(width: 5),
                                  Text('Địa điểm đi: ${trip.departureLocation}'),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.location_on, size: 16),
                                  SizedBox(width: 5),
                                  Text('Địa điểm đến: ${trip.destinationLocation}'),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.directions, size: 16),
                                  SizedBox(width: 5),
                                  Text('Khoảng cách: ${trip.distance} km'),
                                ],
                              ),
                            ],
                          ),
                          trailing: Icon(Icons.check, color: Colors.green),
                          onTap: () {
                            // Xử lý khi bấm vào một chuyến đi đã hoàn thành
                          },
                        );
                      },
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
