import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../core/di/providers.dart';
import '../../../core/layout/app_content_layout.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../l10n/app_localizations.dart';
import '../../proofs/domain/proof.dart';
import '../../proofs/data/proof_export_service.dart';
import '../../proofs/presentation/pdf_export_post_actions.dart';
import '../../settings/data/app_settings_repository.dart';
import '../../clients/domain/client.dart';
import '../../clients/domain/clients_repository.dart';
import '../../clients/domain/site_mission.dart';
import '../../session/domain/active_session.dart';
import '../../session/presentation/active_session_sheet.dart';
import 'widgets/proof_grid_item.dart';
import 'widgets/library_empty_state.dart';

enum _LibrarySort { newest, oldest, favoritesFirst }

/// Écran « Mes preuves » — composition premium : header éditorial, session carte,
/// filtres segmentés, grille à cartes retravaillées (voir [ProofGridItem]).
class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedClientId;
  String? _selectedSiteMissionId;
  bool _unclassifiedOnly = false;
  bool _favoritesOnly = false;
  ProofType? _typeFilter;
  _LibrarySort _sort = _LibrarySort.newest;

  // Selection mode state
  bool _selectionMode = false;
  final Set<String> _selectedProofIds = {};
  bool _groupedPdfBusy = false;

  void _enterSelectionMode() {
    setState(() {
      _selectionMode = true;
      _selectedProofIds.clear();
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _selectionMode = false;
      _selectedProofIds.clear();
    });
  }

  void _toggleProofSelection(String proofId) {
    setState(() {
      if (_selectedProofIds.contains(proofId)) {
        _selectedProofIds.remove(proofId);
      } else {
        _selectedProofIds.add(proofId);
      }
    });
  }

  Future<void> _exportGroupedPdf(AppLocalizations l10n) async {
    if (_groupedPdfBusy || _selectedProofIds.isEmpty) return;
    if (!ref.read(appSettingsRepositoryProvider).groupedReportAllowed) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.groupedReportDisabled)),
        );
      }
      return;
    }
    setState(() => _groupedPdfBusy = true);
    try {
      final repo = ref.read(proofRepositoryProvider);
      final clientsRepo = ref.read(clientsRepositoryProvider);
      final sortOrder =
          ref.read(appSettingsRepositoryProvider).exportDefaultSortOrder;
      final proofs = _selectedProofIds
          .map(repo.getById)
          .whereType<Proof>()
          .toList()
        ..sort((a, b) {
          final c = a.createdAt.compareTo(b.createdAt);
          return sortOrder == ExportSortOrderSetting.newestFirst ? -c : c;
        });

      if (proofs.isEmpty) return;

      final labelsList = proofs.map((p) {
        final client = p.clientId != null
            ? clientsRepo.getClientById(p.clientId!)
            : null;
        final site = p.siteMissionId != null
            ? clientsRepo.getSiteById(p.siteMissionId!)
            : null;
        return ProofPdfLabels.fromProof(
          proof: p,
          l10n: l10n,
          clientName: client?.name,
          siteName: site?.name,
        );
      }).toList();

      final settings = ref.read(appSettingsRepositoryProvider);
      final file = await ProofExportService.writeGroupedPdfToTemp(
        proofs: proofs,
        labelsList: labelsList,
        l10n: l10n,
        appearance: settings.pdfAppearancePreferences,
        metadataMask: PdfMetadataExportMask(
          includeClient: settings.exportIncludeClient,
          includeSite: settings.exportIncludeSite,
          includeNote: settings.exportIncludeNote,
        ),
      );
      if (!mounted) return;

      await runPdfPostGenerationActions(
        context: context,
        l10n: l10n,
        settings: settings,
        file: file,
        shareSubject: l10n.groupedReport,
      );

      if (mounted) _exitSelectionMode();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.groupedPdfFailed)),
        );
      }
    } finally {
      if (mounted) setState(() => _groupedPdfBusy = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _proofMatchesQuery(
    Proof p,
    String q,
    ClientsRepository clients,
    AppLocalizations l10n,
  ) {
    if (q.isEmpty) return true;
    if (p.title.toLowerCase().contains(q)) return true;
    if (p.description?.toLowerCase().contains(q) ?? false) return true;
    if (_proofTypeLabel(p.proofType, l10n).toLowerCase().contains(q)) {
      return true;
    }
    if (p.overlayDateText.toLowerCase().contains(q)) return true;
    if (p.overlayTimeText.toLowerCase().contains(q)) return true;
    final addr = p.address ?? p.overlayAddressText;
    if (addr != null && addr.toLowerCase().contains(q)) return true;
    if (p.clientId != null) {
      final c = clients.getClientById(p.clientId!);
      if (c != null) {
        if (c.name.toLowerCase().contains(q)) return true;
        if (c.company?.toLowerCase().contains(q) ?? false) return true;
      }
    }
    if (p.siteMissionId != null) {
      final s = clients.getSiteById(p.siteMissionId!);
      if (s?.name.toLowerCase().contains(q) ?? false) return true;
    }
    return false;
  }

  List<Proof> _visibleProofs(AppLocalizations l10n) {
    final clients = ref.read(clientsRepositoryProvider);
    var list = List<Proof>.from(ref.read(proofRepositoryProvider).proofs);

    if (_unclassifiedOnly) {
      list = list.where((p) => p.clientId == null).toList();
    } else if (_selectedClientId != null) {
      list = list.where((p) => p.clientId == _selectedClientId).toList();
    }
    if (_selectedSiteMissionId != null) {
      list = list
          .where((p) => p.siteMissionId == _selectedSiteMissionId)
          .toList();
    }
    if (_favoritesOnly) {
      list = list.where((p) => p.isFavorite).toList();
    }
    if (_typeFilter != null) {
      list = list.where((p) => p.proofType == _typeFilter).toList();
    }
    final q = _searchController.text.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((p) => _proofMatchesQuery(p, q, clients, l10n)).toList();
    }

    int byDateDesc(Proof a, Proof b) => b.createdAt.compareTo(a.createdAt);
    int byDateAsc(Proof a, Proof b) => a.createdAt.compareTo(b.createdAt);
    switch (_sort) {
      case _LibrarySort.newest:
        list.sort(byDateDesc);
        break;
      case _LibrarySort.oldest:
        list.sort(byDateAsc);
        break;
      case _LibrarySort.favoritesFirst:
        list.sort((a, b) {
          if (a.isFavorite != b.isFavorite) {
            return a.isFavorite ? -1 : 1;
          }
          return byDateDesc(a, b);
        });
        break;
    }
    return list;
  }

  List<SiteMission> _sitesWithProofsForClient(String clientId) {
    final siteIds = ref
        .read(proofRepositoryProvider)
        .proofs
        .where((p) => p.clientId == clientId && p.siteMissionId != null)
        .map((p) => p.siteMissionId!)
        .toSet();
    final clientsRepo = ref.read(clientsRepositoryProvider);
    final sites = siteIds
        .map(clientsRepo.getSiteById)
        .whereType<SiteMission>()
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return sites;
  }

  List<Client> _clientsWithProofs() {
    final ids = ref.read(proofRepositoryProvider).proofs
        .where((p) => p.clientId != null)
        .map((p) => p.clientId!)
        .toSet();
    final clientsRepo = ref.read(clientsRepositoryProvider);
    return ids
        .map(clientsRepo.getClientById)
        .whereType<Client>()
        .toList();
  }

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
        AppSettingsRepository.instance,
      ]),
      builder: (context, _) {
        final session = sessionRepo.currentSession;
        final l10n = AppLocalizations.of(context);
        final groupedOk =
            ref.read(appSettingsRepositoryProvider).groupedReportAllowed;
        final proofs = _visibleProofs(l10n);
        final totalCount = ref.read(proofRepositoryProvider).totalCount;
        final topInset = MediaQuery.paddingOf(context).top;

        final gridCross =
            AppContentLayout.libraryGridCrossAxisCount(
              MediaQuery.sizeOf(context).width -
                  2 * AppContentLayout.horizontalMargin(context),
            );
        final gridRatio =
            AppContentLayout.libraryGridChildAspectRatio(gridCross);

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
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                0,
                topInset + AppSpacing.md,
                0,
                AppSpacing.lg,
              ),
              child: _selectionMode
                  ? _SelectionHeader(
                      l10n: l10n,
                      selectedCount: _selectedProofIds.length,
                      busy: _groupedPdfBusy,
                      onCancel: _exitSelectionMode,
                      onExport: () => _exportGroupedPdf(l10n),
                    )
                  : _LibraryPremiumHeader(
                      l10n: l10n,
                      visibleCount: proofs.length,
                      archiveTotal: totalCount,
                      onSelectMode: proofs.isNotEmpty && groupedOk
                          ? _enterSelectionMode
                          : null,
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                0,
                0,
                0,
                AppSpacing.sm,
              ),
              child: _LibrarySearchSortRow(
                controller: _searchController,
                sort: _sort,
                l10n: l10n,
                onQueryChanged: (_) => setState(() {}),
                onSortChanged: (s) => setState(() => _sort = s),
              ),
            ),
          ),
          if (session != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.zero,
                child: _SessionContextCard(
                  session: session,
                  onTap: _openSessionSheet,
                  l10n: l10n,
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: SizedBox(height: session != null ? AppSpacing.md : AppSpacing.sm),
          ),
          SliverToBoxAdapter(
            child: _FilterDock(
              selectedClientId: _selectedClientId,
              unclassifiedOnly: _unclassifiedOnly,
              clientsWithProofs: _clientsWithProofs(),
              l10n: l10n,
              onSelectAll: () => setState(() {
                _selectedClientId = null;
                _selectedSiteMissionId = null;
                _unclassifiedOnly = false;
              }),
              onSelectUnclassified: () => setState(() {
                _unclassifiedOnly = !_unclassifiedOnly;
                _selectedClientId = null;
                _selectedSiteMissionId = null;
              }),
              onSelectClient: (id) => setState(() {
                _selectedClientId = (_selectedClientId == id) ? null : id;
                _selectedSiteMissionId = null;
                _unclassifiedOnly = false;
              }),
            ),
          ),
          if (_selectedClientId != null &&
              _sitesWithProofsForClient(_selectedClientId!).isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: _SiteFilterStrip(
                  sites: _sitesWithProofsForClient(_selectedClientId!),
                  selectedSiteId: _selectedSiteMissionId,
                  l10n: l10n,
                  onSelectAll: () => setState(() => _selectedSiteMissionId = null),
                  onSelectSite: (id) => setState(() {
                    _selectedSiteMissionId =
                        _selectedSiteMissionId == id ? null : id;
                  }),
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _TypeAndFavoritesStrip(
                l10n: l10n,
                selectedType: _typeFilter,
                favoritesOnly: _favoritesOnly,
                onToggleFavorites: () => setState(
                  () => _favoritesOnly = !_favoritesOnly,
                ),
                onSelectType: (t) => setState(() {
                  _typeFilter = _typeFilter == t ? null : t;
                }),
                onClearType: () => setState(() => _typeFilter = null),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xs)),
          if (proofs.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: LibraryEmptyState(),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                0,
                0,
                0,
                AppSpacing.xxl,
              ),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridCross,
                  mainAxisSpacing: AppSpacing.itemGap,
                  crossAxisSpacing: AppSpacing.itemGap,
                  childAspectRatio: gridRatio,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final proof = proofs[index];
                    final isSelected =
                        _selectedProofIds.contains(proof.id);
                    return Stack(
                      children: [
                        ProofGridItem(
                          proof: proof,
                          onTap: _selectionMode
                              ? () => _toggleProofSelection(proof.id)
                              : () => context.push(
                                    RoutePaths.proofDetailFor(proof.id),
                                  ),
                          onLongPress: !_selectionMode && groupedOk
                              ? () {
                                  _enterSelectionMode();
                                  _toggleProofSelection(proof.id);
                                }
                              : null,
                        ),
                        if (_selectionMode)
                          Positioned(
                            top: 6,
                            right: 6,
                            child: IgnorePointer(
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.white
                                          .withValues(alpha: 0.85),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.border,
                                    width: 2,
                                  ),
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check_rounded,
                                        size: 14,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                  childCount: proofs.length,
                ),
              ),
            ),
        ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(
        currentTab: AppBottomNavTab.library,
      ),
    );
      },
    );
  }
}

