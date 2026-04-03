import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/storage_keys.dart';
import '../../proofs/data/proof_export_service.dart';

/// Qualité JPEG / capture (préparé pour futur pipeline).
enum PhotoQualitySetting { standard, high, max }

/// Compression d’image export / stockage.
enum ImageCompressionSetting { low, medium, high }

enum TimeZoneModeSetting { automatic, manual }

enum PdfReportStyleSetting { standard, premium }

enum ExportSortOrderSetting { newestFirst, oldestFirst }

/// Politique de suppression client (préparé ; cœur métier à compléter).
enum ClientDeletePolicySetting { block, detachProofs, deleteLinkedSites }

/// Dépôt central des préférences produit (SharedPreferences).
class AppSettingsRepository extends ChangeNotifier {
  AppSettingsRepository._();
  static final AppSettingsRepository instance = AppSettingsRepository._();

  SharedPreferences? _prefs;
  bool _loaded = false;

  Future<SharedPreferences> get _p async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<void> ensureLoaded() async {
    if (_loaded) return;
    await _p;
    _loaded = true;
    notifyListeners();
  }

  // ——— Date / heure (existant) ———
  String get dateFormat =>
      _prefs?.getString(StorageKeys.dateFormat) ??
      AppConstants.defaultDateFormat;

  Future<void> setDateFormat(String value) async {
    final p = await _p;
    await p.setString(StorageKeys.dateFormat, value);
    notifyListeners();
  }

  /// Motif intl : `HH:mm` ou `h:mm a`
  String get timeFormat =>
      _prefs?.getString(StorageKeys.timeFormat) ??
      AppConstants.defaultTimeFormat;

  Future<void> setTimeFormat(String value) async {
    final p = await _p;
    await p.setString(StorageKeys.timeFormat, value);
    notifyListeners();
  }

  Future<String> getDefaultProofType() async {
    final p = await _p;
    return p.getString(StorageKeys.defaultProofType) ?? 'other';
  }

  Future<void> setDefaultProofType(String type) async {
    final p = await _p;
    await p.setString(StorageKeys.defaultProofType, type);
    notifyListeners();
  }

  // ——— Fuseau ———
  TimeZoneModeSetting get timeZoneMode {
    final v = _prefs?.getString(StorageKeys.timeZoneMode);
    return v == 'manual'
        ? TimeZoneModeSetting.manual
        : TimeZoneModeSetting.automatic;
  }

  Future<void> setTimeZoneMode(TimeZoneModeSetting mode) async {
    final p = await _p;
    await p.setString(
      StorageKeys.timeZoneMode,
      mode == TimeZoneModeSetting.manual ? 'manual' : 'auto',
    );
    notifyListeners();
  }

  // ——— Capture ———
  PhotoQualitySetting get photoQuality {
    final v = _prefs?.getString(StorageKeys.photoQuality) ?? 'standard';
    return PhotoQualitySetting.values.firstWhere(
      (e) => e.name == v,
      orElse: () => PhotoQualitySetting.standard,
    );
  }

  Future<void> setPhotoQuality(PhotoQualitySetting q) async {
    final p = await _p;
    await p.setString(StorageKeys.photoQuality, q.name);
    notifyListeners();
  }

  ImageCompressionSetting get imageCompression {
    final v = _prefs?.getString(StorageKeys.imageCompression) ?? 'medium';
    return ImageCompressionSetting.values.firstWhere(
      (e) => e.name == v,
      orElse: () => ImageCompressionSetting.medium,
    );
  }

  Future<void> setImageCompression(ImageCompressionSetting v) async {
    final p = await _p;
    await p.setString(StorageKeys.imageCompression, v.name);
    notifyListeners();
  }

  bool get openCameraDirectlyFromNewProof =>
      _prefs?.getBool(StorageKeys.openCameraFromNewProof) ?? true;

  Future<void> setOpenCameraDirectlyFromNewProof(bool v) async {
    final p = await _p;
    await p.setBool(StorageKeys.openCameraFromNewProof, v);
    notifyListeners();
  }

