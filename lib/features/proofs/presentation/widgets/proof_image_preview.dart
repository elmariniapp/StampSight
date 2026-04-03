import 'dart:io';

import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/proof.dart';
import 'proof_capture_hero_image.dart';

class ProofImagePreview extends StatelessWidget {
  final Proof proof;

  const ProofImagePreview({super.key, required this.proof});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: AppRadius.lgAll,
            boxShadow: [
              BoxShadow(
                color: _colorForType(proof.proofType).withValues(alpha: 0.22),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: AspectRatio(
            aspectRatio: 16 / 10,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ProofCaptureHeroImage(
                  proof: proof,
                  categoryColor: _colorForType(proof.proofType),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 96,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.primaryDark.withValues(alpha: 0.55),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: AppSpacing.md,
                  bottom: AppSpacing.md,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: AppRadius.smAll,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          proof.overlayDateText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'monospace',
                          ),
                        ),
                        Text(
                          proof.overlayTimeText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'monospace',
                          ),
                        ),
                        if (proof.overlayAddressText != null)
                          Text(
                            proof.overlayAddressText!,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.88),
                              fontSize: 10,
                              fontFamily: 'monospace',
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (proof.additionalImagePaths.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.additionalPhotos,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          SizedBox(
            height: 88,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: proof.additionalImagePaths.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final path = proof.additionalImagePaths[index];
                return ClipRRect(
                  borderRadius: AppRadius.mdAll,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.file(
                      File(path),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => ColoredBox(
                        color: AppColors.surfaceVariant,
                        child: Icon(
                          Icons.image_not_supported_rounded,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Color _colorForType(ProofType type) {
    return switch (type) {
      ProofType.inspection => AppColors.primary,
      ProofType.delivery => AppColors.secondary,
      ProofType.workProgress => AppColors.success,
      ProofType.incident => AppColors.error,
      ProofType.inventory => const Color(0xFF7B1FA2),
      ProofType.other => AppColors.textSecondary,
    };
  }
}
