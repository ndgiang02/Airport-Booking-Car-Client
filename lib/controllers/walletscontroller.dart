import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constant/show_dialog.dart';
import '../models/transaction_model.dart';
import '../service/api.dart';

class WalletController extends GetxController {
  var balance = 0.0.obs;
  var transactions = <Transaction>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWalletData();
  }

  Future<void> fetchWalletData() async {
    try {
      ShowDialog.showLoader('please_wait'.tr);
      final response = await http.get(
        Uri.parse(API.wallet),
        headers: API.header,
      );
      Map<String, dynamic> responseBody = json.decode(response.body);

      log('$responseBody');

      if (responseBody['status'] == true) {
        ShowDialog.closeLoader();
        var balanceValue = responseBody['balance'];
        if (balanceValue is String) {
          balance.value =
              double.tryParse(balanceValue.replaceAll(',', '')) ?? 0.0;
        } else if (balanceValue is num) {
          balance.value = balanceValue.toDouble();
        } else {
          balance.value = 0.0;
        }

        transactions.value = (responseBody['transactions'] as List)
            .map((json) => Transaction.fromJson(json))
            .toList();
      } else {
        ShowDialog.closeLoader();
        ShowDialog.showToast('Failed to load wallet data'.tr);
      }
    } on TimeoutException catch (e, stackTrace) {
      ShowDialog.closeLoader();
      ShowDialog.showToast('Timeout error: ${e.message}');
    } on SocketException catch (e, stackTrace) {
      ShowDialog.closeLoader();
      ShowDialog.showToast('Network error: ${e.message}');
    } on FormatException catch (e, stackTrace) {
      ShowDialog.closeLoader();
      ShowDialog.showToast('Format error: ${e.message}');
    } catch (e) {
      ShowDialog.closeLoader();
      ShowDialog.showToast('Error: $e');
    }
  }
}
