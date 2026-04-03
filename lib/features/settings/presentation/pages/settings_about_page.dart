import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_subpage_scaffold.dart';
import '../widgets/settings_tile.dart';

class SettingsAboutPage extends ConsumerStatefulWidget {
  const SettingsAboutPage({super.key});

  @override
  ConsumerState<SettingsAboutPage> createState() => _SettingsAboutPageState();
}

class _SettingsAboutPageState extends ConsumerState<SettingsAboutPage> {
  PackageInfo? _info;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((i) {
      if (mounted) setState(() => _info = i);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final build = _info?.buildNumber ?? '—';
    final ver = _info?.version ?? AppConstants.appVersion;

    return SettingsSubpageScaffold(
      title: l10n.settingsSectionAbout,
      children: [
        SettingsSection(
          title: l10n.about,
          children: [
            SettingsTile(
              icon: Icons.apps_rounded,
              title: AppConstants.appName,
              subtitle: l10n.appTagline,
            ),
            SettingsTile(
              icon: Icons.info_outline_rounded,
              title: l10n.versionLabel(ver),
            ),
            SettingsTile(
              icon: Icons.build_rounded,
              title: '${l10n.settingsAboutBuild} $build',
            ),
            SettingsTile(
              icon: Icons.code_rounded,
              title: l10n.settingsOpenSource,
              subtitle: l10n.settingsLegalPlaceholder,
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
