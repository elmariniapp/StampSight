import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/di/providers.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../capture/data/capture_preferences_service.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_subpage_scaffold.dart';
import '../widgets/settings_tile.dart';

class SettingsMetadataPage extends ConsumerStatefulWidget {
  const SettingsMetadataPage({super.key});

  @override
  ConsumerState<SettingsMetadataPage> createState() =>
      _SettingsMetadataPageState();
}

class _SettingsMetadataPageState extends ConsumerState<SettingsMetadataPage> {
  final _capturePrefs = CapturePreferencesService();
  bool _loading = true;
  bool _d = true, _t = true, _a = true, _c = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final d = await _capturePrefs.getShowDate();
    final t = await _capturePrefs.getShowTime();
    final a = await _capturePrefs.getShowAddress();
    final c = await _capturePrefs.getShowCoordinates();
    if (!mounted) return;
    setState(() {
      _d = d;
      _t = t;
      _a = a;
      _c = c;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final repo = ref.watch(appSettingsRepositoryProvider);

    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    Widget sw({
      required IconData icon,
      required String title,
      required bool value,
      required Future<void> Function(bool) onChanged,
    }) {
      return SettingsTile(
        icon: icon,
        title: title,
        trailing: Switch.adaptive(
          value: value,
          onChanged: (v) async {
            await onChanged(v);
            if (mounted) await _load();
          },
          activeTrackColor: AppColors.primary,
        ),
      );
    }

    return SettingsSubpageScaffold(
      title: l10n.settingsSectionMetadata,
      subtitle: l10n.metadata,
      children: [
        SettingsSection(
          title: l10n.overlay,
          children: [
            sw(
              icon: Icons.calendar_today_rounded,
              title: l10n.date,
              value: _d,
              onChanged: (v) => _capturePrefs.setShowDate(v),
            ),
            sw(
              icon: Icons.access_time_rounded,
              title: l10n.time,
              value: _t,
              onChanged: (v) => _capturePrefs.setShowTime(v),
            ),
            sw(
              icon: Icons.location_on_rounded,
              title: l10n.address,
              value: _a,
              onChanged: (v) => _capturePrefs.setShowAddress(v),
            ),
            sw(
              icon: Icons.explore_rounded,
              title: l10n.gpsCoordinates,
              value: _c,
              onChanged: (v) => _capturePrefs.setShowCoordinates(v),
            ),
          ],
        ),
        SettingsSection(
          title: l10n.settingsSectionExports,
          children: [
            SettingsTile(
              icon: Icons.business_rounded,
              title: l10n.settingsIncludeClientExport,
              trailing: Switch.adaptive(
                value: repo.exportIncludeClient,
                onChanged: (v) => ref
                    .read(appSettingsRepositoryProvider)
                    .setExportIncludeClient(v),
                activeTrackColor: AppColors.primary,
              ),
            ),
            SettingsTile(
              icon: Icons.place_rounded,
              title: l10n.settingsIncludeSiteExport,
              trailing: Switch.adaptive(
                value: repo.exportIncludeSite,
                onChanged: (v) =>
                    ref.read(appSettingsRepositoryProvider).setExportIncludeSite(v),
                activeTrackColor: AppColors.primary,
              ),
            ),
            SettingsTile(
              icon: Icons.notes_rounded,
              title: l10n.settingsIncludeNoteExport,
              trailing: Switch.adaptive(
                value: repo.exportIncludeNote,
                onChanged: (v) =>
                    ref.read(appSettingsRepositoryProvider).setExportIncludeNote(v),
                activeTrackColor: AppColors.primary,
              ),
            ),
            SettingsTile(
              icon: Icons.auto_fix_high_rounded,
              title: l10n.settingsAutoNaming,
              trailing: Switch.adaptive(
                value: repo.autoProofNaming,
                onChanged: (v) =>
                    ref.read(appSettingsRepositoryProvider).setAutoProofNaming(v),
                activeTrackColor: AppColors.primary,
              ),
            ),
            SettingsTile(
              icon: Icons.tag_rounded,
              title: l10n.settingsAutoReference,
              trailing: Switch.adaptive(
                value: repo.autoProofReference,
                onChanged: (v) =>
                    ref.read(appSettingsRepositoryProvider).setAutoProofReference(v),
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
