import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constant/constant.dart';
import '../../controllers/splash_controller.dart';
import '../../utils/extensions/load.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(ic_logo_white, fit: BoxFit.contain, height: 150, width: 150, color: Colors.orangeAccent
                  ,),
                SizedBox(height: 30),
                Text('app_name'.tr),
                Loading(),
              ],
            ),
          ),
        );
      },
    );
  }
}


