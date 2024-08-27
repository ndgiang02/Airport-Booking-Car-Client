import 'package:customerapp/localization/en_language.dart';
import 'package:customerapp/localization/vi_language.dart';
import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': enUS,
    'vi': viVN,
  };
}
