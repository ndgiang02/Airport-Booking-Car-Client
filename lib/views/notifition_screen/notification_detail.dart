import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/notification_model.dart';

class NotificationDetailScreen extends StatelessWidget {
  final NotificationModel notification ;

  const NotificationDetailScreen({Key? key, required this.notification}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final NotificationModel notification = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết thông báo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              notification.message,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                '${notification.formattedDate}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
