import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constant/constant.dart';
import '../../controllers/terms_controller.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../utils/themes/text_style.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TermsOfServiceController>(
        init: TermsOfServiceController(),
        builder: (controller) {
          print(controller.data);
          return Scaffold(
            appBar: AppBar(
              title: Text('Hello'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: controller.data != null
                  ? SingleChildScrollView(
                      child: Html(
                        data: controller.data,
                      ),
                    )
                  : Center(child: CircularProgressIndicator()),
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
