import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../app/routes/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/di/providers.dart';
import '../../../core/layout/app_content_layout.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/proof.dart';
import '../../context/presentation/context_picker_screen.dart';
import '../data/proof_export_service.dart';
import 'pdf_export_post_actions.dart';
import 'widgets/proof_actions_bar.dart';
import 'widgets/proof_image_preview.dart';

class ProofDetailScreen extends ConsumerStatefulWidget {
  final String proofId;

  const ProofDetailScreen({super.key, required this.proofId});

  @override
  ConsumerState<ProofDetailScreen> createState() => _ProofDetailScreenState();
}

class _ProofDetailScreenState extends ConsumerState<ProofDetailScreen> {
  bool _pdfExportBusy = false;

  Future<void> _deleteProof() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteProofTitle),
        content: Text(l10n.deleteProofMessage),
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

    if (confirmed == true && mounted) {
      final messenger = ScaffoldMessenger.of(context);
      final id = widget.proofId;
      context.pop();
      await ref.read(proofRepositoryProvider).deleteProof(id);
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.proofDeleted),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _toggleFavorite() async {
    final current = ref.read(proofRepositoryProvider).getById(widget.proofId);
    if (current != null) {
      await ref.read(proofRepositoryProvider).toggleFavorite(widget.proofId);
    }
  }

  Future<void> _shareProofImage(Proof proof) async {
    final l10n = AppLocalizations.of(context);
    try {
      final file = await ProofExportService.prepareShareableImageFile(proof);
      await Share.shareXFiles([XFile(file.path)], subject: proof.title);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.shareFailed)),
        );
      }
    }
  }

  Future<void> _exportProofImage(Proof proof) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ProofExportService.saveImageToExports(proof);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.exportImageSaved)),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.shareFailed)),
        );
      }
    }
  }

  Future<void> _shareProofPdf(
    Proof proof,
    String? clientName,
    String? siteName,
  ) async {
    if (_pdfExportBusy) return;
    _pdfExportBusy = true;
    if (mounted) setState(() {});
    final l10n = AppLocalizations.of(context);
    try {
      final labels = ProofPdfLabels.fromProof(
        proof: proof,
        l10n: l10n,
        clientName: clientName,
        siteName: siteName,
      );
      final settings = ref.read(appSettingsRepositoryProvider);
      final appearance = settings.pdfAppearancePreferences;
      final metadataMask = PdfMetadataExportMask(
        includeClient: settings.exportIncludeClient,
        includeSite: settings.exportIncludeSite,
        includeNote: settings.exportIncludeNote,
      );
      final file = await ProofExportService.writePdfToTemp(
        proof,
        labels,
        appearance: appearance,
        metadataMask: metadataMask,
      );
      if (!mounted) return;
      await runPdfPostGenerationActions(
        context: context,
        l10n: l10n,
        settings: settings,
        file: file,
        shareSubject: '${proof.title} — PDF',
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.pdfFailed)),
        );
      }
    } finally {
      _pdfExportBusy = false;
      if (mounted) setState(() {});
    }
  }

  Future<void> _editContext() async {
    final result = await context.push<ContextPickerResult?>(
      RoutePaths.contextPicker,
    );
    if (result != null && mounted) {
      final current = ref.read(proofRepositoryProvider).getById(widget.proofId);
      if (current != null) {
        final updated = current.copyWith(
          clientId: result.client.id,
          siteMissionId: result.site.id,
        );
        await ref.read(proofRepositoryProvider).updateProof(updated);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final proofListenable = ref.read(proofRepositoryListenableProvider);
    return ListenableBuilder(
      listenable: proofListenable,
      builder: (context, _) {
        final proof = ref.read(proofRepositoryProvider).getById(widget.proofId);
        return _buildScaffold(context, proof);
      },
    );
  }

  Widget _buildScaffold(BuildContext context, Proof? proof) {
    final l10n = AppLocalizations.of(context);

    if (proof == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.detail)),
        body: Center(child: Text(l10n.proofNotFound)),
      );
    }

    final clientsRepo = ref.read(clientsRepositoryProvider);
    final client = proof.clientId != null
        ? clientsRepo.getClientById(proof.clientId!)
        : null;
    final site = proof.siteMissionId != null
        ? clientsRepo.getSiteById(proof.siteMissionId!)
        : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        title: Text(l10n.proofDetailTitle, style: AppTextStyles.titleMedium),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            tooltip: l10n.favorite,
            icon: Icon(
              proof.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
              color: proof.isFavorite
                  ? AppColors.secondaryLight
                  : AppColors.textSecondary,
            ),
            onPressed: _toggleFavorite,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (value) {
              if (value == 'delete') _deleteProof();
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(Icons.delete_outline_rounded,
                        color: AppColors.error, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      l10n.delete,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppContentLayout.horizontalMargin(context),
            AppSpacing.screenPadding,
            AppContentLayout.horizontalMargin(context),
            AppContentLayout.scrollBottomInset(context),
          ),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ProofImagePreview(proof: proof),
            const SizedBox(height: AppSpacing.md),
            ProofActionsBar(
              onShare: () => _shareProofImage(proof),
              onExport: () => _exportProofImage(proof),
              onExportPdf: () => _shareProofPdf(proof, client?.name, site?.name),
              pdfExportInProgress: _pdfExportBusy,
              pdfBusyLabel: l10n.pdfGenerating,
            ),
            const SizedBox(height: AppSpacing.md),

            // Carte contexte
            _DetailCard(
              title: l10n.proofContext,
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      if (client != null) ...[
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: client.color,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            client.initials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
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
                              if (site != null)
                                Text(
                                  site.name,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ] else
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceVariant,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  l10n.unclassified,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      TextButton(
                        onPressed: _editContext,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          l10n.modifyContext,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // Carte informations
            _DetailCard(
              title: l10n.proofInformations,
              children: [
                _MetaRow(
                    icon: Icons.calendar_today_rounded,
                    label: l10n.date,
                    value: proof.overlayDateText),
                _MetaRow(
                    icon: Icons.access_time_rounded,
                    label: l10n.time,
                    value: proof.overlayTimeText),
                _MetaRow(
                    icon: Icons.location_on_rounded,
                    label: l10n.address,
                    value: proof.address ??
                        proof.overlayAddressText ??
                        l10n.addressUnavailable),
                _MetaRow(
                    icon: Icons.explore_rounded,
                    label: l10n.coordinates,
                    value: proof.latitude != null && proof.longitude != null
                        ? '${proof.latitude!.toStringAsFixed(5)}, ${proof.longitude!.toStringAsFixed(5)}'
                        : l10n.coordinatesUnavailable),
                _MetaRow(
                    icon: Icons.label_outline_rounded,
                    label: l10n.proofType,
                    value: _typeLabel(proof.proofType, l10n)),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // Carte note
            _DetailCard(
              title: l10n.note,
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: proof.description != null &&
                          proof.description!.isNotEmpty
                      ? Text(
                          proof.description!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textPrimary,
                            height: 1.5,
                          ),
                        )
                      : Text(
                          l10n.noNote,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textTertiary,
                          ),
                        ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
        ),
      ),
    );
  }

  String _typeLabel(ProofType type, AppLocalizations l10n) => switch (type) {
        ProofType.inspection => l10n.proofTypeInspection,
        ProofType.delivery => l10n.proofTypeDelivery,
        ProofType.workProgress => l10n.proofTypeWorkProgress,
        ProofType.incident => l10n.proofTypeIncident,
        ProofType.inventory => l10n.proofTypeInventory,
        ProofType.other => l10n.proofTypeOther,
      };
}

class _DetailCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _DetailCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
            child: Text(
              title,
              style: AppTextStyles.labelMedium,
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetaRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textTertiary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
