import 'package:flutter/material.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/capture_overlay_preset.dart';

class CapturePreviewCard extends StatelessWidget {
  final CaptureOverlayPreset preset;

  const CapturePreviewCard({super.key, required this.preset});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();

    return Container(
      width: double.infinity,
      height: 280,
      decoration: BoxDecoration(
        color: const Color(0xFF2C3E50),
        borderRadius: AppRadius.lgAll,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.camera_alt_rounded,
                  size: 48,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.cameraPreview,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: AppSpacing.md,
            bottom: AppSpacing.md,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: AppRadius.smAll,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (preset.showDate)
                    Text(
                      DateFormatters.overlayDate(now, l10n.languageCode),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'monospace',
                      ),
                    ),
                  if (preset.showTime)
                    Text(
                      DateFormatters.overlayTime(now),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'monospace',
                      ),
                    ),
                  if (preset.showAddress)
                    Text(
                      '12 Rue de la Paix, Paris',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 10,
                        fontFamily: 'monospace',
                      ),
                    ),
                  if (preset.showCoordinates)
                    Text(
                      '48.8698°N, 2.3302°E',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 9,
                        fontFamily: 'monospace',
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
