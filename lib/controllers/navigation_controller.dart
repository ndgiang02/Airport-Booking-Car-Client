import 'package:get/get.dart';

class NavigationController extends GetxController {
  var selectedIndex = 0.obs;

  @override
  void onInit() {
    if (Get.arguments != null) {
      changeIndex(Get.arguments);
    }
    super.onInit();
  }

  void changeIndex(int index){
    selectedIndex.value = index;
  }
}