import 'dart:io';
import 'package:path_provider/path_provider.dart';

abstract final class FileUtils {
  static Future<String> get appDocumentsPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  static Future<String> get proofsDirectoryPath async {
    final basePath = await appDocumentsPath;
    final dir = Directory('$basePath/proofs');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir.path;
  }

  static Future<String> get exportsDirectoryPath async {
    final basePath = await appDocumentsPath;
    final dir = Directory('$basePath/stampsight_exports');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir.path;
  }

  static String fileNameFromPath(String path) {
    return path.split(Platform.pathSeparator).last;
  }

  static String fileExtension(String path) {
    final parts = path.split('.');
    return parts.length > 1 ? parts.last.toLowerCase() : '';
  }
}
