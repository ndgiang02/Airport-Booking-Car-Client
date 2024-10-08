import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomeController extends GetxController {

  var currentPage = 0.obs;

  final String apiKey = '46f110f0e3msh0377381c278bffep11c5c9jsn20829ea2b0e4';
  final String host = 'flightera-flight-data.p.rapidapi.com';


  var date = DateTime.now().obs;
  var flightInfo = <String, dynamic>{}.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var flightCode = ''.obs;

  @override
  void onInit() {
    super.onInit();
    ever(date, (DateTime newDate) {
      fetchFlightInfo(flightCode.value, formatDate(newDate));
    });
  }


  void updateFlightCode(String newCode) {
    flightCode.value = newCode;
    fetchFlightInfo(newCode, formatDate(date.value));
  }

  void updateDate(DateTime value) {
    date.value = value;
  }

  void changePage(int page) {
    currentPage.value = page;
  }

  Future<void> fetchFlightInfo(String flightNumber, String date) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final info = await getFlightInfo(flightNumber, date);
      flightInfo.value = info;
    } catch (e) {
      errorMessage.value = 'Error fetching flight info: $e';
    } finally {
      isLoading.value = false;
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
      DateTime localDateTime = dateTime.toLocal();
      return DateFormat('hh:mm a').format(localDateTime);
    } catch (e) {
      return 'Unknown';
    }
  }

  String formatDate(DateTime timeStr) {
    try {
      String formattedDate = DateFormat('yyyy-MM-dd').format(timeStr);
      return formattedDate;
    } catch (e) {
      return 'Unknown';
    }
  }

}
