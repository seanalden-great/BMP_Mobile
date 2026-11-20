import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends GetxService {
  static const String _storageKey = 'app_locale';
  var currentLocale = const Locale('id', 'ID').obs;

  bool get isIndonesian => currentLocale.value.languageCode == 'id';

  Future<LanguageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString(_storageKey) ?? 'id';
    currentLocale.value = savedCode == 'en'
        ? const Locale('en', 'US')
        : const Locale('id', 'ID');
    return this;
  }

  Future<void> toggleLanguage() async {
    final nextLocale = isIndonesian
        ? const Locale('en', 'US')
        : const Locale('id', 'ID');
    await changeLanguage(nextLocale);
  }

  Future<void> changeLanguage(Locale locale) async {
    currentLocale.value = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, locale.languageCode);
    Get.updateLocale(locale);
  }
}