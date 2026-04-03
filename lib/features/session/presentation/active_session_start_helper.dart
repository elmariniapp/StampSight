import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/active_session.dart';

/// Remplace la session active avec confirmation optionnelle selon les réglages.
Future<void> startActiveSessionWithOptionalConfirmation({
  required BuildContext context,
  required WidgetRef ref,
  required ActiveSession session,
}) async {
  final settings = ref.read(appSettingsRepositoryProvider);
  final repo = ref.read(activeSessionRepositoryProvider);
  final current = repo.currentSession;

  if (current != null &&
      current.client.id == session.client.id &&
      current.site.id == session.site.id) {
    return;
  }

  if (current == null) {
    repo.startSession(session);
    return;
  }

  if (!settings.confirmBeforeSessionChange) {
    repo.startSession(session);
    return;
  }

  final l10n = AppLocalizations.of(context);
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.sessionReplaceConfirmTitle),
      content: Text(l10n.sessionReplaceConfirmBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(l10n.sessionReplaceConfirmAction),
        ),
      ],
    ),
  );
  if (ok == true) {
    repo.startSession(session);
  }
}
