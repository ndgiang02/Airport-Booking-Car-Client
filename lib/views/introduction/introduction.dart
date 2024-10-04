import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constant/constant.dart';
import '../../controllers/intro_controller.dart';

import '../../utils/themes/text_style.dart';

class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IntroController>(
        init: IntroController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: Text('intro'.tr),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
            body: Obx(() {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Text(
                    controller.introContent.value,
                    style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
                ),
              );
            }),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'version'.tr + ': ${Constant.appVersion}',
                textAlign: TextAlign.center,
                style: CustomTextStyles.body,
              ),
            ),
          );
        });
  }
}
