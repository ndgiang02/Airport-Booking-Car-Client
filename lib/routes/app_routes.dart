import 'package:customerapp/bindings/activities_binding/activities_binding.dart';
import 'package:customerapp/bindings/booking_binding/booking_binding.dart';
import 'package:customerapp/bindings/home_binding/home_binding.dart';
import 'package:customerapp/bindings/notification_binding/notification_binding.dart';
import 'package:customerapp/views/home_screens/home_screen.dart';
import 'package:customerapp/views/notifition_screen/notification_detail.dart';
import 'package:customerapp/views/notifition_screen/notifition_screen.dart';
import 'package:customerapp/views/splash_screen/splash_screen.dart';
import 'package:get/get.dart';


import '../views/activities_screen/activities_screen.dart';
import '../views/booking_screen/airport_screen.dart';

class AppRoutes {

  static const String loginScreen = '/login';

  static const String registerScreen = '/register';

  static const String homeScreen = '/home';

  static const String activitiesScreen = '/activities';

  static const String notificationScreen = '/notifications';

  static const String notificationDetail = '/notificationdetail';

  static const String manageScreen = '/manage';

  static const String profileScreen = '/profile';

  static const String localizationScreen = '/localization';

  static const String airportScreen = '/airport';

  static const String longtripScreen = '/longtrip';

  static const String test = '/test';

  static const String initialRoute = '/initialRoute';

  static List<GetPage> pages = [
    GetPage(
      name: initialRoute,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: homeScreen,
      page: () => HomeScreen(),
      bindings: [
        HomeBinding(),
      ],
    ),
    GetPage(
      name: activitiesScreen,
      page: () => ActivitiesScreen(),
      bindings: [
        ActivitiesBinding(),
      ],
    ),
    GetPage(
      name: notificationScreen,
      page: () => NotificationScreen(),
      bindings: [
        NotificationBinding(),
      ],
    ),
    GetPage(
      name: longtripScreen,
      page: () => const AirportScreen1(),
      bindings: [
        BookingBinding(),
      ],
    ),
    GetPage(
      name: notificationDetail,
      page: () => NotificationDetailScreen(notification: Get.arguments),
      bindings: [
        NotificationBinding(),
      ],
    ),

  ];
}