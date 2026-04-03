import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/storage_keys.dart';
import 'app_strings.dart';
import 'strings_en.dart';
import 'strings_fr.dart';

abstract final class AppLocale {
  static const List<Locale> supportedLocales = [
    Locale('fr'),
    Locale('en'),
  ];

  static final AppLocaleController instance = AppLocaleController._();

  static AppStrings stringsFor(Locale locale) {
    return locale.languageCode == 'en' ? const StringsEn() : const StringsFr();
  }
}

class AppLocaleController extends ChangeNotifier {
  AppLocaleController._();

  Locale _locale = AppLocale.supportedLocales.first;

  Locale get locale => _locale;

  AppStrings get strings => AppLocale.stringsFor(_locale);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString(StorageKeys.localeCode);
    if (savedCode != null) {
      _locale = _supportedLocaleFor(savedCode);
      return;
    }
    final onboardingDone =
        prefs.getBool(StorageKeys.onboardingCompleted) ?? false;
    if (onboardingDone) {
      _locale = AppLocale.supportedLocales.first;
      await prefs.setString(StorageKeys.localeCode, _locale.languageCode);
      return;
    }
    final sys = PlatformDispatcher.instance.locale.languageCode;
    if (AppLocale.supportedLocales.any((l) => l.languageCode == sys)) {
      _locale = _supportedLocaleFor(sys);
    } else {
      _locale = AppLocale.supportedLocales.first;
    }
    await prefs.setString(StorageKeys.localeCode, _locale.languageCode);
  }

  Future<void> setLocaleCode(String code) async {
    final nextLocale = _supportedLocaleFor(code);
    if (nextLocale == _locale) {
      return;
    }

    _locale = nextLocale;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.localeCode, _locale.languageCode);
  }

  Locale _supportedLocaleFor(String code) {
    return AppLocale.supportedLocales.firstWhere(
      (locale) => locale.languageCode == code,
      orElse: () => AppLocale.supportedLocales.first,
    );
  }
}
