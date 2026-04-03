import 'dart:io';

import 'proof.dart';

extension ProofLocalImage on Proof {
  /// Vrai fichier capturé persistant (hors chemins seed `demo/…`).
  bool get refersToLocalImageFile {
    final p = imagePath;
    if (p.startsWith('demo/')) return false;
    try {
      return File(p).existsSync();
    } catch (_) {
      return false;
    }
  }
}
