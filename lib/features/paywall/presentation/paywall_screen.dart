import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/constants/paywall_assets.dart';
import '../../../core/layout/app_content_layout.dart';
import '../../../l10n/app_localizations.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hPad = AppContentLayout.horizontalMargin(context);
    final bottom = AppContentLayout.scrollBottomInset(context);
    final screenH = MediaQuery.sizeOf(context).height;
    final heroHeight = math.min(300.0, screenH * 0.32);
    final isWide =
        MediaQuery.sizeOf(context).width >= AppContentLayout.tabletBreakpoint;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: AppColors.textSecondary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.paywallHeadline,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(hPad, 8, hPad, bottom),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: math.min(
                        AppContentLayout.maxContentWidth,
                        560,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: AppRadius.lgAll,
                          child: SizedBox(
                            width: double.infinity,
                            height: heroHeight,
                            child: Image.asset(
                              PaywallImageAssets.heroDeliveryDamage,
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                        SizedBox(height: isWide ? 12 : 8),
                        Text(
                          l10n.paywallSubtitle,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.4,
                            fontSize: isWide ? 14.5 : 14,
                          ),
                        ),
                        const SizedBox(height: 22),
                        _PlanCard(
                          title: l10n.paywallPlanFree,
                          emphasize: false,
                          features: [
                            l10n.paywallFreeFeature1,
                            l10n.paywallFreeFeature2,
                            l10n.paywallFreeFeature3,
                          ],
                        ),
                        const SizedBox(height: 12),
                        _PlanCard(
                          title: l10n.paywallPlanPro,
                          badge: l10n.paywallRecommended,
                          emphasize: true,
                          features: [
                            l10n.paywallProFeature1,
                            l10n.paywallProFeature2,
                            l10n.paywallProFeature3,
                          ],
                        ),
                        const SizedBox(height: 20),
                        FilledButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.paywallBillingNote),
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.textOnPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadius.mdAll,
                            ),
                          ),
                          child: Text(
                            l10n.proComingSoon,
                            style: AppTextStyles.button.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () => context.pop(),
                          child: Text(
                            l10n.paywallContinueFree,
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String? badge;
  final bool emphasize;
  final List<String> features;

  const _PlanCard({
    required this.title,
    this.badge,
    required this.emphasize,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor =
        emphasize ? AppColors.primary.withValues(alpha: 0.45) : AppColors.border;
    final bg = emphasize
        ? AppColors.primary.withValues(alpha: 0.06)
        : AppColors.surface;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.lgAll,
        border: Border.all(
          color: borderColor,
          width: emphasize ? 1.5 : 1,
        ),
        boxShadow: emphasize
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (badge != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badge!,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          ...features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 18,
                    color: emphasize
                        ? AppColors.primary
                        : AppColors.textTertiary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      f,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
