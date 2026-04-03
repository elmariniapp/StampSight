import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../l10n/app_localizations.dart';

class ProofActionsBar extends StatelessWidget {
  final VoidCallback onShare;
  final VoidCallback onExport;
  final VoidCallback onExportPdf;
  final bool pdfExportInProgress;
  final String? pdfBusyLabel;

  const ProofActionsBar({
    super.key,
    required this.onShare,
    required this.onExport,
    required this.onExportPdf,
    this.pdfExportInProgress = false,
    this.pdfBusyLabel,
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
      ),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              icon: Icons.share_rounded,
              label: l10n.shareProofCoverPhoto,
              onTap: onShare,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _ActionButton(
              icon: Icons.download_rounded,
              label: l10n.exportProofCoverPhoto,
              onTap: onExport,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _ActionButton(
              icon: Icons.picture_as_pdf_rounded,
              label: l10n.exportPdf,
              busyLabel: pdfBusyLabel,
              onTap: pdfExportInProgress ? null : onExportPdf,
              busy: pdfExportInProgress,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? busyLabel;
  final VoidCallback? onTap;
  final bool busy;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.busyLabel,
    required this.onTap,
    this.busy = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = AppColors.textSecondary;
    final effectiveColor =
        busy ? buttonColor.withValues(alpha: 0.45) : buttonColor;
    return InkWell(
      onTap: busy ? null : onTap,
      borderRadius: AppRadius.mdAll,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Column(
          children: [
            if (busy)
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: effectiveColor,
                ),
              )
            else
              Icon(icon, color: effectiveColor, size: 22),
            const SizedBox(height: AppSpacing.xs),
            Text(
              busy ? (busyLabel ?? label) : label,
              style: TextStyle(
                fontSize: 11,
                color: effectiveColor,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
