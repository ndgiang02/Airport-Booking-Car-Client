import 'package:customerapp/bindings/activities_binding/activities_binding.dart';
import 'package:customerapp/bindings/booking_binding/booking_binding.dart';
import 'package:customerapp/bindings/home_binding/home_binding.dart';
import 'package:customerapp/bindings/notification_binding/notification_binding.dart';
import 'package:customerapp/views/activities_screen/activitis_screen.dart';
import 'package:customerapp/views/booking_screen/longtrip_screen.dart';
import 'package:customerapp/views/home_screens/home_screen.dart';
import 'package:customerapp/views/notifition_screen/notifition_screen.dart';
import 'package:customerapp/views/splash_screen/splash_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../views/booking_screen/booking_screen.dart';

class AppRoutes {
  static const String homeScreen = '/home';

  static const String activitiesScreen = '/activities';

  static const String notificationScreen = '/notification';

  static const String manageScreen = '/manage';

  static const String profileScreen = '/profile';

  static const String localizationScreen = '/localization';

  static const String airportScreen = '/airport';

  static const String longtripScreen = '/longtrip';

  static const String initialRoute = '/initialRoute';

  static List<GetPage> pages = [
    GetPage(
      name: initialRoute,
      page: () => SplashScreen(),
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
      name: airportScreen,
      page: () => AirportScreen(),
      bindings: [
        BookingBinding(),
      ],
    ),
    GetPage(
      name: longtripScreen,
      page: () => LongtripScreen(),
      bindings: [
        BookingBinding(),
      ],
    ),

  ];
}