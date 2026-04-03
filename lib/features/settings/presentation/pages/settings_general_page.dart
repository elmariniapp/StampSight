import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/di/providers.dart';
import '../../../../l10n/app_locale.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/app_settings_repository.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_subpage_scaffold.dart';
import '../widgets/settings_tile.dart';

class SettingsGeneralPage extends ConsumerStatefulWidget {
  const SettingsGeneralPage({super.key});

  @override
  ConsumerState<SettingsGeneralPage> createState() =>
      _SettingsGeneralPageState();
}

class _SettingsGeneralPageState extends ConsumerState<SettingsGeneralPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final repo = ref.watch(appSettingsRepositoryProvider);
    final currentLanguage = AppLocale.instance.locale.languageCode;

    Future<void> updateLanguage(String code) async {
      await AppLocale.instance.setLocaleCode(code);
      if (mounted) setState(() {});
    }

    return SettingsSubpageScaffold(
      title: l10n.settingsSectionGeneral,
      subtitle: l10n.settingsRegionalPreferences,
      children: [
        SettingsSection(
          title: l10n.language,
          children: [
            SettingsTile(
              icon: Icons.translate_rounded,
              title: l10n.language,
              trailing: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => updateLanguage('fr'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: currentLanguage == 'fr'
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          l10n.french,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: currentLanguage == 'fr'
                                ? AppColors.textOnPrimary
                                : AppColors.textTertiary,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => updateLanguage('en'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: currentLanguage == 'en'
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          l10n.english,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: currentLanguage == 'en'
                                ? AppColors.textOnPrimary
                                : AppColors.textTertiary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SettingsSection(
          title: l10n.formats,
          children: [
            SettingsTile(
              icon: Icons.date_range_rounded,
              title: l10n.dateFormat,
              trailing: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: repo.dateFormat,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      size: 16, color: AppColors.textTertiary),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'dd/MM/yyyy',
                      child: Text(l10n.dateFormatEuropean),
                    ),
                    DropdownMenuItem(
                      value: 'MM/dd/yyyy',
                      child: Text(l10n.dateFormatUs),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      ref.read(appSettingsRepositoryProvider).setDateFormat(v);
                    }
                  },
                ),
              ),
            ),
            SettingsTile(
              icon: Icons.schedule_rounded,
              title: l10n.timeFormat,
              trailing: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: repo.timeFormat == 'h:mm a' ? 'h:mm a' : 'HH:mm',
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      size: 16, color: AppColors.textTertiary),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'HH:mm',
                      child: Text(l10n.timeFormat24h),
                    ),
                    DropdownMenuItem(
                      value: 'h:mm a',
                      child: Text(l10n.timeFormat12h),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      ref.read(appSettingsRepositoryProvider).setTimeFormat(v);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        SettingsSection(
          title: l10n.settingsTimezoneMode,
          children: [
            SettingsTile(
              icon: Icons.public_rounded,
              title: l10n.settingsTimezoneMode,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (repo.timeZoneMode == TimeZoneModeSetting.manual)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Chip(
                        label: Text(
                          l10n.settingsBadgeSoon,
                          style: const TextStyle(fontSize: 10),
                        ),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<TimeZoneModeSetting>(
                      value: repo.timeZoneMode,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded,
                          size: 16, color: AppColors.textTertiary),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: TimeZoneModeSetting.automatic,
                          child: Text(l10n.settingsTimezoneAutomatic),
                        ),
                        DropdownMenuItem(
                          value: TimeZoneModeSetting.manual,
                          child: Text(l10n.settingsTimezoneManual),
                        ),
                      ],
                      onChanged: (v) {
                        if (v != null) {
                          ref
                              .read(appSettingsRepositoryProvider)
                              .setTimeZoneMode(v);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
