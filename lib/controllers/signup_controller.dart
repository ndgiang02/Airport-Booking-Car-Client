import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../constant/show_dialog.dart';
import '../models/user_model.dart';
import '../service/api.dart';
import '../utils/preferences/preferences.dart';

class SignUpController extends GetxController {

  var isObscure = true.obs;

  Future<UserModel?> signUp(Map<String, String> bodyParams) async {
    try {
      ShowDialog.showLoader("Please wait");
      final response = await http.post(
        Uri.parse(API.userSignUP),
        headers: API.authheader,
        body: jsonEncode(bodyParams),
      );

      Map<String, dynamic> responseBody = json.decode(response.body);

      log("Response body: ${response.body}");

      if (response.statusCode == 201) {
        if (responseBody['status'] == true) {
          ShowDialog.closeLoader();
          Map<String, dynamic> responseBody = json.decode(response.body);

          log("Response body2: ${response.body}");

          if (responseBody.containsKey('data') &&
              responseBody['data'].containsKey('token')) {
            Preferences.setString(
                Preferences.token, responseBody['data']['token'].toString());
            API.header['token'] = Preferences.getString(Preferences.token);
          }
          return UserModel.fromJson(responseBody);
        } else {
          String errorMessage =
              responseBody['message'] ?? 'Register failed. Please try again.';
          ShowDialog.showToast(errorMessage);
        }
      } else {
        ShowDialog.closeLoader();
        ShowDialog.showToast('Invalid response format from server.');
      }
    } on TimeoutException catch (e) {
      ShowDialog.closeLoader();
      ShowDialog.showToast('Request timed out. Please try again.');
    } on SocketException catch (e) {
      ShowDialog.closeLoader();
      ShowDialog.showToast(
          'No internet connection. Please check your network.');
    } on FormatException catch (e) {
      ShowDialog.closeLoader();
      ShowDialog.showToast('Invalid response format: ${e.message}');
    } catch (e) {
      ShowDialog.closeLoader();
      ShowDialog.showToast('An unexpected error occurred: $e');
    }
    return null;
  }
}
