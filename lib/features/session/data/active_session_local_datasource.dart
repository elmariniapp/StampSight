import 'dart:convert';

import '../../../core/constants/storage_keys.dart';
import '../../../core/storage/preferences_store.dart';
import '../../../core/storage/shared_preferences_store.dart';

class ActiveSessionLocalDatasource {
  ActiveSessionLocalDatasource({PreferencesStore? preferencesStore})
      : _injected = preferencesStore;

  final PreferencesStore? _injected;
  PreferencesStore? _store;

  Future<PreferencesStore> get _preferences async {
    _store ??= _injected ?? await SharedPreferencesStore.open();
    return _store!;
  }

  Future<({String clientId, String siteId})?> loadIds() async {
    final prefs = await _preferences;
    final raw = await prefs.getString(StorageKeys.activeSessionData);
    if (raw == null || raw.isEmpty) return null;

    final map = json.decode(raw) as Map<String, dynamic>;
    final clientId = map['clientId'] as String?;
    final siteId = map['siteId'] as String?;
    if (clientId == null || siteId == null) return null;

    return (clientId: clientId, siteId: siteId);
  }

  Future<void> saveIds({required String clientId, required String siteId}) async {
    final prefs = await _preferences;
    await prefs.setString(
      StorageKeys.activeSessionData,
      json.encode({'clientId': clientId, 'siteId': siteId}),
    );
  }

  Future<void> clear() async {
    final prefs = await _preferences;
    await prefs.setString(StorageKeys.activeSessionData, '');
  }
}
