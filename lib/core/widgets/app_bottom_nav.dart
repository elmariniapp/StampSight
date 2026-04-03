import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/route_names.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_shadows.dart';
import '../../app/theme/app_text_styles.dart';
import '../../l10n/app_localizations.dart';

enum AppBottomNavTab {
  home,
  library,
  clients,
  settings,
}

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentTab,
  });

  final AppBottomNavTab currentTab;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.xlAll,
          border: Border.all(color: AppColors.border),
          boxShadow: AppShadows.lg,
        ),
        child: Row(
          children: [
            Expanded(
              child: _NavItem(
                label: l10n.homeTitle,
                icon: Icons.home_rounded,
                selected: currentTab == AppBottomNavTab.home,
                onTap: () => context.go(RoutePaths.home),
              ),
            ),
            Expanded(
              child: _NavItem(
                label: l10n.myProofsTitle,
                icon: Icons.grid_view_rounded,
                selected: currentTab == AppBottomNavTab.library,
                onTap: () => context.go(RoutePaths.library),
              ),
            ),
            // Bouton capture central
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: _CaptureButton(
                onTap: () => context.push(RoutePaths.capture),
              ),
            ),
            Expanded(
              child: _NavItem(
                label: l10n.clientsTitle,
                icon: Icons.people_rounded,
                selected: currentTab == AppBottomNavTab.clients,
                onTap: () => context.go(RoutePaths.clients),
              ),
            ),
            Expanded(
              child: _NavItem(
                label: l10n.settingsTitle,
                icon: Icons.settings_rounded,
                selected: currentTab == AppBottomNavTab.settings,
                onTap: () => context.go(RoutePaths.settings),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColors.primary;
    final inactiveColor = AppColors.textTertiary;

    return InkWell(
      borderRadius: AppRadius.lgAll,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? activeColor.withValues(alpha: 0.09)
                    : Colors.transparent,
                borderRadius: AppRadius.smAll,
              ),
              child: Icon(
                icon,
                size: 20,
                color: selected ? activeColor : inactiveColor,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTextStyles.labelSmall.copyWith(
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  color: selected ? activeColor : inactiveColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CaptureButton extends StatelessWidget {
  final VoidCallback onTap;
  const _CaptureButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.lgAll,
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: AppRadius.lgAll,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.28),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.camera_alt_rounded,
          color: AppColors.textOnPrimary,
          size: 21,
        ),
      ),
    );
  }
}
