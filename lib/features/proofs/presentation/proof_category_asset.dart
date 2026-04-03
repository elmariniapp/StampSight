import '../domain/proof.dart';

/// Chemins des illustrations par catégorie. Les fichiers existent sous `proofs/`
/// et en miroir sous `home/` (même nom) pour résilience au bundle.
abstract final class ProofCategoryAsset {
  static const String _proofs = 'assets/images/proofs';
  static const String _home = 'assets/images/home';

  static String _file(ProofType type) => switch (type) {
        ProofType.inspection => 'proof_inspection_01.webp',
        ProofType.delivery => 'proof_delivery_01.webp',
        ProofType.workProgress => 'proof_progress_01.webp',
        ProofType.incident => 'proof_incident_01.webp',
        ProofType.inventory => 'proof_inventory_01.webp',
        ProofType.other => 'proof_generic_01.webp',
      };

  static String placeholderFor(ProofType type) => '$_proofs/${_file(type)}';

  static String homeMirrorFor(ProofType type) => '$_home/${_file(type)}';

  static String get genericProofs => '$_proofs/proof_generic_01.webp';

  static String get genericHome => '$_home/proof_generic_01.webp';
}
