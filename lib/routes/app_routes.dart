import 'package:customerapp/bindings/activities_binding/activities_binding.dart';
import 'package:customerapp/bindings/booking_binding/booking_binding.dart';
import 'package:customerapp/bindings/cluster_binding/cluster_binding.dart';
import 'package:customerapp/bindings/home_binding/home_binding.dart';
import 'package:customerapp/bindings/notification_binding/notification_binding.dart';
import 'package:customerapp/views/booking_screen/longtrip_screen.dart';
import 'package:customerapp/views/cluster_screen/cluster_screen.dart';
import 'package:customerapp/views/home_screens/flight_screen.dart';
import 'package:customerapp/views/home_screens/home_screen.dart';
import 'package:customerapp/views/notifition_screen/notification_detail.dart';
import 'package:customerapp/views/notifition_screen/notifition_screen.dart';
import 'package:customerapp/views/splash_screen/splash_screen.dart';
import 'package:get/get.dart';


import '../views/activities_screen/activities_screen.dart';
import '../views/airport_screen/airport_screen.dart';

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

  static const String clusterScreen = '/cluster';

  static const String flightScreen = '/flight';

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
      name: clusterScreen,
      page: () => const ClusterScreen(),
      bindings: [
        ClusterBinding(),
      ],
    ),
    GetPage(
      name: airportScreen,
      page: () => const AirportScreen(),
      bindings: [
        BookingBinding(),
      ],
    ),
    GetPage(
      name: longtripScreen,
      page: () =>  const LongTripScreen(),
      bindings: [
        BookingBinding(),
      ],
    ),
    GetPage(
      name: flightScreen,
      page: () => FlightScreen(),
      bindings: [
        HomeBinding(),
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