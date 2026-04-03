import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../../../core/widgets/info_chip.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/proof.dart';

class ProofDetailHeader extends StatelessWidget {
  final Proof proof;

  const ProofDetailHeader({super.key, required this.proof});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(proof.title, style: AppTextStyles.displayMedium),
        if (proof.description != null && proof.description!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(proof.description!, style: AppTextStyles.bodyMedium),
        ],
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            InfoChip(
              icon: Icons.category_rounded,
              label: _labelForType(proof.proofType, l10n),
            ),
            InfoChip(
              icon: Icons.access_time_rounded,
              label:
                  DateFormatters.formatDateTime(proof.createdAt, l10n.languageCode),
            ),
            if (proof.isFavorite)
              InfoChip(
                icon: Icons.star_rounded,
                label: l10n.favorite,
                color: AppColors.secondary,
              ),
          ],
        ),
      ],
    );
  }

  String _labelForType(ProofType type, AppLocalizations l10n) {
    return switch (type) {
      ProofType.inspection => l10n.proofTypeInspection,
      ProofType.delivery => l10n.proofTypeDelivery,
      ProofType.workProgress => l10n.proofTypeWorkProgress,
      ProofType.incident => l10n.proofTypeIncident,
      ProofType.inventory => l10n.proofTypeInventory,
      ProofType.other => l10n.proofTypeOther,
    };
  }
}
