import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;

import '../../constant/show_dialog.dart';
import '../../service/api.dart';
import '../service/fakeapi.dart';



/*
class TermsOfServiceController extends GetxController {
  @override
  void onInit() {
    getTermsOfService();
    super.onInit();
  }

  dynamic data;

  Future<dynamic> getTermsOfService() async {
    try {
      ShowDialog.showLoader("Please wait");
      final response = await http.get(
        Uri.parse(API.termsOfCondition),
        headers: API.header,
      );
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        data = responseBody['data']['terms'];
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
    update();
    return null;
  }
}

 */

class TermsOfServiceController extends GetxController {
  @override
  void onInit() {
    getTermsOfService();
    super.onInit();
  }

  dynamic data;

  Future<void> getTermsOfService() async {
    try {
      ShowDialog.showLoader("Please wait");

      // Sử dụng FakeAPI để lấy dữ liệu
      final responseBody = await FakeAPI.getTermsOfService();

      if (responseBody['status'] == 'success') {
        data = responseBody['data']['terms'];
        print("Data loaded: $data");  // In dữ liệu để kiểm tra
        ShowDialog.closeLoader();
        update();
      } else {
        ShowDialog.closeLoader();
        ShowDialog.showToast('Failed to load terms of service');
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
  }
}