String _proofTypeLabel(ProofType type, AppLocalizations l10n) => switch (type) {
      ProofType.inspection => l10n.proofTypeInspection,
      ProofType.delivery => l10n.proofTypeDelivery,
      ProofType.workProgress => l10n.proofTypeWorkProgress,
      ProofType.incident => l10n.proofTypeIncident,
      ProofType.inventory => l10n.proofTypeInventory,
      ProofType.other => l10n.proofTypeOther,
    };

class _LibrarySearchSortRow extends StatelessWidget {
  final TextEditingController controller;
  final _LibrarySort sort;
  final AppLocalizations l10n;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<_LibrarySort> onSortChanged;

  const _LibrarySearchSortRow({
    required this.controller,
    required this.sort,
    required this.l10n,
    required this.onQueryChanged,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.lgAll,
              border: Border.all(color: AppColors.border),
              boxShadow: AppShadows.sm,
            ),
            child: TextField(
              controller: controller,
              onChanged: onQueryChanged,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                isDense: true,
                hintText: l10n.librarySearchHint,
                hintStyle: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: AppColors.textTertiary,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.md,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        PopupMenuButton<_LibrarySort>(
          initialValue: sort,
          tooltip: l10n.proofType,
          onSelected: onSortChanged,
          itemBuilder: (ctx) => [
            PopupMenuItem(
              value: _LibrarySort.newest,
              child: Text(l10n.sortNewestFirst),
            ),
            PopupMenuItem(
              value: _LibrarySort.oldest,
              child: Text(l10n.sortOldestFirst),
            ),
            PopupMenuItem(
              value: _LibrarySort.favoritesFirst,
              child: Text(l10n.sortFavoritesFirst),
            ),
          ],
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.lgAll,
              border: Border.all(color: AppColors.border),
              boxShadow: AppShadows.sm,
            ),
            child: const Icon(
              Icons.sort_rounded,
              size: 22,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _SiteFilterStrip extends StatelessWidget {
  final List<SiteMission> sites;
  final String? selectedSiteId;
  final AppLocalizations l10n;
  final VoidCallback onSelectAll;
  final ValueChanged<String> onSelectSite;

  const _SiteFilterStrip({
    required this.sites,
    required this.selectedSiteId,
    required this.l10n,
    required this.onSelectAll,
    required this.onSelectSite,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: AppRadius.lgAll,
          border: Border.all(color: AppColors.border),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              _FilterPill(
                label: l10n.all,
                selected: selectedSiteId == null,
                onTap: onSelectAll,
                accent: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              ...sites.map((site) {
                final sel = selectedSiteId == site.id;
                return Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.xs),
                  child: _FilterPill(
                    label: site.name,
                    selected: sel,
                    accent: AppColors.accent,
                    onTap: () => onSelectSite(site.id),
                  ),
                );
              }),
            ],
          ),
        ),
    );
  }
}

