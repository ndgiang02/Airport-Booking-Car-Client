import 'package:customerapp/controllers/localization_controller.dart';
import 'package:customerapp/utils/themes/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../constant/show_dialog.dart';

class LocalizationScreen extends StatelessWidget {
  const LocalizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<LocalizationController>(
        init: LocalizationController(),
        builder: (controller) {
          return Scaffold(
              appBar: AppBar(
                title: Text('select_language'.tr,
                    style:CustomTextStyles.header),
                elevation: 4,
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  runSpacing: 12,
                  spacing: 12,
                  children:
                      List.generate(controller.languageList.length, (index) {
                    return Obx(() => InkWell(
                      onTap: () async {
                        controller.changeLanguage(
                          controller.languageList[index].languageCode!,
                        );
                        ShowDialog.showLoader('please_wait'.tr);
                        await Future.delayed(const Duration(seconds: 1));
                        EasyLoading.dismiss();
                        Get.back();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:  controller.languageList[index].languageCode ==
                              controller.selectedLanguage.value
                              ? Colors.orange
                              : Colors.grey.withOpacity(0.4),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        width: (MediaQuery.of(context).size.width - 44) / 2,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(8)), child: Image.asset(controller.languageList[index].flag!, width: 32, height: 32)),
                            const SizedBox(width: 12,),
                            Text(controller.languageList[index].language!, style: CustomTextStyles.body,)
                          ],
                        ),
                      ),
                    ));
                  }),
                ),
              ));
        });
  }
}
