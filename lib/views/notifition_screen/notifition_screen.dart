import 'package:customerapp/utils/themes/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/notification_controller.dart';
import '../../routes/app_routes.dart';
import '../../utils/themes/reponsive.dart';

class NotificationScreen extends StatelessWidget {

  final NotificationController controller = Get.put(NotificationController());

  NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title:Text(
        'notification'.tr,
        style: CustomTextStyles.app,
      ),
      centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Obx(() {
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: controller.notifications.length,
                itemBuilder: (context, index) {
                  final notification = controller.notifications.reversed.toList()[index];
                  return Material(
                      elevation: 1, // Shadow effect
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Get.toNamed(AppRoutes.notificationDetail, arguments: notification);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.notifications,
                                  size: 30,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        notification.title,
                                        style: CustomTextStyles.normal
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        notification.message.length > 100
                                            ? '${notification.message.substring(0, 100)}...'
                                            : notification.message,
                                        style: CustomTextStyles.body,
                                      ),
                                      const SizedBox(height: 8),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          notification.formattedDate,
                                          style: CustomTextStyles.small
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  );
                },
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey[300],
                  indent: Responsive.width(100, context) * 0.08,
                  endIndent: Responsive.width(100, context) * 0.08,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
