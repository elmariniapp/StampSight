import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/pro_card.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_subpage_scaffold.dart';
import '../widgets/settings_tile.dart';

class SettingsProPage extends ConsumerWidget {
  const SettingsProPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return SettingsSubpageScaffold(
      title: l10n.settingsProPageTitle,
      subtitle: l10n.settingsProBenefits,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: ProCard(
            onTap: () => context.push(RoutePaths.paywall),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SettingsSection(
          title: l10n.settingsProCurrentPlan,
          children: [
            SettingsTile(
              icon: Icons.workspace_premium_rounded,
              title: l10n.paywallPlanFree,
              subtitle: l10n.paywallContinueFree,
            ),
            SettingsTile(
              icon: Icons.replay_rounded,
              title: l10n.settingsRestorePurchases,
              subtitle: l10n.settingsBadgeSoon,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.settingsBadgeSoon)),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
