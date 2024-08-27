import 'package:customerapp/views/navigation_screen/navigation_bar.dart';
import 'package:get/get.dart';
import '../utils/preferences/preferences.dart';
import '../views/auth_screens/login_screen.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 2));

   bool isLoggedIn = Preferences.getBoolean(Preferences.isLogin);
    if (isLoggedIn) {
      Get.off(() => NavigationPage()) ;
    } else {
      Get.off(() => LoginScreen());
    }
  }
}
