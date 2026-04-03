import 'package:flutter/material.dart';

import '../../domain/proof.dart';
import '../proof_category_asset.dart';

/// Illustration catégorie : `proofs/` puis miroir `home/`, puis génériques, puis dégradé.
class ProofCategoryHeroImage extends StatelessWidget {
  final ProofType proofType;
  final Color categoryColor;

  const ProofCategoryHeroImage({
    super.key,
    required this.proofType,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ProofCategoryAsset.placeholderFor(proofType),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, _, _) => Image.asset(
        ProofCategoryAsset.homeMirrorFor(proofType),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, _, _) => Image.asset(
          ProofCategoryAsset.genericProofs,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (_, _, _) => Image.asset(
            ProofCategoryAsset.genericHome,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (_, _, _) =>
                _CategoryToneFallback(categoryColor: categoryColor),
          ),
        ),
      ),
    );
  }
}

class _CategoryToneFallback extends StatelessWidget {
  final Color categoryColor;

  const _CategoryToneFallback({required this.categoryColor});

  @override
  Widget build(BuildContext context) {
    final deep = HSLColor.fromColor(categoryColor);
    final darker = deep
        .withLightness((deep.lightness - 0.12).clamp(0.0, 1.0))
        .toColor();

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(categoryColor, Colors.white, 0.08)!,
            darker,
          ],
        ),
      ),
    );
  }
}
