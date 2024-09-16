import 'package:flutter/material.dart';
import 'contant_colors.dart';

class TextFieldTheme {

  static Widget boxBuildTextField({
    required String hintText,
    required TextEditingController controller,
    TextInputType textInputType = TextInputType.text,
    bool obscureText = false,
    int maxLines = 1,
    Widget? prefixIcon,
    Widget? suffixIcon,
    void Function(String)? onChanged,
    String? Function(String?)? validators,
    int maxLength = 300,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: textInputType,
      maxLines: maxLines,
      validator: validators,
      maxLength: maxLength,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon:suffixIcon,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            width: 1.0,
            color: Colors.cyan,
          ),
        ),
        counterText: "",
      ),
      onChanged: onChanged,
    );
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
