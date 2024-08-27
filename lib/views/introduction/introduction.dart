import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constant/constant.dart';
import '../../controllers/intro_controller.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../utils/themes/text_style.dart';

class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IntroController>(
        init: IntroController(),
        builder: (controller) {
          print(controller.data);
          return Scaffold(
            appBar: AppBar(
              title: Text('Intro'),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(1.0),
              child: controller.data != null
                  ? Html(
                data: controller.data,

              )
                  : const Offstage(),
            ),
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
