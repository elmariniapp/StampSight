import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/di/providers.dart';
import '../../../core/layout/app_content_layout.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../features/clients/domain/client.dart';
import '../../../features/clients/domain/clients_repository.dart';
import '../../../features/clients/domain/site_mission.dart';
import '../../../features/proofs/domain/proof.dart';
import '../../../features/proofs/presentation/widgets/proof_capture_hero_image.dart';
import '../../../l10n/app_localizations.dart';
import '../../session/presentation/active_session_sheet.dart';
import 'widgets/session_banner_card.dart';

/// Même lecture d’ombre / bordure que la grille « Mes preuves ».
const _homeRecentProofCardShadow = [
  BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 10,
    offset: Offset(0, 2),
  ),
  BoxShadow(
    color: Color(0x060D1B2A),
    blurRadius: 18,
    offset: Offset(0, 5),
  ),
];

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void _openSessionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ActiveSessionSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessionRepo = ref.read(activeSessionRepositoryProvider);
    final proofListenable = ref.read(proofRepositoryListenableProvider);
    return ListenableBuilder(
      listenable: Listenable.merge([
        sessionRepo as Listenable,
        proofListenable,
      ]),
      builder: (context, _) {
        final l10n = AppLocalizations.of(context);
        final session = sessionRepo.currentSession;
        final proofRepo = ref.read(proofRepositoryProvider);
        final allProofs = proofRepo.recentProofs.toList();
        final recentProofs = allProofs.take(4).toList();
        final clientsRepo = ref.read(clientsRepositoryProvider);

        final now = DateTime.now();
        final todayCount = allProofs.where((p) {
          return p.createdAt.year == now.year &&
              p.createdAt.month == now.month &&
              p.createdAt.day == now.day;
        }).length;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            top: false,
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppContentLayout.horizontalMargin(context),
              ),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
              SliverAppBar(
                pinned: true,
                stretch: true,
                toolbarHeight: 76,
                elevation: 0,
                scrolledUnderElevation: 0,
                backgroundColor: AppColors.background,
                surfaceTintColor: Colors.transparent,
                titleSpacing: AppSpacing.screenPadding,
                title: const _AppBarTitle(),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  0,
                  4,
                  0,
                  AppSpacing.xxl + 12,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      _HomeHero(
                        onNewProof: () => context.push(RoutePaths.capture),
                        onSessionTap: _openSessionSheet,
                      ),
                      const SizedBox(height: 14),
                      _InsightBand(
                        todayCount: todayCount,
                        totalCount: allProofs.length,
                        hasSession: session != null,
                      ),
                      const SizedBox(height: 14),
                      SessionBannerCard(
                        session: session,
                        onTap: _openSessionSheet,
                      ),
                      const SizedBox(height: AppSpacing.xl + 4),
                      _SectionHeader(
                        title: l10n.recentProofs,
                        actionLabel: l10n.viewAll,
                        onActionTap: () => context.go(RoutePaths.library),
                      ),
                      const SizedBox(height: 12),
                      recentProofs.isEmpty
                          ? _EmptyProofsState(l10n: l10n)
                          : _ProofList(
                              proofs: recentProofs,
                              clientsRepo: clientsRepo,
                              l10n: l10n,
                            ),
                    ],
                  ),
                ),
              ),
            ],
              ),
            ),
          ),
          bottomNavigationBar: const AppBottomNav(
            currentTab: AppBottomNavTab.home,
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// APP BAR
// ─────────────────────────────────────────────────────────────────────────────

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: AppRadius.mdAll,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.28),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.verified_rounded,
            color: AppColors.textOnPrimary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppConstants.appName,
                style: AppTextStyles.displayMedium.copyWith(
                  fontSize: 18,
                  letterSpacing: -0.4,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Preuve photo terrain',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 11,
                  letterSpacing: 0.15,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        const _NotificationBadge(),
      ],
    );
  }
}

