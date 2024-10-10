import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../constant/show_dialog.dart';
import '../service/api.dart';

class ManageController extends GetxController {

  Future<dynamic> logOut() async {
    try {
      ShowDialog.showLoader('please_wait'.tr);
      final response = await http.post(
        Uri.parse(API.logOut),
        headers: API.header,
      );
      Map<String, dynamic> responseBody = json.decode(response.body);
      log('logout $responseBody');
      if (response.statusCode == 200) {
        if (responseBody['status'] == true) {
          ShowDialog.closeLoader();
          return responseBody;
        } else {
          String errorMessage =
              responseBody['message'] ?? 'Logout failed. Please try again.'.tr;
          ShowDialog.showToast(errorMessage);
        }
      } else {
        ShowDialog.showToast(
            '${response.statusCode}. Please try again later.'.tr);
      }
    } on TimeoutException {
      ShowDialog.closeLoader();
      ShowDialog.showToast('Request timed out. Please try again.'.tr);
    } on SocketException {
      ShowDialog.closeLoader();
      ShowDialog.showToast(
          'No internet connection. Please check your network.'.tr);
    } catch (e) {
      ShowDialog.closeLoader();
      ShowDialog.showToast('An unexpected error occurred: $e');
    }
    return null;
  }
}
