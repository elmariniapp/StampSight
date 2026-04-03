import 'dart:async';

import 'package:flutter/foundation.dart';

import '../domain/client.dart';
import '../domain/clients_repository.dart' as domain;
import '../domain/site_mission.dart';
import 'clients_local_datasource.dart';

class ClientsRepository extends ChangeNotifier implements domain.ClientsRepository {
  ClientsRepository._({ClientsLocalDatasource? datasource})
      : _datasource = datasource ?? ClientsLocalDatasource();

  static final ClientsRepository instance = ClientsRepository._();

  final ClientsLocalDatasource _datasource;
  List<Client> _clients = [];
  List<SiteMission> _sites = [];

  static final _legacySeedClientIds = {'client-001', 'client-002', 'client-003'};
  static final _legacySeedSiteIds = {'site-001', 'site-002', 'site-003', 'site-004'};

  @override
  List<Client> get clients => List.unmodifiable(_clients);
  @override
  List<SiteMission> get sites => List.unmodifiable(_sites);

  @override
  Future<void> initialize() async {
    _clients = await _datasource.loadClients();
    _sites = await _datasource.loadSites();

    final cleanedClients =
        _clients.where((c) => !_legacySeedClientIds.contains(c.id)).toList();
    final cleanedSites =
        _sites.where((s) => !_legacySeedSiteIds.contains(s.id)).toList();
    final changed = cleanedClients.length != _clients.length ||
        cleanedSites.length != _sites.length;
    if (changed) {
      _clients = cleanedClients;
      _sites = cleanedSites;
      await _datasource.saveClients(_clients);
      await _datasource.saveSites(_sites);
    }
    notifyListeners();
  }

  Future<void> _persistAll() async {
    await _datasource.saveClients(_clients);
    await _datasource.saveSites(_sites);
  }

  void _schedulePersist() {
    unawaited(_persistAll());
  }

  @override
  Client? getClientById(String id) {
    try {
      return _clients.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  SiteMission? getSiteById(String id) {
    try {
      return _sites.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  List<SiteMission> sitesForClient(String clientId) =>
      _sites.where((s) => s.clientId == clientId).toList();

  @override
  void addClient(Client client) {
    _clients.insert(0, client);
    _schedulePersist();
    notifyListeners();
  }

  @override
  void updateClient(Client client) {
    final index = _clients.indexWhere((c) => c.id == client.id);
    if (index == -1) return;
    _clients[index] = client;
    _schedulePersist();
    notifyListeners();
  }

  @override
  void deleteClient(String id) {
    _clients.removeWhere((c) => c.id == id);
    _sites.removeWhere((s) => s.clientId == id);
    _schedulePersist();
    notifyListeners();
  }

  @override
  void addSite(SiteMission site) {
    _sites.add(site);
    _schedulePersist();
    notifyListeners();
  }

  @override
  void updateSite(SiteMission site) {
    final index = _sites.indexWhere((s) => s.id == site.id);
    if (index == -1) return;
    _sites[index] = site;
    _schedulePersist();
    notifyListeners();
  }

  @override
  void deleteSite(String id) {
    _sites.removeWhere((s) => s.id == id);
    _schedulePersist();
    notifyListeners();
  }
}
