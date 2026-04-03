import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/capture_overlay_preset.dart';

class CapturePreferencesService {
  SharedPreferences? _prefs;

  Future<SharedPreferences> get _preferences async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<bool> getShowDate() async {
    final prefs = await _preferences;
    return prefs.getBool(StorageKeys.overlayShowDate) ?? true;
  }

  Future<void> setShowDate(bool value) async {
    final prefs = await _preferences;
    await prefs.setBool(StorageKeys.overlayShowDate, value);
  }

  Future<bool> getShowTime() async {
    final prefs = await _preferences;
    return prefs.getBool(StorageKeys.overlayShowTime) ?? true;
  }

  Future<void> setShowTime(bool value) async {
    final prefs = await _preferences;
    await prefs.setBool(StorageKeys.overlayShowTime, value);
  }

  Future<bool> getShowAddress() async {
    final prefs = await _preferences;
    return prefs.getBool(StorageKeys.overlayShowAddress) ?? true;
  }

  Future<void> setShowAddress(bool value) async {
    final prefs = await _preferences;
    await prefs.setBool(StorageKeys.overlayShowAddress, value);
  }

  Future<bool> getShowCoordinates() async {
    final prefs = await _preferences;
    return prefs.getBool(StorageKeys.overlayShowCoordinates) ?? false;
  }

  Future<void> setShowCoordinates(bool value) async {
    final prefs = await _preferences;
    await prefs.setBool(StorageKeys.overlayShowCoordinates, value);
  }

  Future<CaptureOverlayPreset> loadPreset([AppLocalizations? l10n]) async {
    final presetName = switch ((l10n?.languageCode ?? 'fr')) {
      'en' => 'Balanced',
      _ => 'Equilibre',
    };

    return CaptureOverlayPreset(
      id: 'custom',
      name: presetName,
      showDate: await getShowDate(),
      showTime: await getShowTime(),
      showAddress: await getShowAddress(),
      showCoordinates: await getShowCoordinates(),
    );
  }
}
