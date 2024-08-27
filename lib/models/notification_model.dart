import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Notification {
  final String title;
  final String message;
  final DateTime date;

  Notification({
    required this.title,
    required this.message,
    required this.date,
     });

  String get formattedDate {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
