import 'package:customerapp/utils/themes/reponsive.dart';
import 'package:flutter/material.dart';

class ButtonThem {
  static buildCustomButton({
    required String label,
    required VoidCallback onPressed,
    Color backgroundColor = Colors.cyan,
    double borderRadius = 8.0,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(vertical: 15),
    TextStyle textStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: textStyle,
      ),
    );
  }

  static buildButton(
    BuildContext context, {
    required String title,
    required Color btnColor,
    required Color txtColor,
    double btnHeight = 40,
    double txtSize = 14,
    double btnWidthRatio = 0.9,
    required Function() onPress,
    bool isVisible = true,
  }) {
    return Visibility(
      visible: isVisible,
      child: Center(
        child: SizedBox(
          width: Responsive.width(100, context) * btnWidthRatio,
          child: MaterialButton(
            onPressed: onPress,
            height: btnHeight,
            elevation: 0.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: btnColor,
            child: Text(
              title.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: txtColor,
                  fontSize: txtSize,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  static buildBorderButton(
    BuildContext context, {
    required String title,
    required Color btnColor,
    required Color btnBorderColor,
    required Color txtColor,
    double btnHeight = 50,
    double txtSize = 14,
    double btnWidthRatio = 1,
    required Function() onPress,
    bool isVisible = true,
    bool enabled = true,
    Color disabledBtnColor = Colors.grey,
    Color disabledTxtColor = Colors.black38,
    Color disabledBorderColor = Colors.grey,
  }) {
    return Visibility(
      visible: isVisible,
      child: Center(
        child: SizedBox(
          width: Responsive.width(100, context) * btnWidthRatio,
          height: btnHeight,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(
                enabled ? btnColor : disabledBtnColor,
              ),
              foregroundColor: WidgetStateProperty.all<Color>(
                enabled ? txtColor : disabledTxtColor,
              ),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(
                    color:  enabled ? btnBorderColor : disabledBorderColor,
                  ),
                ),
              ),
            ),
            onPressed: enabled ? onPress : null,
            child: Text(
              title.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: enabled ? txtColor : disabledTxtColor,
                  fontSize: txtSize,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  static buildIconButton(
    BuildContext context, {
    required String title,
    required Color btnColor,
    required Color txtColor,
    required Color iconColor,
    required IconData icon,
    double btnHeight = 50,
    double txtSize = 16,
    double btnWidthRatio = 0.9,
    iconSize = 18.0,
    required Function() onPress,
    bool isVisible = true,
  }) {
    return Visibility(
      visible: isVisible,
      child: SizedBox(
        width: Responsive.width(100, context) * btnWidthRatio,
        height: btnHeight,
        child: TextButton.icon(
          style: TextButton.styleFrom(
            backgroundColor: btnColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          onPressed: onPress,
          label: Text(
            title,
            style: TextStyle(color: txtColor, fontSize: txtSize),
          ),
          icon: Icon(
            icon,
            color: iconColor,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
