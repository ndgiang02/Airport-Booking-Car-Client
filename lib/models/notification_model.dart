import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationModel {
  final String title;
  final String message;
  final DateTime date;

  NotificationModel({required this.title, required this.message, required this.date});

  String get formattedDate {
    return ' ${date.hour}:${date.minute}  ${date.day}/${date.month}/${date.year}';
  }
}