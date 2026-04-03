import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';

class SettingsLegalPlaceholderPage extends StatelessWidget {
  final String titleKey;

  const SettingsLegalPlaceholderPage({super.key, required this.titleKey});

  static const int _faqCount = 15;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = switch (titleKey) {
      'faq' => l10n.settingsFaq,
      'terms' => l10n.termsOfService,
      'privacy' => l10n.privacyPolicy,
      _ => l10n.settingsLegalPlaceholder,
    };

    if (titleKey == 'faq') {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          surfaceTintColor: Colors.transparent,
          title: Text(title),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            0,
            AppSpacing.screenPadding,
            AppSpacing.xxl,
          ),
          itemCount: _faqCount,
          itemBuilder: (context, index) {
            final i = index + 1;
            final question = l10n.faqQuestion(i);
            if (question.isEmpty) return const SizedBox.shrink();
            return ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: Text(
                question,
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Text(
                      l10n.faqAnswer(i),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Text(
          l10n.settingsLegalPlaceholder,
          style: const TextStyle(height: 1.5),
        ),
      ),
    );
  }
}
