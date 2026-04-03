import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

class HomeQuickActions extends StatelessWidget {
  final VoidCallback onActionTap;

  const HomeQuickActions({
    super.key,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: Text(
            l10n.captureProof,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: Row(
            children: [
              Expanded(
                child: _ActionCard(
                  title: l10n.proofTypeInspection,
                  icon: Icons.search_rounded,
                  barColor: AppColors.categoryInspection,
                  iconBgColor: AppColors.surfaceVariant,
                  iconColor: AppColors.categoryInspection,
                  meta: l10n.detail,
                  onTap: onActionTap,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: _ActionCard(
                  title: l10n.proofTypeDelivery,
                  icon: Icons.local_shipping_rounded,
                  barColor: AppColors.categoryDelivery,
                  iconBgColor: const Color(0xFFFFFBEB),
                  iconColor: AppColors.categoryDelivery,
                  meta: l10n.captureTitle,
                  onTap: onActionTap,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 7),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: Row(
            children: [
              Expanded(
                child: _ActionCard(
                  title: l10n.proofTypeIncident,
                  icon: Icons.warning_rounded,
                  barColor: AppColors.categoryIncident,
                  iconBgColor: const Color(0xFFFEF2F2),
                  iconColor: AppColors.categoryIncident,
                  meta: l10n.overlay,
                  onTap: onActionTap,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: _ActionCard(
                  title: l10n.proofTypeOther,
                  icon: Icons.photo_camera_rounded,
                  barColor: AppColors.categoryOther,
                  iconBgColor: AppColors.background,
                  iconColor: AppColors.categoryOther,
                  meta: l10n.sourceLocal,
                  onTap: onActionTap,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color barColor;
  final Color iconBgColor;
  final Color iconColor;
  final String meta;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.icon,
    required this.barColor,
    required this.iconBgColor,
    required this.iconColor,
    required this.meta,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: AppColors.border),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 4,
                  color: barColor,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: iconBgColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(icon, color: iconColor, size: 16),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          meta,
                          style: const TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
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
      ),
    );
  }
}
