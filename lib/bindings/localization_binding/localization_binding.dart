import 'package:customerapp/controllers/localization_controller.dart';
import 'package:get/get.dart';

class LocalizationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LocalizationController());
  }
}