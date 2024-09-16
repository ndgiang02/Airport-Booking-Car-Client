import 'package:customerapp/utils/themes/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAlert {
  static showCustomDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String callButtonText,
    required VoidCallback onCallPressed,
    String cancelButtonText = 'Hủy',
    Color callButtonColor = Colors.cyan,
    Color cancelButtonColor = Colors.red,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            title,
            style: CustomTextStyles.header,
          ),
          content: Text(
            content,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.start,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: onCallPressed,
                  child: Row(
                    children: [
                      Text(
                        callButtonText,
                        style: TextStyle(
                          color: callButtonColor, // Màu cho button "Call"
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  child: Text(
                    cancelButtonText,
                    style: TextStyle(
                      color: cancelButtonColor, // Màu cho button "Cancel"
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
