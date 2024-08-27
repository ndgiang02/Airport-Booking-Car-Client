import 'package:customerapp/controllers/activities_controller.dart';
import 'package:get/get.dart';

class ActivitiesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ActivitiesController());
  }
}