  bool get cameraGridEnabled =>
      _prefs?.getBool(StorageKeys.cameraGridEnabled) ?? false;

  Future<void> setCameraGridEnabled(bool v) async {
    final p = await _p;
    await p.setBool(StorageKeys.cameraGridEnabled, v);
    notifyListeners();
  }

  bool get multiPhotoPromptEnabled =>
      _prefs?.getBool(StorageKeys.multiPhotoPromptEnabled) ?? true;

  Future<void> setMultiPhotoPromptEnabled(bool v) async {
    final p = await _p;
    await p.setBool(StorageKeys.multiPhotoPromptEnabled, v);
    notifyListeners();
  }

  bool get persistCaptureChoices =>
      _prefs?.getBool(StorageKeys.persistCaptureChoices) ?? true;

  Future<void> setPersistCaptureChoices(bool v) async {
    final p = await _p;
    await p.setBool(StorageKeys.persistCaptureChoices, v);
    notifyListeners();
  }

  // ——— Métadonnées export (hors overlay capture) ———
  bool get exportIncludeClient =>
      _prefs?.getBool(StorageKeys.exportIncludeClient) ?? true;

  Future<void> setExportIncludeClient(bool v) async {
    final p = await _p;
    await p.setBool(StorageKeys.exportIncludeClient, v);
    notifyListeners();
  }

  bool get exportIncludeSite =>
      _prefs?.getBool(StorageKeys.exportIncludeSite) ?? true;

  Future<void> setExportIncludeSite(bool v) async {
    final p = await _p;
    await p.setBool(StorageKeys.exportIncludeSite, v);
    notifyListeners();
  }

  bool get exportIncludeNote =>
      _prefs?.getBool(StorageKeys.exportIncludeNote) ?? true;

  Future<void> setExportIncludeNote(bool v) async {
    final p = await _p;
    await p.setBool(StorageKeys.exportIncludeNote, v);
    notifyListeners();
  }

  bool get autoProofNaming =>
      _prefs?.getBool(StorageKeys.autoProofNaming) ?? true;

  Future<void> setAutoProofNaming(bool v) async {
    final p = await _p;
    await p.setBool(StorageKeys.autoProofNaming, v);
    notifyListeners();
  }

  bool get autoProofReference =>
      _prefs?.getBool(StorageKeys.autoProofReference) ?? true;

  Future<void> setAutoProofReference(bool v) async {
    final p = await _p;
    await p.setBool(StorageKeys.autoProofReference, v);
    notifyListeners();
  }

  // ——— Exports PDF ———
  bool get openPdfAfterGeneration =>
      _prefs?.getBool(StorageKeys.openPdfAfterGeneration) ?? false;

  Future<void> setOpenPdfAfterGeneration(bool v) async {
    final p = await _p;
    await p.setBool(StorageKeys.openPdfAfterGeneration, v);
    notifyListeners();
  }

  bool get proposeShareAfterPdf =>
      _prefs?.getBool(StorageKeys.proposeShareAfterPdf) ?? true;

  Future<void> setProposeShareAfterPdf(bool v) async {
    final p = await _p;
    await p.setBool(StorageKeys.proposeShareAfterPdf, v);
    notifyListeners();
  }

  bool get includeAllPhotosInPdf =>
      _prefs?.getBool(StorageKeys.includeAllPhotosInPdf) ?? true;

  Future<void> setIncludeAllPhotosInPdf(bool v) async {
    final p = await _p;
    await p.setBool(StorageKeys.includeAllPhotosInPdf, v);
    notifyListeners();
  }

  PdfReportStyleSetting get pdfReportStyle {
    final v = _prefs?.getString(StorageKeys.pdfReportStyle) ?? 'standard';
    return v == 'premium'
        ? PdfReportStyleSetting.premium
        : PdfReportStyleSetting.standard;
  }

