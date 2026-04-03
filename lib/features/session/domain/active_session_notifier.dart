import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../clients/domain/clients_repository.dart';
import '../data/active_session_local_datasource.dart';
import 'active_session.dart';
import 'active_session_repository.dart';

class ActiveSessionNotifier extends ValueNotifier<ActiveSession?>
    implements ActiveSessionRepository {
  ActiveSessionNotifier({ActiveSessionLocalDatasource? storage})
      : _storage = storage ?? ActiveSessionLocalDatasource(),
        super(null);

  static final ActiveSessionNotifier instance = ActiveSessionNotifier();

  final ActiveSessionLocalDatasource _storage;

  @override
  ActiveSession? get currentSession => value;

  @override
  bool get hasSession => value != null;

  @override
  void startSession(ActiveSession session) {
    value = session;
    unawaited(_storage.saveIds(
      clientId: session.client.id,
      siteId: session.site.id,
    ));
  }

  @override
  void endSession() {
    value = null;
    unawaited(_storage.clear());
  }

  Future<void> restoreAfterClients(ClientsRepository clients) async {
    final ids = await _storage.loadIds();
    if (ids == null) return;

    final client = clients.getClientById(ids.clientId);
    final site = clients.getSiteById(ids.siteId);
    if (client != null && site != null) {
      value = ActiveSession(client: client, site: site);
    } else {
      await _storage.clear();
    }
  }
}
