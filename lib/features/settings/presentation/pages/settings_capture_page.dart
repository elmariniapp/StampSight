import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/di/providers.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/app_settings_repository.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_subpage_scaffold.dart';
import '../widgets/settings_tile.dart';

class SettingsCapturePage extends ConsumerWidget {
  const SettingsCapturePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final repo = ref.watch(appSettingsRepositoryProvider);

    Widget switchTile({
      required IconData icon,
      required String title,
      required bool value,
      required ValueChanged<bool> onChanged,
      String? subtitle,
    }) {
      return SettingsTile(
        icon: icon,
        title: title,
        subtitle: subtitle,
        trailing: Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeTrackColor: AppColors.primary,
        ),
      );
    }

    return SettingsSubpageScaffold(
      title: l10n.settingsSectionCapture,
      children: [
        SettingsSection(
          title: l10n.settingsPhotoQuality,
          children: [
            SettingsTile(
              icon: Icons.hd_rounded,
              title: l10n.settingsPhotoQuality,
              trailing: DropdownButtonHideUnderline(
                child: DropdownButton<PhotoQualitySetting>(
                  value: repo.photoQuality,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      size: 16, color: AppColors.textTertiary),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: PhotoQualitySetting.standard,
                      child: Text(l10n.settingsPhotoQualityStandard),
                    ),
                    DropdownMenuItem(
                      value: PhotoQualitySetting.high,
                      child: Text(l10n.settingsPhotoQualityHigh),
                    ),
                    DropdownMenuItem(
                      value: PhotoQualitySetting.max,
                      child: Text(l10n.settingsPhotoQualityMax),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      ref.read(appSettingsRepositoryProvider).setPhotoQuality(v);
                    }
                  },
                ),
              ),
            ),
            SettingsTile(
              icon: Icons.compress_rounded,
              title: l10n.settingsImageCompression,
              trailing: DropdownButtonHideUnderline(
                child: DropdownButton<ImageCompressionSetting>(
                  value: repo.imageCompression,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      size: 16, color: AppColors.textTertiary),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: ImageCompressionSetting.low,
                      child: Text(l10n.settingsCompressionLow),
                    ),
                    DropdownMenuItem(
                      value: ImageCompressionSetting.medium,
                      child: Text(l10n.settingsCompressionMedium),
                    ),
                    DropdownMenuItem(
                      value: ImageCompressionSetting.high,
                      child: Text(l10n.settingsCompressionHigh),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      ref
                          .read(appSettingsRepositoryProvider)
                          .setImageCompression(v);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        SettingsSection(
          title: l10n.newProof,
          children: [
            switchTile(
              icon: Icons.photo_camera_rounded,
              title: l10n.settingsOpenCameraDirect,
              value: repo.openCameraDirectlyFromNewProof,
              onChanged: (v) => ref
                  .read(appSettingsRepositoryProvider)
                  .setOpenCameraDirectlyFromNewProof(v),
            ),
            switchTile(
              icon: Icons.grid_on_rounded,
              title: l10n.settingsCameraGrid,
              subtitle: l10n.settingsCameraGridHint,
              value: repo.cameraGridEnabled,
              onChanged: (v) =>
                  ref.read(appSettingsRepositoryProvider).setCameraGridEnabled(v),
            ),
            switchTile(
              icon: Icons.photo_library_rounded,
              title: l10n.settingsMultiPhotoPrompt,
              subtitle: l10n.settingsPreparedNotice,
              value: repo.multiPhotoPromptEnabled,
              onChanged: (v) => ref
                  .read(appSettingsRepositoryProvider)
                  .setMultiPhotoPromptEnabled(v),
            ),
            switchTile(
              icon: Icons.bookmark_rounded,
              title: l10n.settingsPersistCaptureChoices,
              value: repo.persistCaptureChoices,
              onChanged: (v) => ref
                  .read(appSettingsRepositoryProvider)
                  .setPersistCaptureChoices(v),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