  Future<void> setPdfReportStyle(PdfReportStyleSetting s) async {
    final p = await _p;
    await p.setString(
      StorageKeys.pdfReportStyle,
      s == PdfReportStyleSetting.premium ? 'premium' : 'standard',
    );
    notifyListeners();
  }

  bool get groupedReportAllowed =>
      _prefs?.getBool(StorageKeys.groupedReportAllowed) ?? true;

  Future<void> setGroupedReportAllowed(bool v) async {
    final p = await _p;
    await p.setBool(StorageKeys.groupedReportAllowed, v);
    notifyListeners();
  }

  ExportSortOrderSetting get exportDefaultSortOrder {
    final v = _prefs?.getString(StorageKeys.exportDefaultSortOrder) ?? 'newest';
    return v == 'oldest'
        ? ExportSortOrderSetting.oldestFirst
        : ExportSortOrderSetting.newestFirst;
  }

  Future<void> setExportDefaultSortOrder(ExportSortOrderSetting o) async {
    final p = await _p;
    await p.setString(
      StorageKeys.exportDefaultSortOrder,
      o == ExportSortOrderSetting.oldestFirst ? 'oldest' : 'newest',
    );
    notifyListeners();
  }

  PdfAppearancePreferences get pdfAppearancePreferences {
    return PdfAppearancePreferences(
      showBranding: _prefs?.getBool(StorageKeys.pdfBrandingVisible) ?? true,
      showCredibilityBlock:
          _prefs?.getBool(StorageKeys.pdfCredibilityFooter) ?? true,
      showDetailedLocation:
          _prefs?.getBool(StorageKeys.pdfDetailedLocation) ?? true,
      includeAllPhotos:
          _prefs?.getBool(StorageKeys.includeAllPhotosInPdf) ?? true,
      reportStyle: pdfReportStyle == PdfReportStyleSetting.premium
          ? PdfReportStyle.premium
          : PdfReportStyle.standard,
    );
  }

  Future<void> setPdfBrandingVisible(bool v) async {
    final p = await _p;
    await p.setBool(StorageKeys.pdfBrandingVisible, v);
    notifyListeners();
  }

  Future<void> setPdfCredibilityFooter(bool v) async {
    final p = await _p;
    await p.setBool(StorageKeys.pdfCredibilityFooter, v);
    notifyListeners();
  }

  Future<void> setPdfDetailedLocation(bool v) async {
    final p = await _p;
    await p.setBool(StorageKeys.pdfDetailedLocation, v);
    notifyListeners();
  }

  // ——— Session / clients ———
  bool get restoreLastSession =>
      _prefs?.getBool(StorageKeys.restoreLastSession) ?? true;

  Future<void> setRestoreLastSession(bool v) async {
    final p = await _p;
    await p.setBool(StorageKeys.restoreLastSession, v);
    notifyListeners();
  }

  bool get confirmBeforeSessionChange =>
      _prefs?.getBool(StorageKeys.confirmBeforeSessionChange) ?? true;

  Future<void> setConfirmBeforeSessionChange(bool v) async {
    final p = await _p;
    await p.setBool(StorageKeys.confirmBeforeSessionChange, v);
    notifyListeners();
  }

  bool get confirmBeforeClientDelete =>
      _prefs?.getBool(StorageKeys.confirmBeforeClientDelete) ?? true;

  Future<void> setConfirmBeforeClientDelete(bool v) async {
    final p = await _p;
    await p.setBool(StorageKeys.confirmBeforeClientDelete, v);
    notifyListeners();
  }

  ClientDeletePolicySetting get clientDeletePolicy {
    final v = _prefs?.getString(StorageKeys.clientDeletePolicy) ?? 'block';
    return ClientDeletePolicySetting.values.firstWhere(
      (e) => e.name == v,
      orElse: () => ClientDeletePolicySetting.block,
    );
  }

  Future<void> setClientDeletePolicy(ClientDeletePolicySetting v) async {
    final p = await _p;
    await p.setString(StorageKeys.clientDeletePolicy, v.name);
    notifyListeners();
  }
}
