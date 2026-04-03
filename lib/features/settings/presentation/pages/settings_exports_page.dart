import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/di/providers.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/app_settings_repository.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_subpage_scaffold.dart';
import '../widgets/settings_tile.dart';

class SettingsExportsPage extends ConsumerWidget {
  const SettingsExportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final repo = ref.watch(appSettingsRepositoryProvider);

    return SettingsSubpageScaffold(
      title: l10n.settingsSectionExports,
      children: [
        SettingsSection(
          title: l10n.exportPdf,
          children: [
            SettingsTile(
              icon: Icons.open_in_new_rounded,
              title: l10n.settingsExportOpenPdfAfter,
              trailing: Switch.adaptive(
                value: repo.openPdfAfterGeneration,
                onChanged: (v) => ref
                    .read(appSettingsRepositoryProvider)
                    .setOpenPdfAfterGeneration(v),
                activeTrackColor: AppColors.primary,
              ),
            ),
            SettingsTile(
              icon: Icons.ios_share_rounded,
              title: l10n.settingsExportShareAfter,
              trailing: Switch.adaptive(
                value: repo.proposeShareAfterPdf,
                onChanged: (v) => ref
                    .read(appSettingsRepositoryProvider)
                    .setProposeShareAfterPdf(v),
                activeTrackColor: AppColors.primary,
              ),
            ),
            SettingsTile(
              icon: Icons.collections_rounded,
              title: l10n.settingsExportAllPhotosPdf,
              trailing: Switch.adaptive(
                value: repo.includeAllPhotosInPdf,
                onChanged: (v) => ref
                    .read(appSettingsRepositoryProvider)
                    .setIncludeAllPhotosInPdf(v),
                activeTrackColor: AppColors.primary,
              ),
            ),
            SettingsTile(
              icon: Icons.style_rounded,
              title: l10n.settingsReportStyle,
              trailing: DropdownButtonHideUnderline(
                child: DropdownButton<PdfReportStyleSetting>(
                  value: repo.pdfReportStyle,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      size: 16, color: AppColors.textTertiary),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: PdfReportStyleSetting.standard,
                      child: Text(l10n.settingsReportStyleStandard),
                    ),
                    DropdownMenuItem(
                      value: PdfReportStyleSetting.premium,
                      child: Text(l10n.settingsReportStylePremium),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      ref
                          .read(appSettingsRepositoryProvider)
                          .setPdfReportStyle(v);
                    }
                  },
                ),
              ),
            ),
            SettingsTile(
              icon: Icons.folder_copy_rounded,
              title: l10n.settingsGroupedReportAllowed,
              trailing: Switch.adaptive(
                value: repo.groupedReportAllowed,
                onChanged: (v) => ref
                    .read(appSettingsRepositoryProvider)
                    .setGroupedReportAllowed(v),
                activeTrackColor: AppColors.primary,
              ),
            ),
            SettingsTile(
              icon: Icons.sort_rounded,
              title: l10n.settingsExportSortOrder,
              trailing: DropdownButtonHideUnderline(
                child: DropdownButton<ExportSortOrderSetting>(
                  value: repo.exportDefaultSortOrder,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      size: 16, color: AppColors.textTertiary),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: ExportSortOrderSetting.newestFirst,
                      child: Text(l10n.sortNewestFirst),
                    ),
                    DropdownMenuItem(
                      value: ExportSortOrderSetting.oldestFirst,
                      child: Text(l10n.sortOldestFirst),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      ref
                          .read(appSettingsRepositoryProvider)
                          .setExportDefaultSortOrder(v);
                    }
                  },
                ),
              ),
            ),
            SettingsTile(
              icon: Icons.branding_watermark_rounded,
              title: l10n.settingsPdfBranding,
              trailing: Switch.adaptive(
                value: repo.pdfAppearancePreferences.showBranding,
                onChanged: (v) =>
                    ref.read(appSettingsRepositoryProvider).setPdfBrandingVisible(v),
                activeTrackColor: AppColors.primary,
              ),
            ),
            SettingsTile(
              icon: Icons.verified_rounded,
              title: l10n.settingsPdfCredibilityFooter,
              trailing: Switch.adaptive(
                value: repo.pdfAppearancePreferences.showCredibilityBlock,
                onChanged: (v) => ref
                    .read(appSettingsRepositoryProvider)
                    .setPdfCredibilityFooter(v),
                activeTrackColor: AppColors.primary,
              ),
            ),
            SettingsTile(
              icon: Icons.map_rounded,
              title: l10n.settingsPdfDetailedLocation,
              trailing: Switch.adaptive(
                value: repo.pdfAppearancePreferences.showDetailedLocation,
                onChanged: (v) => ref
                    .read(appSettingsRepositoryProvider)
                    .setPdfDetailedLocation(v),
                activeTrackColor: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
