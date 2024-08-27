import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/notification_controller.dart';
import '../../utils/themes/reponsive.dart';

class NotificationScreen extends StatelessWidget {
  final NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông báo'),
        elevation: 5,
      ),
      body: Obx(() {
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: controller.notifications.length,
                itemBuilder: (context, index) {
                  final notification = controller.notifications[index];
                  return ListTile(
                    leading: Icon(Icons.notifications, size: 20),
                    title: Text(notification.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(notification.message),
                        SizedBox(height: 5),
                        Align(
                          alignment: Alignment.bottomRight,
                            child: Text('${notification.formattedDate}',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        ),
                      ],
                    ),
                  );
                }, separatorBuilder: (context, index) => Divider(
                color: Colors.grey[400],
                indent: Responsive.width(100, context) * 0.08,
                endIndent: Responsive.width(100, context) * 0.08 ,
              ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
