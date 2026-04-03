import 'dart:convert';

import '../../../core/constants/storage_keys.dart';
import '../../../core/storage/preferences_store.dart';
import '../../../core/storage/shared_preferences_store.dart';
import '../domain/proof.dart';

class ProofLocalDatasource {
  ProofLocalDatasource({PreferencesStore? preferencesStore})
      : _injected = preferencesStore;

  final PreferencesStore? _injected;
  PreferencesStore? _store;

  Future<PreferencesStore> get _preferences async {
    _store ??= _injected ?? await SharedPreferencesStore.open();
    return _store!;
  }

  Future<List<Proof>> loadProofs() async {
    final prefs = await _preferences;
    final jsonString = await prefs.getString(StorageKeys.proofsData);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList
        .map((e) => Proof.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveProofs(List<Proof> proofs) async {
    final prefs = await _preferences;
    final jsonList = proofs.map((p) => p.toMap()).toList();
    await prefs.setString(StorageKeys.proofsData, json.encode(jsonList));
  }

}
