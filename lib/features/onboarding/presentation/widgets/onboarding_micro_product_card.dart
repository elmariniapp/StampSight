import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';

/// Aperçu produit sobre pour la zone basse des slides d’onboarding.
enum OnboardingMicroCardKind { proofStructured, contextOrganized, deliverablePro }

class OnboardingMicroProductCard extends StatelessWidget {
  const OnboardingMicroProductCard({
    super.key,
    required this.kind,
    required this.isWide,
    required this.maxWidth,
  });

  final OnboardingMicroCardKind kind;
  final bool isWide;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final headline = _headlineFor(l10n);
    final rows = _rowsFor(l10n);
    final badge = _badgeFor(l10n);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth.clamp(0, 400)),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.lgAll,
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.085),
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            isWide ? 16 : 14,
            isWide ? 14 : 12,
            isWide ? 16 : 14,
            isWide ? 12 : 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 2,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  SizedBox(width: isWide ? 9 : 8),
                  Expanded(
                    child: Text(
                      headline,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: isWide ? 11 : 10.5,
                        letterSpacing: 0.04,
                        height: 1.22,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: isWide ? 11 : 10),
              for (var i = 0; i < rows.length; i++) ...[
                if (i > 0) SizedBox(height: isWide ? 8 : 7),
                _MicroRow(
                  label: rows[i].label,
                  value: rows[i].value,
                  isWide: isWide,
                ),
              ],
              SizedBox(height: isWide ? 10 : 9),
              Row(
                children: [
                  Container(
                    width: 3.5,
                    height: 3.5,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      badge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textSecondary.withValues(alpha: 0.94),
                        fontWeight: FontWeight.w500,
                        fontSize: isWide ? 10.5 : 10,
                        letterSpacing: 0.03,
                        height: 1.22,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _headlineFor(AppLocalizations l10n) => switch (kind) {
        OnboardingMicroCardKind.proofStructured =>
          l10n.onboardingMicroProofHeadline,
        OnboardingMicroCardKind.contextOrganized =>
          l10n.onboardingMicroContextHeadline,
        OnboardingMicroCardKind.deliverablePro =>
          l10n.onboardingMicroDeliverHeadline,
      };

  String _badgeFor(AppLocalizations l10n) => switch (kind) {
        OnboardingMicroCardKind.proofStructured =>
          l10n.onboardingMicroProofBadge,
        OnboardingMicroCardKind.contextOrganized =>
          l10n.onboardingMicroContextBadge,
        OnboardingMicroCardKind.deliverablePro =>
          l10n.onboardingMicroDeliverBadge,
      };

  List<({String label, String value})> _rowsFor(AppLocalizations l10n) {
    return switch (kind) {
      OnboardingMicroCardKind.proofStructured => [
        (
          label: l10n.onboardingMicroProofRow1Label,
          value: l10n.onboardingMicroProofRow1Value,
        ),
        (
          label: l10n.onboardingMicroProofRow2Label,
          value: l10n.onboardingMicroProofRow2Value,
        ),
        (
          label: l10n.onboardingMicroProofRow3Label,
          value: l10n.onboardingMicroProofRow3Value,
        ),
      ],
      OnboardingMicroCardKind.contextOrganized => [
        (
          label: l10n.onboardingMicroContextRow1Label,
          value: l10n.onboardingMicroContextRow1Value,
        ),
        (
          label: l10n.onboardingMicroContextRow2Label,
          value: l10n.onboardingMicroContextRow2Value,
        ),
        (
          label: l10n.onboardingMicroContextRow3Label,
          value: l10n.onboardingMicroContextRow3Value,
        ),
      ],
      OnboardingMicroCardKind.deliverablePro => [
        (
          label: l10n.onboardingMicroDeliverRow1Label,
          value: l10n.onboardingMicroDeliverRow1Value,
        ),
        (
          label: l10n.onboardingMicroDeliverRow2Label,
          value: l10n.onboardingMicroDeliverRow2Value,
        ),
        (
          label: l10n.onboardingMicroDeliverRow3Label,
          value: l10n.onboardingMicroDeliverRow3Value,
        ),
      ],
    };
  }
}

class _MicroRow extends StatelessWidget {
  const _MicroRow({
    required this.label,
    required this.value,
    required this.isWide,
  });

  final String label;
  final String value;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final labelStyle = AppTextStyles.labelSmall.copyWith(
      color: AppColors.textTertiary.withValues(alpha: 0.93),
      fontWeight: FontWeight.w500,
      fontSize: isWide ? 10.5 : 10,
      letterSpacing: 0.05,
      height: 1.24,
    );
    final valueStyle = AppTextStyles.bodySmall.copyWith(
      color: AppColors.textPrimary.withValues(alpha: 0.93),
      fontWeight: FontWeight.w500,
      fontSize: isWide ? 12.5 : 12,
      letterSpacing: -0.1,
      height: 1.24,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 44,
          child: Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: labelStyle,
          ),
        ),
        SizedBox(width: isWide ? 11 : 9),
        Expanded(
          flex: 56,
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: valueStyle,
          ),
        ),
      ],
    );
  }
}
