import 'dart:io';
import '../utils/preferences/preferences.dart';

class API {
  static const baseUrl = "http://192.168.11.32:8000/api/";
  static const apiKey = "";

  static Map<String, String> authheader = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    'apikey': apiKey,
  };

  static Map<String, String> header = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    HttpHeaders.acceptHeader: 'application/json',
    'Authorization': 'Bearer ${Preferences.getString(Preferences.token) ?? ''}',
    'apikey': apiKey,
  };


  static const userSignUP = "${baseUrl}register";
  static const userLogin = "${baseUrl}login";
  static const sendResetPasswordOtp = "${baseUrl}send-otp";
  static const resetPasswordOtp = "${baseUrl}reset-password-otp";
  static const changePassword = "${baseUrl}change-password";
  static const fetchTrips = "${baseUrl}fetch-trips";
  static const bookRides = "${baseUrl}trip-booking";
  static const fetchVehicle = "${baseUrl}vehicle-types";

  static const deleteUser = "${baseUrl}delete-user-account";
  static const logOut = "${baseUrl}logout";

  static const introduction = "${baseUrl}intro";
  static const terms = "${baseUrl}terms";


  static const updateName = "${baseUrl}user-name";
  static const contactUs = "${baseUrl}contact-us";
  static const updateToken = "${baseUrl}update-fcm";
  static const rentVehicle = "${baseUrl}vehicle-get";
  static const transaction = "${baseUrl}transaction";
  static const getFcmToken = "${baseUrl}fcm-token";
  static const deleteFavouriteRide = "${baseUrl}delete-favorite-ride";
  static const rejectRide = "${baseUrl}set-rejected-requete";

}


/*
class API {
  static const baseUrl = ""; // live
  static const apiKey = "";

  static Map<String, String> authheader = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    'apikey': apiKey,
  };
  static Map<String, String> header = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    'apikey': apiKey,
    'accesstoken': Preferences.getString(Preferences.accesstoken)
  };

  static const userSignUP = "${baseUrl}user";
  static const userLogin = "${baseUrl}user-login";
  static const sendResetPasswordOtp = "${baseUrl}reset-password-otp";
  static const resetPasswordOtp = "${baseUrl}reset-password";
  static const changePassword = "${baseUrl}update-user-mdp";
  static const updateName = "${baseUrl}user-name";
  static const contactUs = "${baseUrl}contact-us";
  static const updateToken = "${baseUrl}update-fcm";
  static const rentVehicle = "${baseUrl}vehicle-get";
  static const transaction = "${baseUrl}transaction";
  static const getFcmToken = "${baseUrl}fcm-token";
  static const deleteFavouriteRide = "${baseUrl}delete-favorite-ride";
  static const rejectRide = "${baseUrl}set-rejected-requete";

  static const introduction = "${baseUrl}introduction";
  static const getRideReview = "${baseUrl}get-ride-review";
  static const taxi = "${baseUrl}taxi";
  static const setFavouriteRide = "${baseUrl}favorite-ride";
  static const getVehicleCategory = "${baseUrl}Vehicle-category";
  static const driverDetails = "${baseUrl}driver";
  static const bookRides = "${baseUrl}requete-register";
  static const newRide = "${baseUrl}requete-userapp";
  static const confirmedRide = "${baseUrl}user-confirmation";
  static const onRide = "${baseUrl}user-ride";
  static const completedRide = "${baseUrl}user-complete";
  static const canceledRide = "${baseUrl}user-cancel";
  static const driverConfirmRide = "${baseUrl}driver-confirm";
  static const feelSafeAtDestination = "${baseUrl}feel-safe";
  static const sos = "${baseUrl}storesos";
  static const bookRide = "${baseUrl}set-Location";
  static const getRentedData = "${baseUrl}location";
  static const cancelRentedVehicle = "${baseUrl}canceled-location";
  static const addReview = "${baseUrl}note";
  static const addComplaint = "${baseUrl}complaints";
  static const discountList = "${baseUrl}discount-list";
  static const rideDetails = "${baseUrl}ridedetails";
  static const deleteUser = "${baseUrl}user-delete?user_id=";
  static const settings = "${baseUrl}settings";
  static const privacyPolicy = "${baseUrl}privacy-policy";
  static const termsOfCondition = "${baseUrl}terms-of-condition";
}
*/
