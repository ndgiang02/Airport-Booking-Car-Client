import 'package:flutter/material.dart';
import '../../constant/constant.dart';


Widget Loading(){
  return  Center(
    child: Image.asset(imgLoader,
        color: const Color(0xFF1e2c45), width: 50, height: 50),
  );
}
