import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constant/show_dialog.dart';
import '../models/user_model.dart';
import '../service/api.dart';

class SignUpController extends GetxController {
  var isObscure = true.obs;

  RxString phoneNumber = "".obs;
  RxBool isPhoneValid = false.obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final conformPasswordController = TextEditingController();


  void clearData() {
    // Reset Rx variables
    phoneNumber.value = '';
    isPhoneValid.value = false;


    nameController.clear();
    emailController.clear();
    passwordController.clear();
    conformPasswordController.clear();
  }

  // Dọn dẹp khi controller bị hủy
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    conformPasswordController.dispose();
    super.onClose();
  }

  Future<UserModel?> signUp(Map<String, String> bodyParams) async {
    try {
      ShowDialog.showLoader('please_wait'.tr);
      final response = await http.post(
        Uri.parse(API.userSignUP),
        headers: API.authheader,
        body: jsonEncode(bodyParams),
      );
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 201) {
        ShowDialog.closeLoader();
        return UserModel.fromJson(responseBody);
      } else if(response.statusCode == 500){
        ShowDialog.closeLoader();
        ShowDialog.showToast('Email already exists'.tr);
      }
        else {
        ShowDialog.closeLoader();
        ShowDialog.showToast('Invalid response format from server.'.tr);
      }
    } on FormatException catch (e) {
      ShowDialog.closeLoader();
      ShowDialog.showToast('Invalid response format: ${e.message}');
    } catch (e) {
      ShowDialog.closeLoader();
      ShowDialog.showToast('$e');
    }
    return null;
  }

}
