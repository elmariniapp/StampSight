import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../proofs/domain/proof.dart';

class RecentProofsSection extends StatelessWidget {
  final List<Proof> proofs;
  final void Function(Proof) onProofTap;
  final VoidCallback onViewAll;

  const RecentProofsSection({
    super.key,
    required this.proofs,
    required this.onProofTap,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (proofs.isEmpty) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.recentProofs,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              TextButton(
                onPressed: onViewAll,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.accent,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  l10n.viewAll,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 65,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding),
            itemCount: proofs.length,
            separatorBuilder: (_, _) => const SizedBox(width: 7),
            itemBuilder: (context, index) {
              final proof = proofs[index];
              return _RecentProofCard(
                proof: proof,
                onTap: () => onProofTap(proof),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RecentProofCard extends StatelessWidget {
  final Proof proof;
  final VoidCallback onTap;

  const _RecentProofCard({required this.proof, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 95,
        height: 65,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: _colorForType(proof.proofType),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                proof.overlayDateText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 7,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _colorForType(ProofType type) {
    return switch (type) {
      ProofType.inspection => AppColors.categoryInspection,
      ProofType.delivery    => AppColors.categoryDelivery,
      ProofType.workProgress => AppColors.categoryProgress,
      ProofType.incident    => AppColors.categoryIncident,
      ProofType.inventory   => AppColors.categoryInventory,
      ProofType.other       => AppColors.categoryOther,
    };
  }
}
