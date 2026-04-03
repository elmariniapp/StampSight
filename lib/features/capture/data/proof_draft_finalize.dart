import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import '../../../core/utils/id_generator.dart';

/// Suppression best-effort (logs en debug si échec).
Future<void> deleteFilesBestEffort(Iterable<String> paths) async {
  for (final path in paths) {
    try {
      final f = File(path);
      if (await f.exists()) await f.delete();
    } catch (e, st) {
      debugPrint('StampSight: deleteFilesBestEffort $path — $e\n$st');
    }
  }
}

/// Copie un fichier brouillon vers un nom final stable (sans supprimer le brouillon).
Future<String> copyDraftToFinalPath(String draftPath) async {
  final src = File(draftPath);
  if (!await src.exists()) {
    throw StateError('Missing draft file: $draftPath');
  }
  final dir = p.dirname(draftPath);
  final ext = p.extension(draftPath);
  final safeExt = ext.isNotEmpty ? ext : '.jpg';
  final dest = p.join(dir, '${IdGenerator.generate()}$safeExt');
  await src.copy(dest);
  return dest;
}

/// Copie chaque brouillon vers un chemin final, appelle [persist], puis supprime les brouillons.
/// En cas d’échec lors de la copie : nettoie les fichiers déjà promus.
/// En cas d’échec de [persist] : nettoie les fichiers promus ; les brouillons restent intacts (nouvel essai possible).
Future<void> commitDraftImages({
  required List<String> draftPathsOrdered,
  required Future<void> Function(String mainPath, List<String> additionalPaths)
      persist,
}) async {
  if (draftPathsOrdered.isEmpty) {
    throw ArgumentError('draftPathsOrdered ne doit pas être vide');
  }
  final staged = <String>[];
  try {
    for (final d in draftPathsOrdered) {
      staged.add(await copyDraftToFinalPath(d));
    }
  } catch (e, st) {
    debugPrint('StampSight: commitDraftImages — échec copie — $e\n$st');
    await deleteFilesBestEffort(staged);
    rethrow;
  }
  try {
    await persist(
      staged.first,
      staged.length > 1 ? staged.sublist(1) : const <String>[],
    );
  } catch (e, st) {
    debugPrint('StampSight: commitDraftImages — échec persistance — $e\n$st');
    await deleteFilesBestEffort(staged);
    rethrow;
  }
  await deleteFilesBestEffort(draftPathsOrdered);
}