class _TypeAndFavoritesStrip extends StatelessWidget {
  final AppLocalizations l10n;
  final ProofType? selectedType;
  final bool favoritesOnly;
  final VoidCallback onToggleFavorites;
  final ValueChanged<ProofType> onSelectType;
  final VoidCallback onClearType;

  const _TypeAndFavoritesStrip({
    required this.l10n,
    required this.selectedType,
    required this.favoritesOnly,
    required this.onToggleFavorites,
    required this.onSelectType,
    required this.onClearType,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: AppRadius.lgAll,
          border: Border.all(color: AppColors.border),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              _FilterPill(
                label: l10n.favoritesOnly,
                selected: favoritesOnly,
                onTap: onToggleFavorites,
                accent: AppColors.secondaryLight,
              ),
              const SizedBox(width: AppSpacing.xs),
              _FilterPill(
                label: l10n.allTypes,
                selected: selectedType == null,
                onTap: onClearType,
                accent: AppColors.primary,
              ),
              ...ProofType.values.map((type) {
                final sel = selectedType == type;
                return Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.xs),
                  child: _FilterPill(
                    label: _proofTypeLabel(type, l10n),
                    selected: sel,
                    accent: AppColors.primary,
                    onTap: () => onSelectType(type),
                  ),
                );
              }),
            ],
          ),
        ),
    );
  }
}

