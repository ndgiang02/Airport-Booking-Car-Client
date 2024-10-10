import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import '../controllers/notification_controller.dart';

class FirebaseService {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final NotificationController notificationController = Get.put(NotificationController());

  void initialize() {
    _firebaseMessaging.getToken().then((token) {
      log("FCM Token: $token");
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleIncomingNotification(message);
    });
  }

  void _handleIncomingNotification(RemoteMessage message) {
    log('Received FCM data: ${message.data}');
    if (message.data['type'] == 'welcome') {
        notificationController.showNotification(message);

    }
  }
}