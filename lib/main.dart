import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:vietmap_flutter_plugin/vietmap_flutter_plugin.dart';

import 'package:customerapp/routes/app_routes.dart';
import 'package:customerapp/utils/preferences/preferences.dart';
import 'constant/constant.dart';
import 'localization/app_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.initPref();
  Vietmap.getInstance(Constant.VietMapApiKey);
  final String? languageCode =
      Preferences.getString(Preferences.languageCodeKey);
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
        fallbackLocale: Locale('en', 'US'),
        translations: AppTranslations(),
        builder: EasyLoading.init(),
        initialRoute: AppRoutes.airportScreen,
        getPages: AppRoutes.pages,
      ),
    );
  }
}
