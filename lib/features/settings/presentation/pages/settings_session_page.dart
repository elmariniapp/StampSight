import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/di/providers.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/app_settings_repository.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_subpage_scaffold.dart';
import '../widgets/settings_tile.dart';

class SettingsSessionPage extends ConsumerWidget {
  const SettingsSessionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final repo = ref.watch(appSettingsRepositoryProvider);

    return SettingsSubpageScaffold(
      title: l10n.settingsSectionClientsSession,
      children: [
        SettingsSection(
          title: l10n.activeSession,
          children: [
            SettingsTile(
              icon: Icons.restore_rounded,
              title: l10n.settingsRestoreSession,
              trailing: Switch.adaptive(
                value: repo.restoreLastSession,
                onChanged: (v) =>
                    ref.read(appSettingsRepositoryProvider).setRestoreLastSession(v),
                activeTrackColor: AppColors.primary,
              ),
            ),
            SettingsTile(
              icon: Icons.swap_horiz_rounded,
              title: l10n.settingsConfirmSessionChange,
              subtitle: l10n.settingsPreparedNotice,
              trailing: Switch.adaptive(
                value: repo.confirmBeforeSessionChange,
                onChanged: (v) => ref
                    .read(appSettingsRepositoryProvider)
                    .setConfirmBeforeSessionChange(v),
                activeTrackColor: AppColors.primary,
              ),
            ),
            SettingsTile(
              icon: Icons.person_off_rounded,
              title: l10n.settingsConfirmClientDelete,
              trailing: Switch.adaptive(
                value: repo.confirmBeforeClientDelete,
                onChanged: (v) => ref
                    .read(appSettingsRepositoryProvider)
                    .setConfirmBeforeClientDelete(v),
                activeTrackColor: AppColors.primary,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: AppSpacing.sm,
          ),
          child: Text(
            l10n.settingsClientDeletePolicy.toUpperCase(),
            style: AppTextStyles.labelSmall.copyWith(letterSpacing: 0.5),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: Text(
            l10n.settingsPolicyPrepared,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SettingsSection(
          title: l10n.settingsClientDeletePolicy,
          children: [
            SettingsTile(
              icon: Icons.policy_rounded,
              title: l10n.settingsClientDeletePolicy,
              trailing: DropdownButtonHideUnderline(
                child: DropdownButton<ClientDeletePolicySetting>(
                  value: repo.clientDeletePolicy,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      size: 16, color: AppColors.textTertiary),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: ClientDeletePolicySetting.block,
                      child: Text(l10n.settingsPolicyBlock),
                    ),
                    DropdownMenuItem(
                      value: ClientDeletePolicySetting.detachProofs,
                      child: Text(l10n.settingsPolicyDetach),
                    ),
                    DropdownMenuItem(
                      value: ClientDeletePolicySetting.deleteLinkedSites,
                      child: Text(l10n.settingsPolicyCascade),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      ref
                          .read(appSettingsRepositoryProvider)
                          .setClientDeletePolicy(v);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
