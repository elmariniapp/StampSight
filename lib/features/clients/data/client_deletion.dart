import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../proofs/domain/proof_repository.dart' as domain_proof;
import '../../session/domain/active_session_repository.dart';
import '../../settings/data/app_settings_repository.dart';
import 'clients_repository.dart';

/// Synthèse des liens avant suppression (centralisé).
class ClientDeletionAnalysis {
  final int linkedSiteCount;
  final int linkedProofCount;
  final bool activeSessionUsesClient;

  const ClientDeletionAnalysis({
    required this.linkedSiteCount,
    required this.linkedProofCount,
    required this.activeSessionUsesClient,
  });

  bool get hasBlockingDependencies =>
      linkedSiteCount > 0 ||
      linkedProofCount > 0 ||
      activeSessionUsesClient;
}

ClientDeletionAnalysis analyzeClientDeletion(
  ClientsRepository clients,
  domain_proof.ProofRepository proofs,
  ActiveSessionRepository session,
  String clientId,
) {
  final sites = clients.sitesForClient(clientId);
  final siteIds = sites.map((s) => s.id).toSet();
  var proofCount = 0;
  for (final p in proofs.proofs) {
    if (p.clientId == clientId) {
      proofCount++;
      continue;
    }
    if (p.siteMissionId != null && siteIds.contains(p.siteMissionId)) {
      proofCount++;
    }
  }
  final sessionActive = session.currentSession?.client.id == clientId;
  return ClientDeletionAnalysis(
    linkedSiteCount: sites.length,
    linkedProofCount: proofCount,
    activeSessionUsesClient: sessionActive,
  );
}

enum ClientDeletionResult { success, blocked }

/// Politique [block] : refuse si sites, preuves ou session liés. Sinon suppression du client (et sites) après détachement des preuves.
/// Politiques [detachProofs] et [deleteLinkedSites] : même exécution sûre (preuves conservées, relations retirées ; aucune suppression de fichiers preuve).
Future<ClientDeletionResult> executeClientDeletion(
  WidgetRef ref,
  String clientId,
) async {
  final clients = ref.read(clientsRepositoryProvider);
  final proofs = ref.read(proofRepositoryProvider);
  final session = ref.read(activeSessionRepositoryProvider);
  final settings = ref.read(appSettingsRepositoryProvider);

  final analysis = analyzeClientDeletion(
    clients,
    proofs,
    session,
    clientId,
  );

  if (settings.clientDeletePolicy == ClientDeletePolicySetting.block &&
      analysis.hasBlockingDependencies) {
    return ClientDeletionResult.blocked;
  }

  final siteIds = clients.sitesForClient(clientId).map((s) => s.id).toSet();
  await proofs.clearClassificationForClient(clientId, siteIds);

  if (session.currentSession?.client.id == clientId) {
    session.endSession();
  }

  clients.deleteClient(clientId);
  return ClientDeletionResult.success;
}
