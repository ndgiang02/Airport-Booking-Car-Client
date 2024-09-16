import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../models/notification_model.dart';
import '../views/notifition_screen/notification_detail.dart';

class NotificationController extends GetxController {
  var notifications = <NotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initMessaging();
    _initFirebaseMessaging();
    _handleInitialMessage();
  }

  void _initFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        notifications.add(
          NotificationModel(
            title: message.notification!.title ?? 'Thông báo',
            message: message.notification!.body ?? '',
            date: DateTime.now(),
          ),
        );
      }
    });
  }

  void _initMessaging() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        notifications.add(
          NotificationModel(
            title: message.notification!.title ?? 'Thông báo',
            message: message.notification!.body ?? '',
            date: DateTime.now(),
          ),
        );
      }
    });
  }

  Future<void> _handleInitialMessage() async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      final notification = NotificationModel(
        title: message.data['title'] ?? 'No Title',
        message: message.data['message'] ?? 'No Message',
        date: DateTime.now(),
      );
      Get.to(() => NotificationDetailScreen(notification: notification));
    }
  }
}
