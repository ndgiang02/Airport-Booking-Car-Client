import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';
import '../utils/preferences/preferences.dart';
import '../utils/themes/contant_colors.dart';

const img_loader = 'assets/images/loader.gif';
const ic_logo_white = 'assets/icons/ic_logo_white.png';
const login_background = 'assets/images/login_bg.png';
const en_flag = 'assets/flags/uk.png';
const vi_flag = 'assets/flags/vietnam.png';
const ic_edit = 'assets/icons/edit.png';
const meme = 'assets/images/meme.jpg';
const ic_pic_drop_location = 'assets/icons/ic_pic_drop_location.png';
const ic_swap = 'assets/icons/swap.png';
const ic_pickup = 'assets/icons/pickup.png';
const ic_dropoff = 'assets/icons/dropoff.png';
const ic_stop = 'assets/icons/pink.png';

const API_KEY_LOCATION = '46f110f0e3msh0377381c278bffep11c5c9jsn20829ea2b0e4';

class Constant {
  static String VietMapApiKey = 'de05231caf176a61b2886deaf1e6dd46944b6b2d0638ec4f';
  static String baseUrl = 'https://maps.vietmap.vn/api';
  static String kGoogleApiKey = "";
  static String distanceUnit = "KM";
  static String durationUnit = "min";
  static String appVersion = "0.1";
  static int decimal = 2;
  static int taxValue = 0;
  static String currency = "\$";
  static String taxType = 'Percentage';
  static String taxName = 'Tax';
  static String contactUsEmail = "giang@gmail.com", contactUsAddress = "HCMC", contactUsPhone = "";
  static String rideOtp = "yes";
  static bool symbolAtRight = false;
  static String driverLocationUpdate = "10";
  static String deliverChargeParcel = "0";
  static String? parcelActive = "";
  static String? parcelPerWeightCharge = "";
  static String? jsonNotificationFileURL = "";
  static String? senderId = "";

  static String getUuid() {
    var uuid = const Uuid();
    return uuid.v1();
  }

  static Widget loader() {
    return Center(
      child: CircularProgressIndicator(color: ConstantColors.primary),
    );
  }

  static UserModel getUserData() {
    final String user = Preferences.getString(Preferences.user);
    Map<String, dynamic> userMap = jsonDecode(user);
    return UserModel.fromJson(userMap);
  }

  String amountShow({required String? amount}) {
    if (amount!.isNotEmpty && amount.toString() != "null") {
      if (Constant.symbolAtRight == true) {
        return "${double.parse(amount.toString()).toStringAsFixed((Constant.decimal))} ${Constant.currency.toString()}";
      } else {
        return "${Constant.currency.toString()} ${double.parse(amount.toString()).toStringAsFixed(Constant.decimal!)}";
      }
    } else {
      if (Constant.symbolAtRight == true) {
        return "${double.parse(0.toString()).toStringAsFixed(Constant.decimal)} ${Constant.currency.toString()}";
      } else {
        return "${Constant.currency.toString()} ${double.parse(0.toString()).toStringAsFixed(Constant.decimal)}";
      }
    }
  }


}

class Url {
  String mime;

  String url;

  Url({this.mime = '', this.url = ''});

  factory Url.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Url(mime: parsedJson['mime'] ?? '', url: parsedJson['url'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'mime': mime, 'url': url};
  }
}




