import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  var currentPage = 0.obs;

  final String apiKey = '069eea3cc6mshabcab91fdad07e6p119fddjsn0c5af24ae279';
  final String host = 'flightera-flight-data.p.rapidapi.com';

  var date = DateTime.now().obs;
  var flightInfo = <String, dynamic>{}.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var flightCode = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

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
            return data[0];
          } else {
            throw Exception('No flight data available');
          }
        } else if (data is Map) {
          return data;
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load flight data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error making API request: $e');
    }
  }

  String convertTo12HourFormat(String timeStr) {
    try {
      DateTime dateTime = DateTime.parse(timeStr);
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      return 'Unknown';
    }
  }

  String formatDate(DateTime timeStr) {
    try {
      DateTime utcTime = timeStr.toUtc();
      String formattedDate = DateFormat('yyyy-MM-dd').format(utcTime);
      return formattedDate;
    } catch (e) {
      return 'Unknown';
    }
  }
}
