import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/notification_model.dart';
import '../service/notification.dart';
import '../utils/preferences/preferences.dart';

class NotificationController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  var notifications = <NotificationModel>[].obs;

  Future<void> saveNotifications(List<NotificationModel> notifications) async {
    List<String> jsonList = notifications.map((notification) => jsonEncode(notification.toJson())).toList();

    await Preferences.setStringList('notifications', jsonList);
  }

  Future<void> loadNotifications() async {
    List<String>? jsonList = await Preferences.getStringList('notifications');
    if (jsonList != null) {
      notifications.value = jsonList.map((json) => NotificationModel.fromJson(jsonDecode(json))).toList();
    }
  }

  Future<void> showNotification(RemoteMessage message) async {
    String title = message.notification?.title ?? 'Thông báo khuyến mãi';
    String body = message.notification?.body ?? 'Bạn có một khuyến mãi mới!';

    NotificationService().showNotification(
      message.hashCode,
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
    );

    notifications.add(
      NotificationModel(
        title: message.notification!.title ?? 'Thông báo',
        message: message.notification!.body ?? '',
        date: DateTime.now(),
      ),
    );
    saveNotifications(notifications);

    Get.snackbar(
      title,
      body,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.theme.snackBarTheme.backgroundColor ?? Colors.white70,
      colorText: Get.theme.snackBarTheme.actionTextColor ?? Colors.white,
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
    );
  }

}
