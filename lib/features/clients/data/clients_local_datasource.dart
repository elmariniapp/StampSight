import 'dart:convert';

import '../../../core/constants/storage_keys.dart';
import '../../../core/storage/preferences_store.dart';
import '../../../core/storage/shared_preferences_store.dart';
import '../domain/client.dart';
import '../domain/site_mission.dart';

class ClientsLocalDatasource {
  ClientsLocalDatasource({PreferencesStore? preferencesStore})
      : _injected = preferencesStore;

  final PreferencesStore? _injected;
  PreferencesStore? _store;

  Future<PreferencesStore> get _preferences async {
    _store ??= _injected ?? await SharedPreferencesStore.open();
    return _store!;
  }

  Future<bool> hasSavedClientsBlob() async {
    final prefs = await _preferences;
    return await prefs.getString(StorageKeys.clientsData) != null;
  }

  Future<List<Client>> loadClients() async {
    final prefs = await _preferences;
    final jsonString = await prefs.getString(StorageKeys.clientsData);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList
        .map((e) => Client.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveClients(List<Client> clients) async {
    final prefs = await _preferences;
    final jsonList = clients.map((c) => c.toMap()).toList();
    await prefs.setString(StorageKeys.clientsData, json.encode(jsonList));
  }

  Future<List<SiteMission>> loadSites() async {
    final prefs = await _preferences;
    final jsonString = await prefs.getString(StorageKeys.sitesData);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList
        .map((e) => SiteMission.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveSites(List<SiteMission> sites) async {
    final prefs = await _preferences;
    final jsonList = sites.map((s) => s.toMap()).toList();
    await prefs.setString(StorageKeys.sitesData, json.encode(jsonList));
  }
}
