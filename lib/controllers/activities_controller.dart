import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import '../../../models/trip_model.dart';
import 'package:http/http.dart' as http;

import '../service/api.dart';
import '../utils/preferences/preferences.dart';

class ActivitiesController extends GetxController {

  var upcomingTrips = <Trip>[].obs;
  var historyTrips = <Trip>[].obs;
  int? customerId = Preferences.getInt(Preferences.userId);

  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTripsData();
  }

  Future<void> fetchTripsData() async {
    try {
      isLoading(true);
      await fetchTrips('upcoming');
      await fetchTrips('history');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchTrips(String status) async {

    final response = await http.get(
      Uri.parse('${API.fetchTrips}?customer_id=$customerId&status=$status'),
      headers: API.header,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      log("Response body: ${response.body}");

      if (data['data'] != null && data['data'] is Map && data['data']['data'] is List) {
        var tripList = (data['data']['data'] as List)
            .map((trip) => Trip.fromJson(trip as Map<String, dynamic>))
            .toList();
        if (status == 'upcoming') {
          upcomingTrips.assignAll(tripList);
        } else {
          historyTrips.assignAll(tripList);
        }
      }
    } else {
      log('Failed to fetch trips');
    }
  }

  void updateIndex(int index) {
  }


}
