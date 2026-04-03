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
import '../../../core/layout/app_content_layout.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/client.dart';

class ClientsListScreen extends ConsumerStatefulWidget {
  const ClientsListScreen({super.key});

  @override
  ConsumerState<ClientsListScreen> createState() => _ClientsListScreenState();
}

class _ClientsListScreenState extends ConsumerState<ClientsListScreen> {
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
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final clients = ref.watch(clientsRepositoryProvider).clients;

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
          SliverAppBar.large(
            pinned: true,
            stretch: true,
            backgroundColor: AppColors.background,
            surfaceTintColor: Colors.transparent,
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.clientsTitle,
                    style: AppTextStyles.displayMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (clients.isNotEmpty) ...[
                  const SizedBox(width: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: AppRadius.fullAll,
                    ),
                    child: Text(
                      '${clients.length}',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: IconButton(
                  icon: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: AppRadius.mdAll,
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: AppColors.textOnPrimary,
                      size: 20,
                    ),
                  ),
                  onPressed: () => context.push(RoutePaths.clientNew),
                ),
              ),
            ],
          ),
          if (clients.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyClients(
                l10n: l10n,
                onAddFirstClient: () => context.push(RoutePaths.clientNew),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                0,
                AppSpacing.sm,
                0,
                AppSpacing.xl,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final client = clients[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index < clients.length - 1 ? AppSpacing.sm : 0,
                      ),
                      child: _ClientListTile(
                        client: client,
                        siteCount: ref
                            .read(clientsRepositoryProvider)
                            .sitesForClient(client.id)
                            .length,
                        onTap: () => context.push(
                              RoutePaths.clientDetailFor(client.id),
                            ),
                        onDelete: () => _confirmDeleteClient(client),
                      ),
                    );
                  },
                  childCount: clients.length,
                ),
              ),
            ),
        ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(
        currentTab: AppBottomNavTab.clients,
      ),
    );
  }
}

// ─── Tile client ─────────────────────────────────────────────────────────────

class _ClientListTile extends StatelessWidget {
  final Client client;
  final int siteCount;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ClientListTile({
    required this.client,
    required this.siteCount,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: client.color,
                      borderRadius: AppRadius.mdAll,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      client.initials,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.textOnPrimary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.cardPadding),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          client.name,
                          style: AppTextStyles.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (client.company != null)
                          Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.xxs),
                            child: Text(
                              client.company!,
                              style: AppTextStyles.bodyMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xs),
                          child: Text(
                            l10n.siteCount(siteCount),
                            style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.more_vert_rounded,
              color: AppColors.textTertiary,
              size: 20,
            ),
            onSelected: (value) {
              if (value == 'delete') onDelete();
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'delete',
                child: Text(
                  l10n.deleteClient,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: onTap,
            child: const Padding(
              padding: EdgeInsets.only(left: AppSpacing.xxs),
              child: Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textTertiary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── État vide ───────────────────────────────────────────────────────────────

class _EmptyClients extends StatelessWidget {
  final AppLocalizations l10n;
  final VoidCallback onAddFirstClient;

  const _EmptyClients({
    required this.l10n,
    required this.onAddFirstClient,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.xxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                    Icons.people_outline_rounded,
                    size: 26,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.noClients,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: Text(
                l10n.emptyClientsSubtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton.icon(
              onPressed: () => onAddFirstClient(),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(l10n.addFirstClient),
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
          ],
        ),
      ),
    );
  }
}
