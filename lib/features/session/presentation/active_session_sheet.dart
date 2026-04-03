import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_radius.dart';
import '../../../core/di/providers.dart';
import '../../../core/layout/app_content_layout.dart';
import '../../../l10n/app_localizations.dart';
import '../../clients/domain/site_mission.dart';

class ActiveSessionSheet extends ConsumerWidget {
  const ActiveSessionSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(activeSessionRepositoryProvider);
    final l10n = AppLocalizations.of(context);
    final mq = MediaQuery.of(context);

    return ListenableBuilder(
      listenable: repo as Listenable,
      builder: (context, _) {
        final session = repo.currentSession;

        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(
            AppContentLayout.horizontalMargin(context),
            AppSpacing.md,
            AppContentLayout.horizontalMargin(context),
            mq.padding.bottom + mq.viewInsets.bottom + AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                session != null ? l10n.activeSession : l10n.noActiveSession,
                style: AppTextStyles.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              if (session != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.cardPadding),
                  decoration: BoxDecoration(
                    color: session.client.color.withValues(alpha: 0.06),
                    borderRadius: AppRadius.lgAll,
                    border: Border.all(
                      color: session.client.color.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: session.client.color,
                          borderRadius: AppRadius.mdAll,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          session.client.initials,
                          style: AppTextStyles.titleSmall.copyWith(
                            color: AppColors.textOnPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.cardPadding),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              session.client.name,
                              style: AppTextStyles.titleSmall.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (session.client.company != null) ...[
                              const SizedBox(height: AppSpacing.xxs),
                              Text(
                                session.client.company!,
                                style: AppTextStyles.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.cardPadding,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: AppRadius.mdAll,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          session.site.name,
                          style: AppTextStyles.titleSmall.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _SiteTypeBadge(type: session.site.type),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.nextProofsWillUse,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.push(RoutePaths.contextPicker);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textOnPrimary,
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.mdAll,
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      l10n.changeContext,
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      ref
                          .read(activeSessionRepositoryProvider)
                          .endSession();
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: BorderSide(
                        color: AppColors.error.withValues(alpha: 0.25),
                      ),
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.mdAll,
                      ),
                    ),
                    child: Text(
                      l10n.endSession,
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                const Icon(
                  Icons.workspaces_outlined,
                  size: 48,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.sessionEmptyHint,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.push(RoutePaths.contextPicker);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textOnPrimary,
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.mdAll,
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      l10n.chooseContext,
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  l10n.close,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.textTertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SiteTypeBadge extends StatelessWidget {
  final SiteMissionType type;
  const _SiteTypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: AppRadius.smAll,
      ),
      child: Text(
        _label(type, l10n),
        style: AppTextStyles.badge.copyWith(
          color: AppColors.primary,
          fontSize: 10,
        ),
      ),
    );
  }

  String _label(SiteMissionType type, AppLocalizations l10n) => switch (type) {
        SiteMissionType.intervention => l10n.siteTypeIntervention,
        SiteMissionType.maintenance => l10n.siteTypeMaintenance,
        SiteMissionType.delivery => l10n.siteTypeDelivery,
        SiteMissionType.control => l10n.siteTypeControl,
        SiteMissionType.other => l10n.siteTypeOther,
      };
}
