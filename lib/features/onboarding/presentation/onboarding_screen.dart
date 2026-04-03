import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/routes/route_names.dart';
import '../../../app/routes/routing_state.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/constants/onboarding_assets.dart';
import '../../../core/constants/paywall_assets.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/layout/app_content_layout.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/app_locale.dart';
import 'widgets/onboarding_micro_product_card.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;
  static const _pageCount = 3;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _complete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(StorageKeys.onboardingCompleted, true);
    if (!mounted) return;
    AppRoutingState.instance.onboardingComplete = true;
    if (!mounted) return;
    context.go(RoutePaths.home);
  }

  void _next() {
    if (_page < _pageCount - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    } else {
      _complete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final hMargin = AppContentLayout.horizontalMargin(context);
    final isWide = MediaQuery.sizeOf(context).width >=
        AppContentLayout.tabletBreakpoint;
    final pageMaxWidth = math.min(
      AppContentLayout.maxContentWidth,
      MediaQuery.sizeOf(context).width,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(hMargin, 6, hMargin, 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: List.generate(
                      _pageCount,
                      (i) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 240),
                            curve: Curves.easeOutCubic,
                            height: i == _page ? 4.0 : 2.5,
                            decoration: BoxDecoration(
                              color: i <= _page
                                  ? AppColors.primary
                                  : AppColors.border.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: isWide ? 10 : 8),
                  const _OnboardingLangSegment(),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: pageMaxWidth),
                  child: PageView(
                    controller: _controller,
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: (i) => setState(() => _page = i),
                    children: [
                      _OnboardingSlide(
                        imageAsset: OnboardingImageAssets.heroContextCapture,
                        kicker: l10n.onboardingSlide1Kicker,
                        title: l10n.onboardingSlide1Title,
                        body: l10n.onboardingSlide1Body,
                        benefits: [
                          l10n.onboardingSlide1Benefit1,
                          l10n.onboardingSlide1Benefit2,
                          l10n.onboardingSlide1Benefit3,
                        ],
                        microKind: OnboardingMicroCardKind.proofStructured,
                        isWide: isWide,
                        horizontalPadding: hMargin,
                      ),
                      _OnboardingSlide(
                        imageAsset: OnboardingImageAssets.heroEntryProof,
                        kicker: l10n.onboardingSlide2Kicker,
                        title: l10n.onboardingSlide2Title,
                        body: l10n.onboardingSlide2Body,
                        benefits: [
                          l10n.onboardingSlide2Benefit1,
                          l10n.onboardingSlide2Benefit2,
                          l10n.onboardingSlide2Benefit3,
                        ],
                        microKind: OnboardingMicroCardKind.contextOrganized,
                        isWide: isWide,
                        horizontalPadding: hMargin,
                      ),
                      _OnboardingSlide(
                        imageAsset: PaywallImageAssets.heroDeliveryDamage,
                        kicker: l10n.onboardingSlide3Kicker,
                        title: l10n.onboardingSlide3Title,
                        body: l10n.onboardingSlide3Body,
                        benefits: [
                          l10n.onboardingSlide3Benefit1,
                          l10n.onboardingSlide3Benefit2,
                          l10n.onboardingSlide3Benefit3,
                        ],
                        microKind: OnboardingMicroCardKind.deliverablePro,
                        isWide: isWide,
                        horizontalPadding: hMargin,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                hMargin,
                4,
                hMargin,
                bottomInset + 14,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 12 : 8,
                    ),
                    child: Text(
                      l10n.onboardingTrustRow,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary.withValues(alpha: 0.92),
                        fontSize: isWide ? 12.5 : 11.5,
                        height: 1.38,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.18,
                      ),
                    ),
                  ),
                  SizedBox(height: isWide ? 5 : 4),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 14 : 10,
                    ),
                    child: Text(
                      l10n.onboardingPrivacyCompact,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary.withValues(alpha: 0.78),
                        fontSize: isWide ? 11.5 : 10.5,
                        height: 1.36,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                  SizedBox(height: isWide ? 10 : 9),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: AppRadius.mdAll,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.16),
                          blurRadius: 14,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: FilledButton(
                      onPressed: _next,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textOnPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 17),
                        minimumSize: const Size.fromHeight(52),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.mdAll,
                        ),
                      ),
                      child: Text(
                        _page < _pageCount - 1
                            ? l10n.onboardingNext
                            : l10n.onboardingStart,
                        style: AppTextStyles.button.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.15,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingLangSegment extends StatelessWidget {
  const _OnboardingLangSegment();

  @override
  Widget build(BuildContext context) {
    final current = AppLocale.instance.locale.languageCode;
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.58),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _OnboardingLangChip(
              label: l10n.french,
              selected: current == 'fr',
              onTap: () => AppLocale.instance.setLocaleCode('fr'),
            ),
            _OnboardingLangChip(
              label: l10n.english,
              selected: current == 'en',
              onTap: () => AppLocale.instance.setLocaleCode('en'),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingLangChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _OnboardingLangChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color:
                  selected ? AppColors.textOnPrimary : AppColors.textSecondary,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 11,
              letterSpacing: 0.06,
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  final String imageAsset;
  final String kicker;
  final String title;
  final String body;
  final List<String> benefits;
  final OnboardingMicroCardKind microKind;
  final bool isWide;
  final double horizontalPadding;

  const _OnboardingSlide({
    required this.imageAsset,
    required this.kicker,
    required this.title,
    required this.body,
    required this.benefits,
    required this.microKind,
    required this.isWide,
    required this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final screenH = MediaQuery.sizeOf(context).height;
    final bandMax = isWide
        ? math.min(AppContentLayout.maxContentWidth, 560.0)
        : screenW - 2 * horizontalPadding;
    final contentW = math.min(bandMax, screenW - 2 * horizontalPadding);
    final heroMaxH = math.min(
      isWide ? 360.0 : 340.0,
      screenH * (isWide ? 0.40 : 0.38),
    );
    final heroH = math.min(contentW * 0.64, heroMaxH);
    final textMaxW = math.min(420.0, contentW);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            2,
            horizontalPadding,
            12,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 4),
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: contentW,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: AppRadius.lgAll,
                      child: ColoredBox(
                        color: AppColors.surfaceVariant,
                        child: Image.asset(
                          imageAsset,
                          width: contentW,
                          height: heroH,
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                          gaplessPlayback: true,
                          filterQuality: FilterQuality.medium,
                        ),
                      ),
                    ),
                    SizedBox(height: isWide ? 16 : 14),
                    Text(
                      kicker,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: isWide ? 11.5 : 11,
                        letterSpacing: 0.35,
                        height: 1.15,
                      ),
                    ),
                    SizedBox(height: isWide ? 10 : 8),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: textMaxW),
                      child: Text(
                        title,
                        style: AppTextStyles.displayMedium.copyWith(
                          fontSize: isWide ? 27 : 24,
                          height: 1.12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.65,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    SizedBox(height: isWide ? 12 : 10),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: textMaxW),
                      child: Text(
                        body,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.42,
                          fontSize: isWide ? 15.5 : 14.5,
                        ),
                      ),
                    ),
                    SizedBox(height: isWide ? 16 : 14),
                    _OnboardingBenefitsBlock(lines: benefits, isWide: isWide),
                    SizedBox(height: isWide ? 16 : 14),
                    OnboardingMicroProductCard(
                      kind: microKind,
                      isWide: isWide,
                      maxWidth: textMaxW,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _OnboardingBenefitsBlock extends StatelessWidget {
  final List<String> lines;
  final bool isWide;

  const _OnboardingBenefitsBlock({
    required this.lines,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        isWide ? 16 : 14,
        isWide ? 14 : 12,
        isWide ? 16 : 14,
        isWide ? 12 : 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < lines.length; i++) ...[
            if (i > 0) SizedBox(height: isWide ? 9 : 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: isWide ? 7 : 6.5),
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.75),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Text(
                    lines[i],
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.38,
                      fontSize: isWide ? 13.5 : 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
