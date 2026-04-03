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
import '../data/client_deletion.dart';
import '../../settings/data/app_settings_repository.dart';
import '../../session/presentation/active_session_start_helper.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/client.dart';
import '../domain/site_mission.dart';
import '../../session/domain/active_session.dart';
import '../../session/presentation/active_session_sheet.dart';

class ClientDetailScreen extends ConsumerStatefulWidget {
  final String clientId;

  const ClientDetailScreen({super.key, required this.clientId});

  @override
  ConsumerState<ClientDetailScreen> createState() =>
      _ClientDetailScreenState();
}

class _ClientDetailScreenState extends ConsumerState<ClientDetailScreen> {
  Client? _client() =>
      ref.read(clientsRepositoryProvider).getClientById(widget.clientId);

  List<SiteMission> _sites() =>
      ref.read(clientsRepositoryProvider).sitesForClient(widget.clientId);

  Future<void> _confirmDeleteClient(Client client) async {
    final l10n = AppLocalizations.of(context);
    final settings = ref.read(appSettingsRepositoryProvider);
    final clients = ref.read(clientsRepositoryProvider);
    final proofs = ref.read(proofRepositoryProvider);
    final session = ref.read(activeSessionRepositoryProvider);

    final analysis = analyzeClientDeletion(
      clients,
      proofs,
      session,
      client.id,
    );

    if (settings.clientDeletePolicy == ClientDeletePolicySetting.block &&
        analysis.hasBlockingDependencies) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.clientDeleteBlockedTitle),
          content: Text(
            l10n.clientDeleteBlockedBody(
              analysis.linkedSiteCount,
              analysis.linkedProofCount,
              analysis.activeSessionUsesClient,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.close),
            ),
          ],
        ),
      );
      return;
    }

    var go = true;
    if (settings.confirmBeforeClientDelete) {
      final impact = l10n.clientDeleteImpactLines(
        analysis.linkedSiteCount,
        analysis.linkedProofCount,
        analysis.activeSessionUsesClient,
      );
      final body = impact.isEmpty
          ? l10n.deleteClientConfirmBody
          : '${l10n.deleteClientConfirmBody}\n\n$impact';
      final result = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.deleteClientConfirmTitle),
          content: Text(body),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: Text(l10n.delete),
            ),
          ],
        ),
      );
      go = result == true;
    }
    if (!go || !mounted) return;

    final del = await executeClientDeletion(ref, client.id);
    if (!mounted) return;
    if (del == ClientDeletionResult.blocked) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.clientDeleted)),
    );
    context.pop();
  }

  Future<void> _startSession(Client client) async {
    final sites = _sites();
    if (sites.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).noSitesForClient),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (sites.length == 1) {
      await startActiveSessionWithOptionalConfirmation(
        context: context,
        ref: ref,
        session: ActiveSession(client: client, site: sites.first),
      );
      if (!mounted) return;
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const ActiveSessionSheet(),
      );
    } else {
      context.push(RoutePaths.contextPicker);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final client = _client();

    if (client == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Text(
              l10n.clientNotFound,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final sites = _sites();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        title: Text(client.name, style: AppTextStyles.titleMedium),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await context.push(RoutePaths.clientEditFor(client.id));
              setState(() {});
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.accent,
            ),
            child: Text(
              l10n.editClient,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.accent,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête client
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              decoration: BoxDecoration(
                color: client.color.withValues(alpha: 0.06),
                borderRadius: AppRadius.lgAll,
                border: Border.all(
                  color: client.color.withValues(alpha: 0.15),
                ),
                boxShadow: AppShadows.sm,
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: client.color,
                      borderRadius: AppRadius.lgAll,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      client.initials,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.textOnPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          client.name,
                          style: AppTextStyles.titleMedium,
                        ),
                        if (client.company != null) ...[
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            client.company!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                        if (client.note != null) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            client.note!,
                            style: AppTextStyles.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // CTA Session
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _startSession(client),
                icon: const Icon(Icons.play_circle_outline_rounded, size: 20),
                label: Text(l10n.startSessionWith),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.mdAll,
                  ),
                  elevation: 0,
                  textStyle: AppTextStyles.button.copyWith(
                    color: AppColors.textOnPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Section Sites
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    l10n.sitesAndMissions,
                    style: AppTextStyles.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    await context.push(
                      '${RoutePaths.siteNew}?clientId=${client.id}',
                    );
                    setState(() {});
                  },
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: Text(
                    l10n.addSite,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.accent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            if (sites.isEmpty)
              _EmptySites(
                l10n: l10n,
                clientId: client.id,
                onAdd: () async {
                  await context.push(
                      '${RoutePaths.siteNew}?clientId=${client.id}');
                  setState(() {});
                },
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sites.length,
                separatorBuilder: (_, i) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final site = sites[index];
                  return _SiteTile(
                    site: site,
                    onTap: () async {
                      await context
                          .push(RoutePaths.siteEditFor(site.id));
                      setState(() {});
                    },
                  );
                },
              ),

            const SizedBox(height: AppSpacing.xxl),

            // Suppression (secondaire, explicite)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _confirmDeleteClient(client),
                icon: Icon(
                  Icons.delete_outline_rounded,
                  size: 20,
                  color: AppColors.error.withValues(alpha: 0.9),
                ),
                label: Text(
                  l10n.deleteClient,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.error,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: BorderSide(
                    color: AppColors.error.withValues(alpha: 0.35),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.mdAll,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _SiteTile extends StatelessWidget {
  final SiteMission site;
  final VoidCallback onTap;

  const _SiteTile({required this.site, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.mdAll,
          border: Border.all(color: AppColors.border),
          boxShadow: AppShadows.sm,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: AppRadius.smAll,
              ),
              child: const Icon(
                Icons.location_on_rounded,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: AppSpacing.cardPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    site.name,
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (site.address != null) ...[
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      site.address!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            _TypeBadge(type: site.type, l10n: l10n),
          ],
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final SiteMissionType type;
  final AppLocalizations l10n;

  const _TypeBadge({required this.type, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: AppRadius.smAll,
      ),
      child: Text(
        _label(type),
        style: AppTextStyles.badge.copyWith(
          color: AppColors.primary,
          fontSize: 10,
        ),
      ),
    );
  }

  String _label(SiteMissionType type) => switch (type) {
        SiteMissionType.intervention => l10n.siteTypeIntervention,
        SiteMissionType.maintenance => l10n.siteTypeMaintenance,
        SiteMissionType.delivery => l10n.siteTypeDelivery,
        SiteMissionType.control => l10n.siteTypeControl,
        SiteMissionType.other => l10n.siteTypeOther,
      };
}

class _EmptySites extends StatelessWidget {
  final AppLocalizations l10n;
  final String clientId;
  final VoidCallback onAdd;

  const _EmptySites({
    required this.l10n,
    required this.clientId,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xl,
        horizontal: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.location_off_rounded,
            size: 32,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.noSitesForClient,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: Text(
              l10n.addSite,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.accent,
              ),
            ),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}
