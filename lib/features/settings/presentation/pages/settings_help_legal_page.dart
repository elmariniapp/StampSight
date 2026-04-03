import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/routes/route_names.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_subpage_scaffold.dart';
import '../widgets/settings_tile.dart';

const String _urlTermsOfUse =
    'https://elmariniapp.github.io/StampSight/TERMS_OF_USE';
const String _urlPrivacyPolicy =
    'https://elmariniapp.github.io/StampSight/PRIVACY_POLICY';
const String _urlLegalNotice =
    'https://elmariniapp.github.io/StampSight/LEGAL_NOTICE';

/// Destinataire des mails « Support » / « Bug report » (mailto).
const String _supportMailRecipient = 'support@elmariniapp.com';

class SettingsHelpLegalPage extends ConsumerWidget {
  const SettingsHelpLegalPage({super.key});

  /// Ouvre le client mail / sélecteur d’apps. Ne pas utiliser [canLaunchUrl]
  /// comme précondition : sur Android 11+, sans `<queries>` mailto ou avec
  /// package visibility, [canLaunchUrl] peut être faux alors que [launchUrl] réussit.
  Future<void> _launchMail(
    BuildContext context, {
    required String subject,
    required String body,
  }) async {
    final l10n = AppLocalizations.of(context);
    final uri = Uri(
      scheme: 'mailto',
      path: _supportMailRecipient,
      queryParameters: <String, String>{
        'subject': subject,
        'body': body,
      },
    );
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.platformDefault,
      );
      if (!launched && context.mounted) {
        await Clipboard.setData(
          ClipboardData(text: _supportMailRecipient),
        );
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$_supportMailRecipient\n${l10n.supportEmailCopied}',
            ),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        await Clipboard.setData(
          ClipboardData(text: _supportMailRecipient),
        );
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$_supportMailRecipient\n${l10n.supportEmailCopied}',
            ),
          ),
        );
      }
    }
  }

  Future<void> _mailtoSupport(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    await _launchMail(
      context,
      subject: 'StampSight — Support',
      body: l10n.supportMailBody,
    );
  }

  Future<void> _mailtoBugReport(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final info = await PackageInfo.fromPlatform();
    if (!context.mounted) return;
    final osLine =
        '${Platform.operatingSystem} ${Platform.operatingSystemVersion}';
    final body = l10n.bugReportMailBody(
      info.version,
      info.buildNumber,
      osLine,
    );
    await _launchMail(
      context,
      subject: 'StampSight — Bug Report',
      body: body,
    );
  }

  /// Ouvre une URL https ; évite [canLaunchUrl] comme précondition (souvent faux pour https sur Android 11+).
  Future<void> _openExternalUrl(BuildContext context, String urlString) async {
    final uri = Uri.parse(urlString);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.platformDefault,
      );
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(urlString)),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(urlString)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return SettingsSubpageScaffold(
      title: l10n.settingsSectionHelpLegal,
      children: [
        SettingsSection(
          title: l10n.settingsFaq,
          children: [
            SettingsTile(
              icon: Icons.help_outline_rounded,
              title: l10n.settingsFaq,
              onTap: () => context.push(RoutePaths.settingsLegalKind('faq')),
            ),
          ],
        ),
        SettingsSection(
          title: l10n.settingsContactSupport,
          children: [
            SettingsTile(
              icon: Icons.support_agent_rounded,
              title: l10n.settingsContactSupport,
              subtitle: l10n.settingsContactSupportSubtitle,
              onTap: () => _mailtoSupport(context),
            ),
            SettingsTile(
              icon: Icons.bug_report_outlined,
              title: l10n.settingsReportBug,
              subtitle: l10n.settingsReportBugSubtitle,
              onTap: () => _mailtoBugReport(context),
            ),
          ],
        ),
        SettingsSection(
          title: l10n.settingsSectionHelpLegal,
          children: [
            SettingsTile(
              icon: Icons.description_outlined,
              title: l10n.termsOfService,
              onTap: () => _openExternalUrl(context, _urlTermsOfUse),
            ),
            SettingsTile(
              icon: Icons.shield_outlined,
              title: l10n.privacyPolicy,
              onTap: () => _openExternalUrl(context, _urlPrivacyPolicy),
            ),
            SettingsTile(
              icon: Icons.balance_outlined,
              title: l10n.legalNotice,
              onTap: () => _openExternalUrl(context, _urlLegalNotice),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
