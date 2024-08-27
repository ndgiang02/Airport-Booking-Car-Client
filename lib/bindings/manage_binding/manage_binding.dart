import 'package:customerapp/controllers/manage_controller.dart';
import 'package:get/get.dart';

class ManageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ManageController());
  }
}