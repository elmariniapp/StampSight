import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../proofs/domain/proof.dart';
import '../../../proofs/presentation/widgets/proof_capture_hero_image.dart';

/// Ombre carte grille : entre `sm` et `md`, lisible sans effet « lourd ».
const _proofGridCardShadow = [
  BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 10,
    offset: Offset(0, 2),
  ),
  BoxShadow(
    color: Color(0x060D1B2A),
    blurRadius: 18,
    offset: Offset(0, 5),
  ),
];

/// Carte preuve premium : visuel d’illustration par catégorie (assets), métadonnées
/// (catégorie, titre, lieu, ligne temps). Fond éditorial uniquement si l’asset
/// ne charge pas.
class ProofGridItem extends StatelessWidget {
  final Proof proof;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const ProofGridItem({
    super.key,
    required this.proof,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final categoryColor = _colorForType(proof.proofType);

    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadius.lgAll,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.07),
          width: 1,
        ),
        boxShadow: _proofGridCardShadow,
      ),
      child: ClipRRect(
        borderRadius: AppRadius.lgAll,
        child: Material(
          color: AppColors.surface,
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 16,
                  child: _ProofHeroVisual(
                    proof: proof,
                    categoryColor: categoryColor,
                    l10n: l10n,
                  ),
                ),
                Container(
                  height: 1,
                  color: AppColors.border,
                ),
                Expanded(
                  flex: 12,
                  child: _ProofMetaBlock(
                    proof: proof,
                    categoryColor: categoryColor,
                    l10n: l10n,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _colorForType(ProofType type) => switch (type) {
        ProofType.inspection => AppColors.categoryInspection,
        ProofType.delivery => AppColors.categoryDelivery,
        ProofType.workProgress => AppColors.categoryProgress,
        ProofType.incident => AppColors.categoryIncident,
        ProofType.inventory => AppColors.categoryInventory,
        ProofType.other => AppColors.categoryOther,
      };
}

// ─── Zone visuelle : photo ou fond éditorial (sans motif décoratif) ─────────

class _ProofHeroVisual extends StatelessWidget {
  final Proof proof;
  final Color categoryColor;
  final AppLocalizations l10n;

  const _ProofHeroVisual({
    required this.proof,
    required this.categoryColor,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: ProofCaptureHeroImage(
            proof: proof,
            categoryColor: categoryColor,
          ),
        ),
        // Lisibilité bas de visuel uniquement
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 58,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.primary.withValues(alpha: 0.1),
                    AppColors.primaryDark.withValues(alpha: 0.38),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
        ),
        // Favori : discret, coin supérieur
        if (proof.isFavorite)
          Positioned(
            top: AppSpacing.sm,
            right: AppSpacing.sm,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.primaryDark.withValues(alpha: 0.45),
                borderRadius: AppRadius.smAll,
              ),
              child: Icon(
                Icons.star_rounded,
                size: 16,
                color: AppColors.secondaryLight,
              ),
            ),
          ),
        // Sceau date sur le visuel (crédible, type tampon terrain)
        Positioned(
          left: AppSpacing.sm,
          right: AppSpacing.sm,
          bottom: AppSpacing.sm,
          child: Row(
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm + 1,
                    vertical: AppSpacing.xxs + 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.94),
                    borderRadius: AppRadius.smAll,
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.09),
                      width: 1,
                    ),
                    boxShadow: AppShadows.sm,
                  ),
                  child: Text(
                    proof.overlayDateText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.15,
                      height: 1.15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Bloc métadonnées : hiérarchie stricte ─────────────────────────────────

class _ProofMetaBlock extends StatelessWidget {
  final Proof proof;
  final Color categoryColor;
  final AppLocalizations l10n;

  const _ProofMetaBlock({
    required this.proof,
    required this.categoryColor,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final categoryLabel = _labelForType(proof.proofType, l10n);
    final relative = DateFormatters.formatRelative(proof.createdAt, l10n);
    final addressText = proof.address ?? l10n.sourceLocal;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Cellules étroites (grille 2 colonnes / petits écrans) : adresse 1 ligne.
        final addressMaxLines = constraints.maxWidth >= 158 ? 2 : 1;

        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
          ),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.cardPadding,
            AppSpacing.md,
            AppSpacing.cardPadding,
            AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xxs + 2,
                      ),
                      decoration: BoxDecoration(
                        color: categoryColor.withValues(alpha: 0.08),
                        borderRadius: AppRadius.fullAll,
                        border: Border.all(
                          color: categoryColor.withValues(alpha: 0.22),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        categoryLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.25,
                          fontSize: 11,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm + 2),
              Text(
                proof.title,
                style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.22,
                  letterSpacing: -0.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Icon(
                          Icons.place_outlined,
                          size: 14,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs + 1),
                      Expanded(
                        child: Text(
                          addressText,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                            fontWeight: FontWeight.w500,
                            height: 1.35,
                            fontSize: 12,
                          ),
                          maxLines: addressMaxLines,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppColors.primary.withValues(alpha: 0.06),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 13,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: AppSpacing.xs + 1),
                    Expanded(
                      child: Text(
                        '${proof.overlayTimeText} · $relative',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textTertiary,
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                          fontSize: 10.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _labelForType(ProofType type, AppLocalizations l10n) => switch (type) {
        ProofType.inspection => l10n.proofTypeInspection,
        ProofType.delivery => l10n.proofTypeDelivery,
        ProofType.workProgress => l10n.proofTypeWorkProgress,
        ProofType.incident => l10n.proofTypeIncident,
        ProofType.inventory => l10n.proofTypeInventory,
        ProofType.other => l10n.proofTypeOther,
      };
}
