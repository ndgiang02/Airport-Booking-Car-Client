import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constant/constant.dart';
import '../models/language_model.dart';
import '../utils/preferences/preferences.dart';

class LocalizationController extends GetxController {
  var languageList = <LanguageData>[].obs;
  RxString selectedLanguage = 'vi'.obs;

  @override
  void onInit() {
    super.onInit();
    loadLanguages();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadSelectedLanguage();
    });
  }

  final List<LanguageData> localeLanguageList = [
    LanguageData(
      language: 'English',
      languageCode: 'en',
      flag: en_flag,
      subTitle: 'English',
    ),
    LanguageData(
      language: 'Tiếng Việt',
      languageCode: 'vi',
      flag: vi_flag,
      subTitle: 'Tiếng Việt',
    ),
  ];

  void loadLanguages() {
    languageList.addAll(localeLanguageList);
  }

  void loadSelectedLanguage() {
    String? storedLanguageCode =
        Preferences.getString(Preferences.languageCodeKey);
    debugPrint('Stored language code: $storedLanguageCode');
    if (storedLanguageCode != null && storedLanguageCode.isNotEmpty) {
      selectedLanguage(storedLanguageCode);
    } else {
      selectedLanguage('vi');
    }
    updateLocale();
  }

  void updateLocale() {
    if (selectedLanguage.value == 'vi') {
      Get.updateLocale(Locale('vi', 'VN'));
    } else {
      Get.updateLocale(Locale('en', 'US'));
    }
  }

  void changeLanguage(String languageCode) {
    selectedLanguage(languageCode);
    Preferences.setString(Preferences.languageCodeKey, languageCode);
    debugPrint('Language changed to: $languageCode');
    updateLocale();
  }
}
