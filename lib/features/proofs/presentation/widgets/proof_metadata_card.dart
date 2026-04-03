import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/proof.dart';

class ProofMetadataCard extends StatelessWidget {
  final Proof proof;

  const ProofMetadataCard({super.key, required this.proof});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.metadata, style: AppTextStyles.titleMedium),
          const SizedBox(height: AppSpacing.md),
          if (proof.address != null)
            _MetadataRow(
              icon: Icons.location_on_rounded,
              label: l10n.address,
              value: proof.address!,
            ),
          if (proof.latitude != null && proof.longitude != null)
            _MetadataRow(
              icon: Icons.explore_rounded,
              label: l10n.coordinates,
              value:
                  '${proof.latitude!.toStringAsFixed(4)}°N, ${proof.longitude!.toStringAsFixed(4)}°E',
            ),
          _MetadataRow(
            icon: Icons.calendar_today_rounded,
            label: l10n.overlayDate,
            value: proof.overlayDateText,
          ),
          _MetadataRow(
            icon: Icons.access_time_rounded,
            label: l10n.overlayTime,
            value: proof.overlayTimeText,
          ),
          _MetadataRow(
            icon: Icons.source_rounded,
            label: l10n.source,
            value: l10n.sourceLocal,
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

class _MetadataRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool showDivider;

  const _MetadataRow({
    required this.icon,
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            children: [
              Icon(icon, size: 18, color: AppColors.textTertiary),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: AppTextStyles.bodySmall),
                    const SizedBox(height: 2),
                    Text(value, style: AppTextStyles.bodyLarge),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1),
      ],
    );
  }
}
