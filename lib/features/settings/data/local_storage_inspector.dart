import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../../core/utils/file_utils.dart';

/// Estimation des tailles locales (best-effort, non bloquant pour l’UI).
abstract final class LocalStorageInspector {
  static Future<int> _dirBytes(Directory dir) async {
    var total = 0;
    try {
      if (!await dir.exists()) return 0;
      await for (final entity in dir.list(recursive: true, followLinks: false)) {
        if (entity is File) {
          try {
            total += await entity.length();
          } catch (_) {}
        }
      }
    } catch (_) {}
    return total;
  }

  static Future<int> proofsDataBytes() async {
    final path = await FileUtils.proofsDirectoryPath;
    return _dirBytes(Directory(path));
  }

  static Future<int> exportsSavedBytes() async {
    final path = await FileUtils.exportsDirectoryPath;
    return _dirBytes(Directory(path));
  }

  static Future<int> tempStampsightPdfBytes() async {
    final tmp = await getTemporaryDirectory();
    var total = 0;
    try {
      await for (final entity in tmp.list(followLinks: false)) {
        if (entity is File) {
          final name = entity.path.split(Platform.pathSeparator).last;
          if (name.startsWith('stampsight_') && name.endsWith('.pdf')) {
            try {
              total += await entity.length();
            } catch (_) {}
          }
        }
      }
    } catch (_) {}
    return total;
  }

  static Future<int> cacheEstimateBytes() async {
    final tmp = await getTemporaryDirectory();
    return _dirBytes(tmp);
  }

  static Future<int> deleteTempStampsightPdfs() async {
    final tmp = await getTemporaryDirectory();
    var n = 0;
    try {
      await for (final entity in tmp.list(followLinks: false)) {
        if (entity is File) {
          final name = entity.path.split(Platform.pathSeparator).last;
          if (name.startsWith('stampsight_') && name.endsWith('.pdf')) {
            try {
              await entity.delete();
              n++;
            } catch (_) {}
          }
        }
      }
    } catch (_) {}
    return n;
  }

  static Future<void> clearAppTempCacheBestEffort() async {
    final tmp = await getTemporaryDirectory();
    try {
      await for (final entity in tmp.list(followLinks: false)) {
        if (entity is File) {
          final name = entity.path.split(Platform.pathSeparator).last;
          if (name.startsWith('stampsight_') ||
              name.startsWith('flutter_') ||
              name.startsWith('.')) {
            try {
              await entity.delete();
            } catch (_) {}
          }
        }
      }
    } catch (_) {}
  }
}
