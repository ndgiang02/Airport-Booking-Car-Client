import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notification_controller.dart';
import '../models/trip_model.dart';
import '../views/activities_screen/drivermap_screen.dart';

class FirebaseService {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final NotificationController notificationController = Get.put(NotificationController());

  void initialize() {
    _firebaseMessaging.getToken().then((token) {
      log("FCM Token: $token");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Received FCM data: ${message.data}');
      if (message.data['type'] == 'welcome') {
        notificationController.showNotification(message);
      }
      if (message.data['type'] == 'accepted') {
        log('${message.data['trip']}');
        String title = message.notification?.title ??
            'Chuyến đi đã được xác nhận!';
        String body = message.notification?.body ?? 'Tài xế sẽ sớm có mặt';

        Get.snackbar(
          title,
          body,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.white.withOpacity(0.8),
          colorText: Colors.black,
          duration: const Duration(seconds: 10),
          margin: const EdgeInsets.all(10),
          borderRadius: 10,
        );

        final tripDataString = message.data['trip'];

        if (tripDataString != null) {
          try {
            final tripData = json.decode(tripDataString) as Map<String, dynamic>;
            final trip = Trip.fromJson(tripData);
            log('On Message Open App: $trip');
            Get.to(() => DriverMapScreen(), arguments: trip);
          } catch (e) {
            log('Error decoding trip data: $e');
          }
        } else {
          log("Trip data is null or invalid.");
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("Notification opened from background: ${message.notification?.title}");
      if (message.data['type'] == 'accepted') {

        String title = message.notification?.title ??
            'Chuyến đi đã được xác nhận!';
        String body = message.notification?.body ?? 'Tài xế sẽ sớm có mặt';

        Get.snackbar(
          title,
          body,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.white.withOpacity(0.8),
          colorText: Colors.black,
          duration: const Duration(seconds: 5),
          margin: const EdgeInsets.all(10),
          borderRadius: 10,
        );

        log('${message.data['trip']}');

        final tripDataString = message.data['trip'];

        if (tripDataString != null) {
          try {
            final tripData = json.decode(tripDataString) as Map<String, dynamic>;
            final trip = Trip.fromJson(tripData);

            log('On Message Open App: $trip');

            Get.to(() => DriverMapScreen(), arguments: trip);
          } catch (e) {
            log('Error decoding trip data: $e');
          }
        } else {
          log("Trip data is null or invalid.");
        }
      }
    });
  }


}