import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_subpage_scaffold.dart';
import '../widgets/settings_tile.dart';

class SettingsPermissionsPage extends ConsumerWidget {
  const SettingsPermissionsPage({super.key});

  static Future<PermissionStatus> _photosStatus() async {
    if (Platform.isIOS) return Permission.photos.status;
    if (Platform.isAndroid) {
      final p = await Permission.photos.status;
      if (p.isGranted || p.isLimited || p.isDenied) return p;
      return Permission.storage.status;
    }
    return Future.value(PermissionStatus.granted);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    String label(AppLocalizations l10n, PermissionStatus s) {
      if (s.isGranted) return l10n.settingsPermissionGranted;
      if (s.isLimited) return l10n.settingsPermissionLimited;
      if (s.isDenied || s.isPermanentlyDenied) {
        return l10n.settingsPermissionDenied;
      }
      return l10n.settingsStorageUnavailable;
    }

    return SettingsSubpageScaffold(
      title: l10n.settingsSectionPermissions,
      children: [
        FutureBuilder<List<PermissionStatus>>(
          future: Future.wait([
            Permission.camera.status,
            Permission.locationWhenInUse.status,
            _photosStatus(),
          ]),
          builder: (context, snap) {
            if (!snap.hasData) {
              return const Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final cam = snap.data![0];
            final loc = snap.data![1];
            final photos = snap.data![2];

            return SettingsSection(
              title: l10n.settingsSectionPermissions,
              children: [
                SettingsTile(
                  icon: Icons.photo_camera_rounded,
                  title: l10n.settingsPermissionCamera,
                  subtitle: label(l10n, cam),
                  onTap: () => openAppSettings(),
                ),
                SettingsTile(
                  icon: Icons.location_on_rounded,
                  title: l10n.settingsPermissionLocation,
                  subtitle: label(l10n, loc),
                  onTap: () => openAppSettings(),
                ),
                SettingsTile(
                  icon: Icons.photo_library_rounded,
                  title: l10n.settingsPermissionPhotos,
                  subtitle: label(l10n, photos),
                  onTap: () => openAppSettings(),
                ),
                SettingsTile(
                  icon: Icons.settings_rounded,
                  title: l10n.settingsOpenAppSettings,
                  onTap: () => openAppSettings(),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
