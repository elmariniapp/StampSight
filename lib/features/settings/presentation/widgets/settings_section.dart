import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.sm,
            AppSpacing.screenPadding,
            AppSpacing.sm,
          ),
          child: Row(
            children: [
              Text(
                title.toUpperCase(),
                style: AppTextStyles.labelSmall.copyWith(
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              const Expanded(
                child: Divider(
                  color: AppColors.border,
                  thickness: 1,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
            bottom: AppSpacing.md,
            left: AppSpacing.screenPadding,
            right: AppSpacing.screenPadding,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.lgAll,
            border: Border.all(color: AppColors.border),
            boxShadow: AppShadows.sm,
          ),
          child: ClipRRect(
            borderRadius: AppRadius.lgAll,
            child: Column(
              children: [
                for (int i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i < children.length - 1)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.divider,
                      indent: AppSpacing.screenPadding,
                    ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
