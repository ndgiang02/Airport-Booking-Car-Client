import 'package:customerapp/views/booking_screen/booking_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:vietmap_flutter_plugin/vietmap_flutter_plugin.dart';

import 'package:customerapp/routes/app_routes.dart';
import 'package:customerapp/utils/preferences/preferences.dart';
import 'constant/constant.dart';
import 'firebase_options.dart';
import 'localization/app_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.initPref();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    debugPrint('Error initializing Firebase: $e');
  }
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  Vietmap.getInstance(Constant.VietMapApiKey);
  String? languageCode = Preferences.getString(Preferences.languageCodeKey);
  if (languageCode.isEmpty) {
    languageCode = 'vi';
    Preferences.setString(Preferences.languageCodeKey, languageCode);
  }

  final Locale locale =
      languageCode == 'vi' ? Locale('vi', 'VN') : Locale('en', 'US');
  runApp(MyApp(
    locale: locale,
  ));
}

class MyApp extends StatelessWidget {
  final Locale locale;

  const MyApp({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetMaterialApp(
        title: 'CarAirPlan',
        theme: ThemeData(
          fontFamily: 'SFPro',
        ),
        debugShowCheckedModeBanner: false,
        locale: locale,
        fallbackLocale: Locale('vi', 'VN'),
        translations: AppTranslations(),
        builder: EasyLoading.init(),
        initialRoute: AppRoutes.initialRoute,
        getPages: AppRoutes.pages,
      ),
    );
  }
}
