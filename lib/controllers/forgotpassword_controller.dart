import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';


import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../constant/show_dialog.dart';
import '../service/api.dart';

class ForgotPasswordController extends GetxController {
  Future<bool?> sendEmail(Map<String, String> bodyParams) async {
    try {
      ShowDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.sendResetPasswordOtp),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            ...API.authheader,
          },
          body: jsonEncode(bodyParams));

      Map<String, dynamic> responseBody = json.decode(response.body);

      log('Response body: ${response.body}');

      if (response.statusCode == 200 && responseBody['success'] == "Success") {
        ShowDialog.closeLoader();
        return true;
      } else if (response.statusCode == 200 && responseBody['success'] == "Failed") {
        ShowDialog.closeLoader();
        ShowDialog.showToast(responseBody['error']);
      } else {
        ShowDialog.closeLoader();
        ShowDialog.showToast('Something want wrong. Please try again later');
        throw Exception('Failed to load album');
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
    } catch (e) {
      ShowDialog.closeLoader();
      ShowDialog.showToast(e.toString());
    }
    return null;
  }

  Future<bool?> resetPassword(Map<String, String> bodyParams) async {
    try {
      ShowDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.resetPasswordOtp), headers: API.header, body: jsonEncode(bodyParams));

      Map<String, dynamic> responseBody = json.decode(response.body);

      log('Response body: ${response.body}');

      if (response.statusCode == 200 && responseBody['status'] == true) {
        ShowDialog.closeLoader();
        return true;
      } else if (response.statusCode == 400 && responseBody['status'] == false) {
        ShowDialog.closeLoader();
        ShowDialog.showToast(responseBody['error']);
      } else {
        ShowDialog.closeLoader();
        ShowDialog.showToast('Something want wrong. Please try again later');
        throw Exception('Failed to load album');
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
    } catch (e) {
      ShowDialog.closeLoader();
      ShowDialog.showToast(e.toString());
    }
    return null;
  }
}
