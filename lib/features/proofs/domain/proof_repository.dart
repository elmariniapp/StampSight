import 'proof.dart';

/// Contrat local-first des opérations sur les preuves (voir implémentation dans `data/proof_repository.dart`).
abstract class ProofRepository {
  Future<void> initialize();

  List<Proof> get proofs;

  List<Proof> get recentProofs;

  List<Proof> get favoriteProofs;

  int get totalCount;

  Proof? getById(String id);

  Future<void> addProof(Proof proof);

  Future<void> updateProof(Proof proof);

  Future<void> deleteProof(String id);

  /// Retire client/site des preuves liées (preuves conservées, non classées).
  Future<void> clearClassificationForClient(
    String clientId,
    Set<String> siteIds,
  );

  Future<void> toggleFavorite(String id);

  List<Proof> filterByType(ProofType type);
}
