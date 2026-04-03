import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';

import '../../../l10n/app_localizations.dart';
import '../../settings/data/app_settings_repository.dart';

/// Après génération d’un PDF : ouvrir / partager / feedback fichier, sans actions concurrentes.
Future<void> runPdfPostGenerationActions({
  required BuildContext context,
  required AppLocalizations l10n,
  required AppSettingsRepository settings,
  required File file,
  String? shareSubject,
}) async {
  final open = settings.openPdfAfterGeneration;
  final share = settings.proposeShareAfterPdf;

  if (open && share) {
    await OpenFile.open(file.path);
    if (!context.mounted) return;
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: shareSubject,
    );
  } else if (open) {
    await OpenFile.open(file.path);
  } else if (share) {
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: shareSubject,
    );
  } else {
    final name = p.basename(file.path);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.pdfExportSavedToPath(name))),
    );
  }
}
