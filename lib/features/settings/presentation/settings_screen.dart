import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/layout/app_content_layout.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../l10n/app_localizations.dart';
import 'widgets/pro_card.dart';
import 'widgets/settings_section.dart';
import 'widgets/settings_tile.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final h = AppContentLayout.horizontalMargin(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: h),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverAppBar.large(
                pinned: true,
                stretch: true,
                backgroundColor: AppColors.background,
                surfaceTintColor: Colors.transparent,
                title: Text(
                  l10n.settingsTitle,
                  style: AppTextStyles.displayMedium,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.screenPadding,
                          0,
                          AppSpacing.screenPadding,
                          AppSpacing.md,
                        ),
                        child: Text(
                          l10n.settingsHubSubtitle,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.screenPadding,
                          0,
                          AppSpacing.screenPadding,
                          AppSpacing.md,
                        ),
                        child: ProCard(
                          onTap: () => context.push(RoutePaths.paywall),
                        ),
                      ),
                      SettingsSection(
                        title: l10n.settingsSectionGeneral,
                        children: [
                          SettingsTile(
                            icon: Icons.tune_rounded,
                            title: l10n.settingsSectionGeneral,
                            onTap: () => context.push(RoutePaths.settingsGeneral),
                          ),
                        ],
                      ),
                      SettingsSection(
                        title: l10n.settingsSectionCapture,
                        children: [
                          SettingsTile(
                            icon: Icons.photo_camera_rounded,
                            title: l10n.settingsSectionCapture,
                            onTap: () =>
                                context.push(RoutePaths.settingsCapture),
                          ),
                        ],
                      ),
                      SettingsSection(
                        title: l10n.settingsSectionMetadata,
                        children: [
                          SettingsTile(
                            icon: Icons.data_object_rounded,
                            title: l10n.settingsSectionMetadata,
                            onTap: () =>
                                context.push(RoutePaths.settingsMetadata),
                          ),
                        ],
                      ),
                      SettingsSection(
                        title: l10n.settingsSectionExports,
                        children: [
                          SettingsTile(
                            icon: Icons.picture_as_pdf_rounded,
                            title: l10n.settingsSectionExports,
                            onTap: () =>
                                context.push(RoutePaths.settingsExports),
                          ),
                        ],
                      ),
                      SettingsSection(
                        title: l10n.settingsSectionClientsSession,
                        children: [
                          SettingsTile(
                            icon: Icons.groups_rounded,
                            title: l10n.settingsSectionClientsSession,
                            onTap: () =>
                                context.push(RoutePaths.settingsSession),
                          ),
                        ],
                      ),
                      SettingsSection(
                        title: l10n.settingsSectionStorage,
                        children: [
                          SettingsTile(
                            icon: Icons.storage_rounded,
                            title: l10n.settingsSectionStorage,
                            onTap: () =>
                                context.push(RoutePaths.settingsStorage),
                          ),
                        ],
                      ),
                      SettingsSection(
                        title: l10n.settingsSectionPermissions,
                        children: [
                          SettingsTile(
                            icon: Icons.privacy_tip_outlined,
                            title: l10n.settingsSectionPermissions,
                            onTap: () =>
                                context.push(RoutePaths.settingsPermissions),
                          ),
                        ],
                      ),
                      SettingsSection(
                        title: l10n.settingsSectionPro,
                        children: [
                          SettingsTile(
                            icon: Icons.workspace_premium_rounded,
                            title: l10n.settingsSectionPro,
                            onTap: () => context.push(RoutePaths.settingsPro),
                          ),
                        ],
                      ),
                      SettingsSection(
                        title: l10n.settingsSectionHelpLegal,
                        children: [
                          SettingsTile(
                            icon: Icons.help_outline_rounded,
                            title: l10n.settingsSectionHelpLegal,
                            onTap: () => context.push(RoutePaths.settingsHelp),
                          ),
                        ],
                      ),
                      SettingsSection(
                        title: l10n.settingsSectionAbout,
                        children: [
                          SettingsTile(
                            icon: Icons.info_outline_rounded,
                            title: l10n.settingsSectionAbout,
                            onTap: () => context.push(RoutePaths.settingsAbout),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(
        currentTab: AppBottomNavTab.settings,
      ),
    );
  }
}
