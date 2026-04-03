import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/di/providers.dart';
import '../../../core/layout/app_content_layout.dart';
import '../../../l10n/app_localizations.dart';
import '../../clients/domain/client.dart';
import '../../clients/domain/site_mission.dart';
import '../../session/domain/active_session.dart';
import '../../session/presentation/active_session_start_helper.dart';

class ContextPickerResult {
  final Client client;
  final SiteMission site;
  const ContextPickerResult({required this.client, required this.site});
}

class ContextPickerScreen extends ConsumerStatefulWidget {
  const ContextPickerScreen({super.key});

  @override
  ConsumerState<ContextPickerScreen> createState() =>
      _ContextPickerScreenState();
}

class _ContextPickerScreenState extends ConsumerState<ContextPickerScreen> {
  Client? _selectedClient;
  SiteMission? _selectedSite;
  String _search = '';

  List<Client> get _filteredClients {
    final clients = ref.read(clientsRepositoryProvider).clients;
    if (_search.isEmpty) return clients;
    final q = _search.toLowerCase();
    return clients.where((c) {
      return c.name.toLowerCase().contains(q) ||
          (c.company?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  List<SiteMission> get _sitesForSelected {
    if (_selectedClient == null) return [];
    return ref
        .read(clientsRepositoryProvider)
        .sitesForClient(_selectedClient!.id);
  }

  void _onClientSelected(Client client) {
    setState(() {
      _selectedClient = client;
      _selectedSite = null;
      _search = '';
    });
  }

  void _onSiteSelected(SiteMission site) {
    setState(() => _selectedSite = site);
  }

  Future<void> _validate() async {
    final client = _selectedClient;
    final site = _selectedSite;
    if (client == null || site == null) return;

    await startActiveSessionWithOptionalConfirmation(
      context: context,
      ref: ref,
      session: ActiveSession(client: client, site: site),
    );
    if (!mounted) return;
    final sess = ref.read(activeSessionRepositoryProvider).currentSession;
    if (sess != null &&
        sess.client.id == client.id &&
        sess.site.id == site.id) {
      context.pop(ContextPickerResult(client: client, site: site));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        title: Text(
          l10n.context,
          style: AppTextStyles.titleMedium,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(null),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(null),
            child: Text(
              l10n.skip,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppContentLayout.maxContentWidth,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
          if (_selectedClient == null) ...[
            // Étape 1 : choix client
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.sm,
                AppSpacing.screenPadding,
                0,
              ),
              child: Text(
                l10n.chooseClient,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.sm,
                AppSpacing.screenPadding,
                AppSpacing.sm,
              ),
              child: TextField(
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Rechercher…',
                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textTertiary,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    size: 18,
                    color: AppColors.textTertiary,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                onChanged: (v) => setState(() => _search = v),
              ),
            ),
            Expanded(
              child: _filteredClients.isEmpty
                  ? _EmptyClients(l10n: l10n)
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPadding,
                      ),
                      itemCount: _filteredClients.length,
                      separatorBuilder: (_, i) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final client = _filteredClients[index];
                        return _ClientTile(
                          client: client,
                          siteCount: ref
                              .read(clientsRepositoryProvider)
                              .sitesForClient(client.id)
                              .length,
                          onTap: () => _onClientSelected(client),
                        );
                      },
                    ),
            ),
          ] else ...[
            // Étape 2 : choix site
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.sm,
                AppSpacing.screenPadding,
                0,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () =>
                        setState(() => _selectedClient = null),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      size: 18,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${l10n.siteForClient} ${_selectedClient!.name}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: _sitesForSelected.isEmpty
                  ? _EmptySites(
                      clientId: _selectedClient!.id,
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPadding,
                      ),
                      itemCount: _sitesForSelected.length,
                      separatorBuilder: (_, i) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final site = _sitesForSelected[index];
                        return _SiteTile(
                          site: site,
                          selected: _selectedSite?.id == site.id,
                          onTap: () => _onSiteSelected(site),
                        );
                      },
                    ),
            ),
            // Bouton valider
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.sm,
                AppSpacing.screenPadding,
                MediaQuery.of(context).padding.bottom + AppSpacing.md,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedSite != null ? _validate : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.border,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.validate,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ClientTile extends StatelessWidget {
  final Client client;
  final int siteCount;
  final VoidCallback onTap;

  const _ClientTile({
    required this.client,
    required this.siteCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: client.color,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                client.initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    client.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (client.company != null)
                    Text(
                      client.company!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  Text(
                    l10n.siteCount(siteCount),
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

class _SiteTile extends StatelessWidget {
  final SiteMission site;
  final bool selected;
  final VoidCallback onTap;

  const _SiteTile({
    required this.site,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.04)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.location_on_rounded,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    site.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (site.address != null)
                    Text(
                      site.address!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _SiteTypeBadge(type: site.type),
            if (selected) ...[
              const SizedBox(width: 8),
              const Icon(
                Icons.check_circle_rounded,
                size: 18,
                color: AppColors.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SiteTypeBadge extends StatelessWidget {
  final SiteMissionType type;
  const _SiteTypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        _label(type, l10n),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
    );
  }

  String _label(SiteMissionType type, AppLocalizations l10n) => switch (type) {
        SiteMissionType.intervention => l10n.siteTypeIntervention,
        SiteMissionType.maintenance => l10n.siteTypeMaintenance,
        SiteMissionType.delivery => l10n.siteTypeDelivery,
        SiteMissionType.control => l10n.siteTypeControl,
        SiteMissionType.other => l10n.siteTypeOther,
      };
}

class _EmptyClients extends StatelessWidget {
  final AppLocalizations l10n;
  const _EmptyClients({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.people_outline, size: 40, color: AppColors.textTertiary),
          const SizedBox(height: 12),
          Text(l10n.noClients, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}

class _EmptySites extends StatelessWidget {
  final String clientId;
  const _EmptySites({required this.clientId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_off_rounded,
              size: 40, color: AppColors.textTertiary),
          const SizedBox(height: 12),
          Text(l10n.noSitesForClient, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}
