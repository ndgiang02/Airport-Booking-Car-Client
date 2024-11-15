import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class FlightController extends GetxController {
  var currentPage = 0.obs;

  //069eea3cc6mshabcab91fdad07e6p119fddjsn0c5af24ae279
  final String apiKey = 'd58f111472mshf372019e10de5bdp1d57b5jsna5ef421bf3e1';
  final String host = 'flightera-flight-data.p.rapidapi.com';

  var date = DateTime.now().obs;
  var flightInfo = <String, dynamic>{}.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var flightCode = ''.obs;


  void updateFlightCode(String newCode) {
    flightCode.value = newCode;
  }

  void changePage(int page) {
    currentPage.value = page;
  }

  final String baseUrl =
      'https://flightera-flight-data.p.rapidapi.com/flight/info';
  final String apiHost = 'flightera-flight-data.p.rapidapi.com';

  void fetchFlight(String flightNumber, String date) async {
    var result = await getFlightInfo(flightNumber, date);
    if (result != null) {
      flightInfo.value = result;
    }
  }

  Future getFlightInfo(String flightNumber, String date) async {
    final uri = Uri.https(
      host,
      '/flight/info',
      {
        'flnr': flightNumber,
        'date': date,
      },
    );

    try {
      // Make the HTTP GET request
      final response = await http.get(
        uri,
        headers: {
          'X-RapidAPI-Key': apiKey,
          'X-RapidAPI-Host': host,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List) {
          if (data.isNotEmpty) {
            log('Flight info: ${data[0]}');
            return data[0];
          } else {
            // No flight data found
            throw Exception('No flight data available');
          }
        } else if (data is Map) {
          // If the data is a single Map
          log('Flight info: $data');
          return data; // Return the data (Map) directly
        } else {
          // Unexpected response format
          throw Exception('Unexpected response format: $data');
        }
      } else {
        // If the request was not successful
        throw Exception('Failed to load flight data: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Catch and throw any errors that occurred during the request
      throw Exception('Error making API request: $e');
    }
  }

  String convertTo12HourFormat(String timeStr) {
    try {
      DateTime dateTime = DateTime.parse(timeStr);

      DateTime localTime = dateTime.toLocal();

      return DateFormat('HH:mm').format(localTime);
    } catch (e) {
      return 'Unknown'.tr;
    }
  }

  String formatDate(DateTime timeStr) {
    try {
      DateTime localTime = timeStr;
      String formattedDate = DateFormat('yyyy-MM-dd').format(localTime);
      return formattedDate;
    } catch (e) {
      return 'Unknown'.tr;
    }
  }

  String calculateDelay(String scheduledTimeStr, String actualTimeStr) {
    try {
      DateTime scheduledTime = DateTime.parse(scheduledTimeStr);
      DateTime actualTime = DateTime.parse(actualTimeStr);
      Duration delay = actualTime.difference(scheduledTime);
      if (delay.isNegative) {
        return 'onTime'.tr;
      } else {
        int hours = delay.inHours;
        int minutes = delay.inMinutes % 60;
        if (hours == 0) {
          return '${'DELAY'.tr}: $minutes ${'minute'.tr}';
        } else {
          return '${'DELAY'.tr}: $hours ${'hour'.tr} $minutes ${'minute'.tr}';
        }
      }
    } catch (e) {
      return 'Unknown'.tr;
    }
  }
}
