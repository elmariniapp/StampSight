import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/local_storage_inspector.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_subpage_scaffold.dart';
import '../widgets/settings_tile.dart';

class SettingsStoragePage extends ConsumerStatefulWidget {
  const SettingsStoragePage({super.key});

  @override
  ConsumerState<SettingsStoragePage> createState() =>
      _SettingsStoragePageState();
}

class _SettingsStoragePageState extends ConsumerState<SettingsStoragePage> {
  bool _busy = false;

  String _fmt(int bytes) {
    if (bytes < 1024) return '$bytes o';
    final kb = bytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)} Ko';
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(1)} Mo';
  }

  Future<void> _reload() async {
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _confirmAnd(
    BuildContext context, {
    required String title,
    required String body,
    required Future<void> Function() action,
  }) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.settingsConfirmAction),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() => _busy = true);
    try {
      await action();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsDone)),
      );
    } catch (e, st) {
      debugPrint('StampSight: settings storage action failed: $e\n$st');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settingsStorageActionFailed)),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
      await _reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SettingsSubpageScaffold(
      title: l10n.settingsSectionStorage,
      children: [
        if (_busy)
          const Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: LinearProgressIndicator(),
          ),
        FutureBuilder<List<int>>(
          future: Future.wait([
            LocalStorageInspector.proofsDataBytes(),
            LocalStorageInspector.exportsSavedBytes(),
            LocalStorageInspector.cacheEstimateBytes(),
            LocalStorageInspector.tempStampsightPdfBytes(),
          ]),
          builder: (context, snap) {
            if (!snap.hasData) {
              return Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(l10n.settingsStorageCalculating),
              );
            }
            final proofs = snap.data![0];
            final exports = snap.data![1];
            final cache = snap.data![2];
            final tempPdf = snap.data![3];
            return SettingsSection(
              title: l10n.settingsStorageOverview,
              children: [
                SettingsTile(
                  icon: Icons.folder_rounded,
                  title: l10n.settingsStorageLocalData,
                  subtitle: _fmt(proofs),
                ),
                SettingsTile(
                  icon: Icons.picture_as_pdf_rounded,
                  title: l10n.settingsStoragePdfExports,
                  subtitle: _fmt(exports),
                ),
                SettingsTile(
                  icon: Icons.layers_rounded,
                  title: l10n.settingsStorageCache,
                  subtitle: _fmt(cache),
                ),
                SettingsTile(
                  icon: Icons.insert_drive_file_rounded,
                  title: l10n.settingsStorageTemp,
                  subtitle: _fmt(tempPdf),
                ),
              ],
            );
          },
        ),
        SettingsSection(
          title: l10n.settingsClearCache,
          children: [
            SettingsTile(
              icon: Icons.cleaning_services_rounded,
              title: l10n.settingsClearCache,
              onTap: _busy
                  ? null
                  : () => _confirmAnd(
                        context,
                        title: l10n.settingsClearCache,
                        body: l10n.settingsConfirmAction,
                        action: LocalStorageInspector.clearAppTempCacheBestEffort,
                      ),
            ),
            SettingsTile(
              icon: Icons.delete_forever_rounded,
              title: l10n.settingsDeleteTempExports,
              onTap: _busy
                  ? null
                  : () => _confirmAnd(
                        context,
                        title: l10n.settingsDeleteTempExports,
                        body: l10n.settingsConfirmAction,
                        action: () async {
                          await LocalStorageInspector.deleteTempStampsightPdfs();
                        },
                      ),
            ),
            SettingsTile(
              icon: Icons.auto_fix_high_rounded,
              title: l10n.settingsOptimizeStorage,
              onTap: _busy
                  ? null
                  : () => _confirmAnd(
                        context,
                        title: l10n.settingsOptimizeStorage,
                        body: l10n.settingsConfirmAction,
                        action: () async {
                          await LocalStorageInspector.deleteTempStampsightPdfs();
                          await LocalStorageInspector.clearAppTempCacheBestEffort();
                        },
                      ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Text(
            l10n.settingsPreparedNotice,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
