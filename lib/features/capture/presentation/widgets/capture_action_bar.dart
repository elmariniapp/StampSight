import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

class CaptureActionBar extends StatelessWidget {
  final VoidCallback onCapture;
  final VoidCallback onImport;

  const CaptureActionBar({
    super.key,
    required this.onCapture,
    required this.onImport,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.screenPadding,
        right: AppSpacing.screenPadding,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.md,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onImport,
              icon: const Icon(Icons.photo_library_rounded, size: 20),
              label: Text(l10n.importAction),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: onCapture,
              icon: const Icon(Icons.camera_alt_rounded, size: 20),
              label: Text(l10n.capture),
            ),
          ),
        ],
      ),
    );
  }
}