class _NotificationBadge extends StatelessWidget {
  const _NotificationBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.sm,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.notifications_outlined,
            size: 20,
            color: AppColors.textSecondary,
          ),
          Positioned(
            top: 9,
            right: 9,
            child: Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.surface,
                  width: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HERO
// ─────────────────────────────────────────────────────────────────────────────

class _HomeHero extends StatelessWidget {
  final VoidCallback onNewProof;
  final VoidCallback onSessionTap;

  const _HomeHero({
    required this.onNewProof,
    required this.onSessionTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.lgAll,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/home/home_hero_stamp_sight_final.webp',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.black.withOpacity(0.06),
                    Colors.black.withOpacity(0.0),
                    AppColors.primary.withOpacity(0.38),
                    AppColors.primary.withOpacity(0.72),
                  ],
                  stops: const [0.0, 0.32, 0.72, 1.0],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.0),
                    Colors.black.withOpacity(0.12),
                    Colors.black.withOpacity(0.5),
                  ],
                  stops: const [0.0, 0.42, 1.0],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _LiveBadge(),
                const SizedBox(height: 16),
                Text(
                  'Transformez chaque\nphoto en preuve.',
                  style: AppTextStyles.displayMedium.copyWith(
                    color: Colors.white,
                    fontSize: 24,
                    height: 1.18,
                    letterSpacing: -0.6,
                    fontWeight: FontWeight.w800,
                    shadows: const [
                      Shadow(
                        color: Color(0x66000000),
                        blurRadius: 18,
                        offset: Offset(0, 3),
                      ),
                      Shadow(
                        color: Color(0x40000000),
                        blurRadius: 6,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  'Rapide, contextualisée, infalsifiable.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.86),
                    fontSize: 13,
                    height: 1.35,
                    letterSpacing: 0.12,
                    fontWeight: FontWeight.w500,
                    shadows: const [
                      Shadow(
                        color: Color(0x54000000),
                        blurRadius: 12,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: _HeroPrimaryButton(onTap: onNewProof),
                    ),
                    const SizedBox(width: 10),
                    _HeroSecondaryButton(onTap: onSessionTap),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveBadge extends StatelessWidget {
  const _LiveBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.28),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withOpacity(0.22),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFF22C55E),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF22C55E).withOpacity(0.35),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'Capture immédiate',
            style: AppTextStyles.labelMedium.copyWith(
              color: Colors.white.withOpacity(0.96),
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.25,
              shadows: const [
                Shadow(
                  color: Color(0x4D000000),
                  blurRadius: 8,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroPrimaryButton extends StatelessWidget {
  final VoidCallback onTap;

  const _HeroPrimaryButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mdAll,
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.textOnPrimary,
            borderRadius: AppRadius.mdAll,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.22),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt_rounded,
                  size: 17,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Nouvelle preuve',
                  style: AppTextStyles.button.copyWith(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroSecondaryButton extends StatelessWidget {
  final VoidCallback onTap;

  const _HeroSecondaryButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: AppRadius.mdAll,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mdAll,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.14),
            borderRadius: AppRadius.mdAll,
            border: Border.all(
              color: Colors.white.withOpacity(0.26),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(
            Icons.layers_rounded,
            color: AppColors.textOnPrimary,
            size: 19,
          ),
        ),
      ),
    );
  }
}

// ignore: unused_element
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.025)
      ..strokeWidth = 0.5;

    const step = 36.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// INSIGHT BAND
// ─────────────────────────────────────────────────────────────────────────────

class _InsightBand extends StatelessWidget {
  final int todayCount;
  final int totalCount;
  final bool hasSession;

  const _InsightBand({
    required this.todayCount,
    required this.totalCount,
    required this.hasSession,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.sm,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      child: Row(
        children: [
          Expanded(
            child: _InsightCell(
              icon: Icons.today_rounded,
              value: '$todayCount',
              label: "Aujourd'hui",
              accent: AppColors.primary,
            ),
          ),
          _VerticalDividerSoft(),
          Expanded(
            child: _InsightCell(
              icon: Icons.photo_library_outlined,
              value: '$totalCount',
              label: 'Total',
              accent: const Color(0xFF6366F1),
            ),
          ),
          _VerticalDividerSoft(),
          Expanded(
            child: _InsightCell(
              icon: hasSession
                  ? Icons.play_circle_fill_rounded
                  : Icons.pause_circle_rounded,
              value: hasSession ? 'Actif' : 'Libre',
              label: 'Mode',
              accent: hasSession
                  ? const Color(0xFF22C55E)
                  : AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightCell extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color accent;

  const _InsightCell({
    required this.icon,
    required this.value,
    required this.label,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 16,
              color: accent,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.35,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _VerticalDividerSoft extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 42,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: AppColors.border,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION HEADER
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onActionTap;

  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        GestureDetector(
          onTap: onActionTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.09),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              actionLabel,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.accent,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PROOF LIST
// ─────────────────────────────────────────────────────────────────────────────

class _ProofList extends StatelessWidget {
  final List<Proof> proofs;
  final ClientsRepository clientsRepo;
  final AppLocalizations l10n;

  const _ProofList({
    required this.proofs,
    required this.clientsRepo,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        proofs.length,
        (index) {
          final proof = proofs[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == proofs.length - 1 ? 0 : 10,
            ),
            child: _RecentProofCard(
              proof: proof,
              clientsRepo: clientsRepo,
              l10n: l10n,
              onTap: () => context.push(
                RoutePaths.proofDetailFor(proof.id),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EMPTY STATE
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyProofsState extends StatelessWidget {
  final AppLocalizations l10n;

  const _EmptyProofsState({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.photo_camera_outlined,
                  size: 26,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.emptyHomeTitle,
            style: AppTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 280),
            child: Text(
              l10n.emptyHomeSubtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textTertiary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context.push(RoutePaths.capture),
              icon: const Icon(Icons.camera_alt_rounded, size: 18),
              label: Text(l10n.emptyHomeCta),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.lgAll,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.cardPadding,
                ),
                textStyle: AppTextStyles.button,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RECENT PROOF CARD
// ─────────────────────────────────────────────────────────────────────────────

class _RecentProofCard extends StatelessWidget {
  final Proof proof;
  final ClientsRepository clientsRepo;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  const _RecentProofCard({
    required this.proof,
    required this.clientsRepo,
    required this.l10n,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final client = proof.clientId != null
        ? clientsRepo.getClientById(proof.clientId!)
        : null;
    final site = proof.siteMissionId != null
        ? clientsRepo.getSiteById(proof.siteMissionId!)
        : null;

    final categoryColor = _colorForType(proof.proofType);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.lgAll,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.lgAll,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.07),
              width: 1,
            ),
            boxShadow: _homeRecentProofCardShadow,
          ),
          child: SizedBox(
            height: 92,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppRadius.lg),
                    bottomLeft: Radius.circular(AppRadius.lg),
                  ),
                  child: SizedBox(
                    width: 80,
                    height: 92,
                    child: ProofCaptureHeroImage(
                      proof: proof,
                      categoryColor: categoryColor,
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 92,
                  color: AppColors.border.withValues(alpha: 0.65),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            proof.title,
                            style: AppTextStyles.titleSmall.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              letterSpacing: -0.22,
                              height: 1.2,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          _ClientLine(
                            client: client,
                            site: site,
                            l10n: l10n,
                          ),
                          const SizedBox(height: 9),
                          Row(
                            children: [
                              Expanded(
                                child: _MetaPill(
                                  icon: Icons.schedule_rounded,
                                  label: DateFormatters.formatRelative(
                                    proof.createdAt,
                                    l10n,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: _MetaPill(
                                  icon: Icons.calendar_today_rounded,
                                  label:
                                      '${proof.createdAt.day.toString().padLeft(2, '0')}/${proof.createdAt.month.toString().padLeft(2, '0')}',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: SizedBox(
                    width: 22,
                    height: 92,
                    child: Center(
                      child: Icon(
                        Icons.chevron_right_rounded,
                        size: 22,
                        color: AppColors.textTertiary.withValues(alpha: 0.85),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _colorForType(ProofType type) => switch (type) {
        ProofType.inspection => AppColors.categoryInspection,
        ProofType.delivery => AppColors.categoryDelivery,
        ProofType.workProgress => AppColors.categoryProgress,
        ProofType.incident => AppColors.categoryIncident,
        ProofType.inventory => AppColors.categoryInventory,
        ProofType.other => AppColors.categoryOther,
      };
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED
// ─────────────────────────────────────────────────────────────────────────────

class _MetaPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaPill({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.fullAll,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 11,
            color: AppColors.textTertiary,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClientLine extends StatelessWidget {
  final Client? client;
  final SiteMission? site;
  final AppLocalizations l10n;

  const _ClientLine({
    required this.client,
    required this.site,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final c = client;
    if (c == null) {
      return Text(
        l10n.unclassified,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textTertiary,
          fontSize: 11,
          height: 1.3,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: c.color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            site != null ? '${c.name} · ${site!.name}' : c.name,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              height: 1.28,
              letterSpacing: -0.05,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
        ),
      ],
    );
  }
}