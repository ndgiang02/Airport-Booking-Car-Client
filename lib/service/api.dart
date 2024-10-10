import 'dart:io';
import '../utils/preferences/preferences.dart';

class API {
  static const baseUrl = "http://192.168.11.30:8000/api/";
  static const apiKey = "";

  static Map<String, String> authheader = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    'apikey': apiKey,
  };

  static Map<String, String> header = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    HttpHeaders.acceptHeader: 'application/json',
    'Authorization': 'Bearer ${Preferences.getString(Preferences.token)}',
    'apikey': apiKey,
  };


  static const userSignUP = "${baseUrl}register";
  static const userLogin = "${baseUrl}login";
  static const sendResetPasswordOtp = "${baseUrl}send-otp";
  static const resetPasswordOtp = "${baseUrl}reset-password-otp";
  static const changePassword = "${baseUrl}change-password";
  static const fetchTrips = "${baseUrl}fetch-trips";
  static const bookTrip = "${baseUrl}trip-booking";
  static const bookClusterTrip = "${baseUrl}trip-cluster";
  static const cancelTrip = "${baseUrl}cancel-trip";
  static const fetchVehicle = "${baseUrl}vehicle-types";

  static const deleteUser = "${baseUrl}delete-user-account";
  static const logOut = "${baseUrl}logout";

  static const introduction = "${baseUrl}intro";
  static const terms = "${baseUrl}terms";

  static const getUserByPhone = "${baseUrl}get-user-by-phone";
  static const checkUser = "${baseUrl}check-phone";


  static const updateName = "${baseUrl}user-name";
  static const contactUs = "${baseUrl}contact-us";
  static const updateToken = "${baseUrl}update-fcm";
  static const rentVehicle = "${baseUrl}vehicle-get";
  static const transaction = "${baseUrl}transaction";
  static const getFcmToken = "${baseUrl}fcm-token";

}

