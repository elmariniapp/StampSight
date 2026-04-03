/// Abstraction key-value locale (V1 : SharedPreferences ; évolutions : chiffrement, isolats, etc.).
abstract class PreferencesStore {
  Future<String?> getString(String key);

  Future<void> setString(String key, String value);

  Future<bool?> getBool(String key);

  Future<void> setBool(String key, bool value);
}
