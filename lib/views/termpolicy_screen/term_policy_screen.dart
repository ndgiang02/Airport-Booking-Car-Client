import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constant/constant.dart';
import '../../controllers/terms_controller.dart';

import '../../utils/themes/text_style.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TermsOfServiceController>(
        init: TermsOfServiceController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: Text('intro'.tr),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
            body:Obx(() {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Text(
                    controller.termsContent.value,
                    style: const TextStyle(fontSize: 16, height: 2, color: Colors.black),
                    textAlign: TextAlign.left,
                    textDirection: TextDirection.ltr,
                  ),
                ),
              );
            }),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                '${'version'.tr}: ${Constant.appVersion}',
                textAlign: TextAlign.center,
                style: CustomTextStyles.body,
              ),
            ),
          );
        });
  }
}
