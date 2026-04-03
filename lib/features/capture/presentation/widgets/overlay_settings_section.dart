import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/capture_overlay_preset.dart';

class OverlaySettingsSection extends StatelessWidget {
  final CaptureOverlayPreset preset;
  final ValueChanged<CaptureOverlayPreset> onPresetChanged;

  const OverlaySettingsSection({
    super.key,
    required this.preset,
    required this.onPresetChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.overlay, style: AppTextStyles.titleMedium),
          const SizedBox(height: AppSpacing.md),
          _ToggleTile(
            label: l10n.date,
            icon: Icons.calendar_today_rounded,
            value: preset.showDate,
            onChanged: (v) => onPresetChanged(preset.copyWith(showDate: v)),
          ),
          _ToggleTile(
            label: l10n.time,
            icon: Icons.access_time_rounded,
            value: preset.showTime,
            onChanged: (v) => onPresetChanged(preset.copyWith(showTime: v)),
          ),
          _ToggleTile(
            label: l10n.address,
            icon: Icons.location_on_rounded,
            value: preset.showAddress,
            onChanged: (v) =>
                onPresetChanged(preset.copyWith(showAddress: v)),
          ),
          _ToggleTile(
            label: l10n.gpsCoordinates,
            icon: Icons.explore_rounded,
            value: preset.showCoordinates,
            onChanged: (v) =>
                onPresetChanged(preset.copyWith(showCoordinates: v)),
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showDivider;

  const _ToggleTile({
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.textSecondary),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Text(label, style: AppTextStyles.bodyLarge)),
              Switch.adaptive(
                value: value,
                onChanged: onChanged,
                activeTrackColor: AppColors.primary,
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1),
      ],
    );
  }
}
