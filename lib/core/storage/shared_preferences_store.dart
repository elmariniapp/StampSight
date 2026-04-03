import 'package:shared_preferences/shared_preferences.dart';

import 'preferences_store.dart';

final class SharedPreferencesStore implements PreferencesStore {
  SharedPreferencesStore._(this._prefs);

  final SharedPreferences _prefs;

  static Future<SharedPreferencesStore> open() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPreferencesStore._(prefs);
  }

  @override
  Future<String?> getString(String key) async => _prefs.getString(key);

  @override
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  @override
  Future<bool?> getBool(String key) async => _prefs.getBool(key);

  @override
  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }
}
