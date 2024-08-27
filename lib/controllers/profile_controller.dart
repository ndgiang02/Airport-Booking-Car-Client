import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../constant/constant.dart';
import '../constant/show_dialog.dart';
import '../models/user_model.dart';
import '../service/api.dart';

class MyProfileController extends GetxController {
  RxString name = "".obs;
  RxString email = "".obs;
  RxString phoneNo = "".obs;
  RxString userCat = "".obs;
  RxInt userId = 0.obs;

  @override
  void onInit() {
    getUsrData();
    super.onInit();
  }

  getUsrData() async {
    UserModel userModel = Constant.getUserData();
    name.value = userModel.data!.name!;
    email.value = userModel.data!.email!;
    phoneNo.value = userModel.data!.phone!;

    userCat.value = userModel.data!.userCat!;
    userId.value = userModel.data!.id!;
  }


  // Future<dynamic> updateEmail(Map<String, String> bodyParams) async {
  //   try {
  //     ShowDialog.showLoader("Please wait");
  //     final response = await http.post(Uri.parse(API.updateUserEmail), headers: API.header, body: jsonEncode(bodyParams));
  //     Map<String, dynamic> responseBody = json.decode(response.body);
  //
  //
  //     if (response.statusCode == 200) {
  //       ShowDialog.closeLoader();
  //       return responseBody;
  //     } else {
  //       ShowDialog.closeLoader();
  //       ShowDialog.showToast('Something want wrong. Please try again later');
  //       throw Exception('Failed to load album');
  //     }
  //   } on TimeoutException catch (e) {
  //     ShowDialog.closeLoader();
  //     ShowDialog.showToast(e.message.toString());
  //   } on SocketException catch (e) {
  //     ShowDialog.closeLoader();
  //     ShowDialog.showToast(e.message.toString());
  //   } on Error catch (e) {
  //     ShowDialog.closeLoader();
  //     ShowDialog.showToast(e.toString());
  //   } catch (e) {
  //     ShowDialog.closeLoader();
  //     ShowDialog.showToast(e.toString());
  //   }
  //   return null;
  // }

  Future<dynamic> updateName(Map<String, String> bodyParams) async {
    try {
      ShowDialog.showLoader("Please wait");
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
      ShowDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.changePassword),
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

  Future<dynamic> deleteAccount(String userId) async {
    try {
      ShowDialog.showLoader("Please wait");
      final response = await http.get(
        Uri.parse('${API.deleteUser}$userId&user_cat=customer'),
        headers: API.header,
      );
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
}
