import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/clients/data/clients_repository.dart' as clients_impl;
import '../../features/proofs/data/proof_repository.dart' as impl;
import '../../features/proofs/domain/proof_repository.dart';
import '../../features/session/domain/active_session_notifier.dart';
import '../../features/session/domain/active_session_repository.dart';
import '../../features/settings/data/app_settings_repository.dart';

/// Accès injectable au dépôt de preuves (même instance que [impl.ProofRepository.instance] après bootstrap).
final proofRepositoryProvider = Provider<ProofRepository>((ref) {
  return impl.ProofRepository.instance;
});

/// Même instance que [proofRepositoryProvider], pour [Listenable.merge] / écoute des mutations preuves.
final proofRepositoryListenableProvider = Provider<Listenable>((ref) {
  return impl.ProofRepository.instance;
});

/// Clients + sites/missions — [clients_impl.ClientsRepository] est un [ChangeNotifier] :
/// [ref.watch] se reconstruit sur chaque mutation (liste, empty state, compteurs).
final clientsRepositoryProvider =
    ChangeNotifierProvider<clients_impl.ClientsRepository>((ref) {
  return clients_impl.ClientsRepository.instance;
});

/// Session active (même instance que [ActiveSessionNotifier.instance]).
final activeSessionRepositoryProvider =
    Provider<ActiveSessionRepository>((ref) {
  return ActiveSessionNotifier.instance;
});

/// Préférences produit (SharedPreferences + [ChangeNotifier]).
final appSettingsRepositoryProvider =
    ChangeNotifierProvider<AppSettingsRepository>((ref) {
  return AppSettingsRepository.instance;
});
