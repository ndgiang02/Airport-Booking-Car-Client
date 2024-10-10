import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../constant/constant.dart';
import '../constant/show_dialog.dart';
import '../models/user_model.dart';
import '../service/api.dart';
import '../utils/preferences/preferences.dart';

class MyProfileController extends GetxController {
  RxString name = "".obs;
  RxString email = "".obs;
  RxString mobile = "".obs;
  RxString userType = "".obs;
  RxInt userId = 0.obs;

  @override
  void onInit() {
    getUsrData();
    super.onInit();
  }

  getUsrData() async {
    UserModel userModel = Constant.getUserData();
    name.value = userModel.data!.user!.name!;
    email.value = userModel.data!.user!.email!;
    mobile.value = userModel.data!.user!.mobile!;
    userType.value =userModel.data!.user!.userType!;
    userId.value = userModel.data!.user!.id!;
  }

  Future<dynamic> updateName(Map<String, String> bodyParams) async {
    try {
      ShowDialog.showLoader('please_wait'.tr);
      final response = await http.post(Uri.parse(API.updateName),
          headers: API.header, body: jsonEncode(bodyParams));
      Map<String, dynamic> responseBody = json.decode(response.body);


      if (response.statusCode == 200) {
        ShowDialog.closeLoader();
        return responseBody;
      } else {
        ShowDialog.closeLoader();
        ShowDialog.showToast(
            'Something want wrong. Please try again later');
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

  Future<dynamic> updatePassword(Map<String, String> bodyParams) async {
    try {
      ShowDialog.showLoader('please_wait'.tr);
      bodyParams['new_password_confirmation'] = bodyParams['new_password']!;

      final response = await http.post(
        Uri.parse(API.changePassword),
        headers: API.header,
        body: jsonEncode(bodyParams),
      );

      log('Response body: ${response.body}');

      Map<String, dynamic> responseBody = json.decode(response.body);

      ShowDialog.closeLoader();

      if (response.statusCode == 200) {
        if (responseBody['status'] == true) {
          return responseBody;
        } else {
          String errorMessage = responseBody['message'] ?? 'Password update failed.';
          ShowDialog.showToast(errorMessage);
          return null;
        }
      } else {
        String errorMessage = responseBody['message'] ?? 'Something went wrong. Please try again later.';
        ShowDialog.showToast(errorMessage);
        throw Exception('Failed to update password: $errorMessage');
      }
    }  catch (e) {
      ShowDialog.closeLoader();
      ShowDialog.showToast('An unexpected error occurred: $e');
    }
    return null;
  }


  Future<dynamic> deleteAccount() async {
    try {
      ShowDialog.showLoader('please_wait'.tr);
      final response = await http.delete(
        Uri.parse(API.deleteUser),
        headers: API.header,
      );
      Map<String, dynamic> responseBody = json.decode(response.body);

      log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        ShowDialog.closeLoader();
        return responseBody;
      } else {
        ShowDialog.closeLoader();
        ShowDialog.showToast(
            'Something want wrong. Please try again later');
        throw Exception('Failed to load data');
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
