import 'package:flutter/material.dart';
import 'contant_colors.dart';

class TextFieldTheme {

  static boxBuildTextField({
    required String hintText,
    required TextEditingController controller,
    String? Function(String?)? validators,
    TextInputType textInputType = TextInputType.text,
    bool obscureText = true,
    EdgeInsets contentPadding = EdgeInsets.zero,
    maxLine = 1,
    bool enabled = true,
    maxLength = 300,
    Widget? prefixIcon,  void Function(String)? onChanged,
  }) {
    return TextFormField(
        obscureText: !obscureText,
        validator: validators,
        keyboardType: textInputType,
        textCapitalization: TextCapitalization.sentences,
        controller: controller,
        maxLines: maxLine,
        maxLength: maxLength,
        enabled: enabled,
        decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.all(10),
            fillColor: Colors.white,
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: ConstantColors.textFieldFocusColor, width: 2),
              borderRadius: BorderRadius.circular(12.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: ConstantColors.textFieldBoarderColor, width: 2),
              borderRadius: BorderRadius.circular(12.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: ConstantColors.textFieldBoarderColor, width: 2),
              borderRadius: BorderRadius.circular(12.0),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                  color: ConstantColors.textFieldBoarderColor, width: 2),
              borderRadius: BorderRadius.circular(12.0),
            ),
            hintText: hintText,
            prefixIcon: prefixIcon,
            hintStyle: TextStyle(color: ConstantColors.hintTextColor)));
  }


  static buildCustomTextField({
    required String hintText,
    String? Function(String?)? validator,
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType textInputType = TextInputType.text,
    EdgeInsets contentPadding = EdgeInsets.zero,
    int maxLines = 1,
    bool enabled = true,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      obscureText: obscureText,
      validator: validator,
      controller: controller,
      keyboardType: textInputType,
      maxLines: maxLines,
      enabled: enabled,
      onChanged: onChanged,
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        contentPadding: contentPadding,
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }


  static buildListTile({
    required String title,
    required IconData icon,
    required VoidCallback onPress,
    bool endIcon = true,
    Color? iconColor,
    Color? iconBackgroundColor,
    Color? textColor,
  }) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: iconBackgroundColor ?? Colors.blue.withOpacity(0.1),
        ),
        child: Icon(
          icon,
          color: iconColor ?? Colors.blue,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.black,
          fontSize: 16,
        ),
      ),
      trailing: endIcon
          ? Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey.withOpacity(0.1),
        ),
        child: Icon(
          Icons.chevron_right,
          color: Colors.grey,
        ),
      )
          : null,
    );
  }
}