// ─── Header premium (remplace SliverAppBar.large) ───────────────────────────

class _LibraryPremiumHeader extends StatelessWidget {
  final AppLocalizations l10n;
  final int visibleCount;
  final int archiveTotal;
  final VoidCallback? onSelectMode;

  const _LibraryPremiumHeader({
    required this.l10n,
    required this.visibleCount,
    required this.archiveTotal,
    this.onSelectMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.myProofsTitle,
                    style: AppTextStyles.displayLarge.copyWith(
                      fontSize: 32,
                      letterSpacing: -1.2,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.proofCount(visibleCount),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textTertiary,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                  if (visibleCount != archiveTotal) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '$visibleCount / $archiveTotal',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _ArchiveStatChip(total: archiveTotal, l10n: l10n),
                if (onSelectMode != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  GestureDetector(
                    onTap: onSelectMode,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: AppRadius.mdAll,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.checklist_rounded,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            l10n.selectMode,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _SelectionHeader extends StatelessWidget {
  final AppLocalizations l10n;
  final int selectedCount;
  final bool busy;
  final VoidCallback onCancel;
  final VoidCallback onExport;

  const _SelectionHeader({
    required this.l10n,
    required this.selectedCount,
    required this.busy,
    required this.onCancel,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.selectedCount(selectedCount),
                    style: AppTextStyles.displayLarge.copyWith(
                      fontSize: 24,
                      letterSpacing: -0.8,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.groupedReport,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            TextButton(
              onPressed: onCancel,
              child: Text(
                l10n.cancelSelection,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            ElevatedButton.icon(
              onPressed: (selectedCount > 0 && !busy) ? onExport : null,
              icon: busy
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.picture_as_pdf_rounded, size: 16),
              label: Text(busy
                  ? l10n.groupedPdfGenerating
                  : l10n.exportSelection),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ArchiveStatChip extends StatelessWidget {
  final int total;
  final AppLocalizations l10n;

  const _ArchiveStatChip({required this.total, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgAll,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.14),
        ),
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '$total',
            style: AppTextStyles.displayMedium.copyWith(
              fontSize: 26,
              height: 1,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.libraryTitle.toUpperCase(),
            textAlign: TextAlign.right,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w800,
              height: 1.2,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Carte contexte session ─────────────────────────────────────────────────

class _SessionContextCard extends StatelessWidget {
  final ActiveSession session;
  final VoidCallback onTap;
  final AppLocalizations l10n;

  const _SessionContextCard({
    required this.session,
    required this.onTap,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final c = session.client;
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.sm,
      ),
      child: ClipRRect(
        borderRadius: AppRadius.lgAll,
        child: Material(
          color: AppColors.surface,
          child: InkWell(
            onTap: onTap,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 4,
                    color: AppColors.primary,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.cardPadding,
                        vertical: AppSpacing.md,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: c.color,
                              borderRadius: AppRadius.mdAll,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              c.initials,
                              style: AppTextStyles.titleSmall.copyWith(
                                color: AppColors.textOnPrimary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.cardPadding),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        color: AppColors.success,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.sm),
                                    Expanded(
                                      child: Text(
                                        l10n.activeSession.toUpperCase(),
                                        style: AppTextStyles.labelSmall.copyWith(
                                          color: AppColors.textTertiary,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.6,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  '${l10n.sessionWith} ${c.name}',
                                  style: AppTextStyles.titleSmall.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  session.site.name,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.textTertiary,
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Dock filtres (bloc segmenté) ────────────────────────────────────────────

class _FilterDock extends StatelessWidget {
  final String? selectedClientId;
  final bool unclassifiedOnly;
  final List<Client> clientsWithProofs;
  final AppLocalizations l10n;
  final VoidCallback onSelectAll;
  final VoidCallback onSelectUnclassified;
  final ValueChanged<String> onSelectClient;

  const _FilterDock({
    required this.selectedClientId,
    required this.unclassifiedOnly,
    required this.clientsWithProofs,
    required this.l10n,
    required this.onSelectAll,
    required this.onSelectUnclassified,
    required this.onSelectClient,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: AppRadius.lgAll,
          border: Border.all(color: AppColors.border),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              _FilterPill(
                label: l10n.all,
                selected: !unclassifiedOnly && selectedClientId == null,
                onTap: onSelectAll,
                accent: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              _FilterPill(
                label: l10n.unclassified,
                selected: unclassifiedOnly,
                onTap: onSelectUnclassified,
                accent: AppColors.primary,
              ),
              ...clientsWithProofs.map((client) {
                final selected = selectedClientId == client.id;
                return Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.xs),
                  child: _FilterPill(
                    label: client.name,
                    leading: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: client.color,
                        borderRadius: AppRadius.xsAll,
                      ),
                    ),
                    selected: selected,
                    accent: client.color,
                    onTap: () => onSelectClient(client.id),
                  ),
                );
              }),
            ],
          ),
        ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color accent;
  final Widget? leading;

  const _FilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.accent,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mdAll,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.cardPadding,
            vertical: AppSpacing.sm + 2,
          ),
          decoration: BoxDecoration(
            color: selected ? AppColors.surface : Colors.transparent,
            borderRadius: AppRadius.mdAll,
            border: Border.all(
              color: selected ? accent.withValues(alpha: 0.35) : Colors.transparent,
            ),
            boxShadow: selected ? AppShadows.sm : const [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.labelMedium.copyWith(
                  color: selected ? AppColors.textPrimary : AppColors.textSecondary,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
