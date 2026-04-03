import 'dart:io';

import 'package:flutter/material.dart';

import '../../domain/proof.dart';
import '../../domain/proof_local_image.dart';
import 'proof_category_hero_image.dart';

/// Photo réelle si [proof] pointe vers un fichier local, sinon illu catégorie.
class ProofCaptureHeroImage extends StatelessWidget {
  final Proof proof;
  final Color categoryColor;

  const ProofCaptureHeroImage({
    super.key,
    required this.proof,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    if (proof.refersToLocalImageFile) {
      return Image.file(
        File(proof.imagePath),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => ProofCategoryHeroImage(
          proofType: proof.proofType,
          categoryColor: categoryColor,
        ),
      );
    }
    return ProofCategoryHeroImage(
      proofType: proof.proofType,
      categoryColor: categoryColor,
    );
  }
}
