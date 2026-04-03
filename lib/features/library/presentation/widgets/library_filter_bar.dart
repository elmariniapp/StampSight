import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../proofs/domain/proof.dart';

class LibraryFilterBar extends StatelessWidget {
  final ProofType? selectedType;
  final ValueChanged<ProofType?> onFilterChanged;

  const LibraryFilterBar({
    super.key,
    this.selectedType,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
          vertical: AppSpacing.sm,
        ),
        children: [
          _FilterChip(
            label: l10n.all,
            isSelected: selectedType == null,
            onTap: () => onFilterChanged(null),
          ),
          ...ProofType.values.map((type) => Padding(
                padding: const EdgeInsets.only(left: AppSpacing.sm),
                child: _FilterChip(
                  label: _labelForType(type, l10n),
                  isSelected: selectedType == type,
                  onTap: () => onFilterChanged(type),
                ),
              )),
        ],
      ),
    );
  }

  String _labelForType(ProofType type, AppLocalizations l10n) {
    return switch (type) {
      ProofType.inspection => l10n.proofTypeInspection,
      ProofType.delivery => l10n.proofTypeDelivery,
      ProofType.workProgress => l10n.proofTypeWorkProgress,
      ProofType.incident => l10n.proofTypeIncident,
      ProofType.inventory => l10n.proofTypeInventory,
      ProofType.other => l10n.proofTypeOther,
    };
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF64748B),
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
