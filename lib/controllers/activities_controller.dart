import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import '../../../models/trip_model.dart';
import 'package:http/http.dart' as http;

import '../constant/show_dialog.dart';
import '../service/api.dart';
import '../utils/preferences/preferences.dart';

class ActivitiesController extends GetxController {

  var upcomingTrips = <Trip>[].obs;
  var historyTrips = <Trip>[].obs;
  int? userId = Preferences.getInt(Preferences.userId);

  var isLoading = true.obs;
  var shouldRefresh = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTripsData();
  }

  Future<void> refreshData() async {
    await fetchTripsData();
  }

  Future<void> fetchTripsData() async {
    try {
      isLoading(true);
      await fetchTrips('upcoming');
      await fetchTrips('history');
    } finally {
      isLoading(false);
      shouldRefresh(false);
    }
  }

  Future<void> fetchTrips(String status) async {
    final response = await http.get(
      Uri.parse('${API.fetchTrips}?user_id=$userId&status=$status'),
      headers: API.header,
    );

    Map<String, dynamic> responseBody = json.decode(response.body);

    if (response.statusCode == 200) {
      if (responseBody['data'] != null && responseBody['data'] is List) {
        var tripList = (responseBody['data'] as List)
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

  Future<dynamic> canceledTrip(Map<String, dynamic> bodyParams) async {
    try {
      ShowDialog.showLoader('please wait'.tr);
      final response = await http.post(Uri.parse(API.cancelTrip),
          headers: API.header, body: jsonEncode(bodyParams));

      Map<String, dynamic> responseBody = json.decode(response.body);
      log('activities: $responseBody');
      if (response.statusCode == 200 && responseBody['status'] == true) {
        ShowDialog.closeLoader();
        return responseBody;
      } else {
        ShowDialog.closeLoader();
        ShowDialog.showToast('Something want wrong. Please try again later'.tr);
        throw Exception('Failed to load album'.tr);
      }
    } on TimeoutException catch (e) {
      ShowDialog.closeLoader();
      ShowDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowDialog.closeLoader();
      ShowDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowDialog.closeLoader();
      ShowDialog.showToast(e.toString());
    }
    ShowDialog.closeLoader();
    return null;
  }

  void updateIndex(int index) {
  }


}
