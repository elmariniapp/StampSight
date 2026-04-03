/// Référence courte alignée sur l’export PDF (unitaire et groupé).
String proofReferenceLabelFromProofId(String proofId) {
  final idStr = proofId.length > 8 ? proofId.substring(0, 8) : proofId;
  return 'SS-${idStr.toUpperCase()}';
}
