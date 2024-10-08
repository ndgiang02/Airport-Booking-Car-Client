import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../constant/show_dialog.dart';
import '../models/user_model.dart';
import '../service/api.dart';
import '../utils/preferences/preferences.dart';
import '../views/auth_screens/otp_screen.dart';

class PhoneNumberController extends GetxController {
  RxString phoneNumber = "".obs;
  RxBool isPhoneValid = false.obs;

  sendCode(String phoneNumber) async {
    await FirebaseAuth.instance
        .verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          ShowDialog.showToast("The provided phone number is not valid.");
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        ShowDialog.closeLoader();
        Get.to(OtpScreen(
          phoneNumber: phoneNumber,
          verificationId: verificationId,
        ));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    )
        .catchError((error) {
      ShowDialog.closeLoader();
      ShowDialog.showToast(
          "You have try many time please send otp after some time");
    });
  }

  Future<bool?> checkUser(Map<String, String> bodyParams) async {
    try {
      ShowDialog.showLoader('please_wait'.tr);
      final response = await http.post(Uri.parse(API.checkUser),
          headers: API.authheader, body: jsonEncode(bodyParams));

      log("---->");
      log(bodyParams.toString());
      log(response.body);
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        ShowDialog.closeLoader();
        if (responseBody['status'] == true) {
          return true;
        } else {
          return false;
        }
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

  Future<UserModel?> loginByPhone(Map<String, String> bodyParams) async {
    try {
      ShowDialog.showLoader('please wait'.tr);
      final response = await http.post(Uri.parse(API.getUserByPhone),
          headers: API.authheader, body: jsonEncode(bodyParams));
      Map<String, dynamic> responseBody = json.decode(response.body);
      log('$responseBody');
      if (response.statusCode == 200) {
        ShowDialog.closeLoader();
        String accessToken = responseBody['data']['token'].toString();
        Preferences.setString(Preferences.token, accessToken);
        API.header['Authorization'] = 'Bearer $accessToken';
        ShowDialog.showToast('login successful'.tr);
        return UserModel.fromJson(responseBody);
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
