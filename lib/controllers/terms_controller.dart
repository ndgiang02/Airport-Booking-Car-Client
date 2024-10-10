import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../constant/show_dialog.dart';
import '../service/api.dart';

class TermsOfServiceController extends GetxController {

  var termsContent = ''.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    getTermsOfService();
    super.onInit();
  }

  Future<void> getTermsOfService() async {
    try {
      ShowDialog.showLoader('please_wait'.tr);
      final response = await http.get(
        Uri.parse(API.terms),
        headers: API.header,
      );
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (responseBody['status'] == true) {
        termsContent.value = responseBody['data']['terms'];
        ShowDialog.closeLoader();
        update();
      } else {
        ShowDialog.closeLoader();
        ShowDialog.showToast('Failed to load terms of service'.tr);
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

