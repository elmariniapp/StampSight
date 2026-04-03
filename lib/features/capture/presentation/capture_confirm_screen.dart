import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../../app/routes/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/di/providers.dart';
import '../../../core/layout/app_content_layout.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/utils/id_generator.dart';
import '../../../core/utils/proof_reference_label.dart';
import '../data/proof_draft_finalize.dart';
import '../../../core/privacy/contextual_permission_sheet.dart';
import '../../../l10n/app_localizations.dart';
import '../../proofs/domain/proof.dart';
import '../../proofs/domain/proof_file_ref.dart';
import '../../proofs/domain/proof_location.dart';
import '../../proofs/domain/proof_overlay_data.dart';
import '../../context/presentation/context_picker_screen.dart';
import '../domain/capture_launch_mode.dart';

String _formatPlacemark(Placemark pm) {
  final parts = <String>[];
  void add(String? s) {
    final t = s?.trim();
    if (t != null && t.isNotEmpty) parts.add(t);
  }

  add(pm.street);
  final sub = pm.subLocality?.trim();
  if (sub != null &&
      sub.isNotEmpty &&
      sub != (pm.street ?? '').trim()) {
    add(sub);
  }
  add(pm.locality);
  add(pm.postalCode);
  add(pm.country);
  return parts.join(', ');
}

class CaptureConfirmScreen extends ConsumerStatefulWidget {
  final String? capturedImagePath;

  const CaptureConfirmScreen({super.key, this.capturedImagePath});

  @override
  ConsumerState<CaptureConfirmScreen> createState() =>
      _CaptureConfirmScreenState();
}

class _CaptureConfirmScreenState extends ConsumerState<CaptureConfirmScreen> {
  static const String _confirmationHeroAsset =
      'assets/images/proofs/capture_confirmation_01.webp';

  final _noteController = TextEditingController();
  ProofType _selectedType = ProofType.inspection;
  String? _clientId;
  String? _siteMissionId;

  /// Horodatage figé à l’ouverture : cohérent entre aperçu, champs et enregistrement.
  late final DateTime _snapshotAt = DateTime.now();

  ProofLocation? _resolvedLocation;
  String _addressRow = '';
  String _coordsRow = '';
  bool _finalizing = false;

  /// Chemins stables (dossier app `proofs/`, préfixe `draft_`) — ordre = ordre de prise.
  List<String> _draftStoragePaths = [];
  bool _draftBootstrapDone = false;

  /// Après enregistrement réussi : ne pas supprimer les fichiers au dispose.
  bool _committed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _bootstrapDraft();
      if (mounted) _trySilentLocationPreview();
    });
  }

  Future<void> _bootstrapDraft() async {
    final temp = widget.capturedImagePath;
    if (temp == null || temp.isEmpty) {
      if (mounted) setState(() => _draftBootstrapDone = true);
      return;
    }
    final src = File(temp);
    if (!await src.exists()) {
      if (mounted) setState(() => _draftBootstrapDone = true);
      return;
    }
    try {
      final stored = await _copyIntoProofsDraft(temp);
      if (!mounted) return;
      setState(() {
        _draftStoragePaths = [stored];
        _draftBootstrapDone = true;
      });
    } catch (_) {
      if (mounted) setState(() => _draftBootstrapDone = true);
    }
  }

  Future<String> _copyIntoProofsDraft(String tempPath) async {
    final src = File(tempPath);
    if (!await src.exists()) return tempPath;
    final dir = await getApplicationDocumentsDirectory();
    final proofsDir = Directory(p.join(dir.path, 'proofs'));
    if (!proofsDir.existsSync()) {
      proofsDir.createSync(recursive: true);
    }
    final ext = p.extension(tempPath);
    final safeExt = ext.isNotEmpty ? ext : '.jpg';
    final dest = File(
      p.join(proofsDir.path, 'draft_${IdGenerator.generate()}$safeExt'),
    );
    await src.copy(dest.path);
    return dest.path;
  }

  void _deleteDraftFilesSync() {
    for (final path in _draftStoragePaths) {
      try {
        final f = File(path);
        if (f.existsSync()) f.deleteSync();
      } catch (_) {}
    }
    _draftStoragePaths = [];
  }

  @override
  void dispose() {
    if (!_committed) {
      _deleteDraftFilesSync();
    }
    _noteController.dispose();
    super.dispose();
  }

  /// Localisation déjà accordée : aperçu sans popup système.
  Future<void> _trySilentLocationPreview() async {
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;
    final p = await Geolocator.checkPermission();
    if (p == LocationPermission.whileInUse || p == LocationPermission.always) {
      await _resolveLocationForPreview();
    }
  }

  bool _hasLocationData() {
    final loc = _resolvedLocation;
    return loc != null &&
        loc.latitude != null &&
        loc.longitude != null;
  }

  /// Avant enregistrement : pré-sheet + permission si le lieu manque encore.
  Future<void> _ensureLocationBeforeSave() async {
    if (_hasLocationData()) return;
    if (!await Geolocator.isLocationServiceEnabled()) return;
    if (!mounted) return;
    var p = await Geolocator.checkPermission();
    if (!mounted) return;
    if (p == LocationPermission.whileInUse || p == LocationPermission.always) {
      await _resolveLocationForPreview();
      return;
    }
    final l10n = AppLocalizations.of(context);
    if (p == LocationPermission.deniedForever) {
      final go = await ContextualPermissionSheet.show(
        context,
        title: l10n.locationPrePermissionTitle,
        body: l10n.locationPrePermissionBodySettings,
        continueLabel: l10n.permissionSheetContinue,
      );
      if (!go || !mounted) return;
      await Geolocator.openAppSettings();
      return;
    }
    if (p == LocationPermission.denied) {
      final go = await ContextualPermissionSheet.show(
        context,
        title: l10n.locationPrePermissionTitle,
        body: l10n.locationPrePermissionBody,
        continueLabel: l10n.permissionSheetContinue,
      );
      if (!go || !mounted) return;
      p = await Geolocator.requestPermission();
      if (!mounted) return;
      if (p == LocationPermission.whileInUse || p == LocationPermission.always) {
        await _resolveLocationForPreview();
      }
    }
  }

  Future<void> _resolveLocationForPreview() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return;
      }
      final permission = await Geolocator.checkPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );
      final coordStr =
          '${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}';
      if (!mounted) return;
      setState(() {
        _resolvedLocation = ProofLocation(
          address: null,
          latitude: pos.latitude,
          longitude: pos.longitude,
        );
        _addressRow = coordStr;
        _coordsRow = coordStr;
      });

      try {
        final marks = await placemarkFromCoordinates(
          pos.latitude,
          pos.longitude,
        );
        if (!mounted) return;
        String? addr;
        if (marks.isNotEmpty) {
          final formatted = _formatPlacemark(marks.first);
          if (formatted.isNotEmpty) addr = formatted;
        }
        if (!mounted) return;
        setState(() {
          _resolvedLocation = ProofLocation(
            address: addr,
            latitude: pos.latitude,
            longitude: pos.longitude,
          );
          _addressRow = addr ?? coordStr;
        });
      } catch (_) {}
    } catch (_) {}
  }

  ({String? clientId, String? siteMissionId}) _resolvedContextIds() {
    if (_clientId != null) {
      return (clientId: _clientId, siteMissionId: _siteMissionId);
    }
    final session = ref.read(activeSessionRepositoryProvider).currentSession;
    if (session != null) {
      return (
        clientId: session.client.id,
        siteMissionId: session.site.id,
      );
    }
    return (clientId: null, siteMissionId: null);
  }

  String _contextLabelFor(AppLocalizations l10n) {
    final ids = _resolvedContextIds();
    if (ids.clientId == null) return l10n.unclassified;
    final clientsRepo = ref.read(clientsRepositoryProvider);
    final client = clientsRepo.getClientById(ids.clientId!);
    final site = ids.siteMissionId != null
        ? clientsRepo.getSiteById(ids.siteMissionId!)
        : null;
    if (client == null) return l10n.unclassified;
    return site != null ? '${client.name} — ${site.name}' : client.name;
  }

  String _overlayDateLine(String languageCode) =>
      DateFormatters.overlayDate(_snapshotAt, languageCode);

  String _overlayTimeLine() => DateFormatters.overlayTime(_snapshotAt);

  Future<void> _onAddAnotherPhoto() async {
    final settings = ref.read(appSettingsRepositoryProvider);
    if (!settings.multiPhotoPromptEnabled) return;

    final picked = await context.pushNamed<String?>(
      RouteNames.capture,
      extra: CaptureLaunchMode.addPhotoToDraft,
    );
    if (!mounted || picked == null || picked.isEmpty) return;
    final src = File(picked);
    if (!await src.exists()) return;
    try {
      final stored = await _copyIntoProofsDraft(picked);
      if (!mounted) return;
      setState(() => _draftStoragePaths = [..._draftStoragePaths, stored]);
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.photoAdded),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (_) {}
  }

  Future<void> _confirmRemoveDraftAt(int index) async {
    if (index < 0 || index >= _draftStoragePaths.length) return;
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.removeDraftPhotoTitle),
        content: Text(l10n.removeDraftPhotoBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final path = _draftStoragePaths[index];
    setState(() {
      _draftStoragePaths = List<String>.from(_draftStoragePaths)..removeAt(index);
    });
    try {
      final f = File(path);
      if (f.existsSync()) f.deleteSync();
    } catch (_) {}
    if (!mounted) return;
    if (_draftStoragePaths.isEmpty) {
      context.pop();
    }
  }

  Future<void> _finalizeProof() async {
    if (_finalizing || _draftStoragePaths.isEmpty) return;
    setState(() => _finalizing = true);
    try {
      await _ensureLocationBeforeSave();
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      final settings = ref.read(appSettingsRepositoryProvider);
      final dateLine = _overlayDateLine(l10n.languageCode);
      final timeLine = _overlayTimeLine();
      final addressLine = _addressRow.isNotEmpty
          ? _addressRow
          : l10n.addressUnavailable;

      final pathsCopy = List<String>.from(_draftStoragePaths);
      final proofId = IdGenerator.generate();
      final note = _noteController.text.trim();

      String title;
      String? description;
      if (note.isNotEmpty) {
        title = note;
        description = note;
      } else {
        title = settings.autoProofNaming
            ? l10n.autoStyledProofTitle(
                _typeLabel(_selectedType, l10n),
                dateLine,
                timeLine,
              )
            : l10n.defaultProofTitle(dateLine);
        description = settings.autoProofReference
            ? l10n.proofReferenceLine(
                proofReferenceLabelFromProofId(proofId),
              )
            : null;
      }

      final ctxIds = _resolvedContextIds();
      final locSnapshot = _resolvedLocation;
      final repo = ref.read(proofRepositoryProvider);

      try {
        await commitDraftImages(
          draftPathsOrdered: pathsCopy,
          persist: (mainPath, additional) async {
            final proof = Proof(
              id: proofId,
              title: title,
              description: description,
              createdAt: _snapshotAt,
              proofType: _selectedType,
              fileRef: ProofFileRef(originalPath: mainPath),
              location: locSnapshot,
              overlayData: ProofOverlayData(
                dateText: dateLine,
                timeText: timeLine,
                addressText: addressLine,
              ),
              clientId: ctxIds.clientId,
              siteMissionId: ctxIds.siteMissionId,
              additionalImagePaths: additional,
            );
            await repo.addProof(proof);
          },
        );
      } catch (e, st) {
        debugPrint('StampSight: _finalizeProof $e\n$st');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.proofSaveFailed),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
        return;
      }

      _committed = true;
      if (mounted) setState(() => _draftStoragePaths = []);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.proofSaved),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      context.go(RoutePaths.home);
    } finally {
      if (mounted) setState(() => _finalizing = false);
    }
  }

  Future<void> _editContext() async {
    final result = await context.push<ContextPickerResult?>(
      RoutePaths.contextPicker,
    );
    if (result != null && mounted) {
      setState(() {
        _clientId = result.client.id;
        _siteMissionId = result.site.id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sessionRepo = ref.read(activeSessionRepositoryProvider);
    ref.watch(appSettingsRepositoryProvider);

    return ListenableBuilder(
      listenable: sessionRepo as Listenable,
      builder: (context, _) {
        return _buildContent(context, l10n);
      },
    );
  }

  Widget _buildContent(BuildContext context, AppLocalizations l10n) {
    final appBar = AppBar(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      title: Text(l10n.confirmProof, style: AppTextStyles.titleMedium),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => context.pop(),
      ),
    );

    if (!_draftBootstrapDone) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: appBar,
        body: const SafeArea(
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_draftStoragePaths.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: appBar,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                l10n.proofNotFound,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ),
        ),
      );
    }

    final multiPhoto =
        ref.watch(appSettingsRepositoryProvider).multiPhotoPromptEnabled;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: appBar,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppContentLayout.horizontalMargin(context),
            AppSpacing.screenPadding,
            AppContentLayout.horizontalMargin(context),
            AppContentLayout.scrollBottomInset(context),
          ),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.proofDraftPhotosSummary(_draftStoragePaths.length),
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildDraftVisuals(l10n),
            const SizedBox(height: AppSpacing.md),

            _InfoCard(
              children: [
                _InfoRow(
                    icon: Icons.calendar_today_rounded,
                    label: l10n.date,
                    value: _overlayDateLine(l10n.languageCode)),
                _InfoRow(
                    icon: Icons.access_time_rounded,
                    label: l10n.time,
                    value: _overlayTimeLine()),
                _InfoRow(
                    icon: Icons.location_on_rounded,
                    label: l10n.address,
                    value: _addressRow.isNotEmpty
                        ? _addressRow
                        : l10n.addressUnavailable),
                _InfoRow(
                    icon: Icons.explore_rounded,
                    label: l10n.coordinates,
                    value: _coordsRow.isNotEmpty
                        ? _coordsRow
                        : l10n.coordinatesUnavailable),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            _InfoCard(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.proofType,
                        style: AppTextStyles.labelMedium,
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ProofType.values.map((type) {
                          final selected = _selectedType == type;
                          return GestureDetector(
                            onTap: () =>
                                setState(() => _selectedType = type),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 7),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.surfaceVariant,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _typeLabel(type, l10n),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: selected
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            _InfoCard(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.classifiedAs,
                              style: AppTextStyles.labelMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _contextLabelFor(l10n),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: _resolvedContextIds().clientId != null
                                    ? AppColors.textPrimary
                                    : AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: _editContext,
                        child: Text(
                          l10n.modifyContext,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: _noteController,
                decoration: InputDecoration(
                  hintText: l10n.noteOptional,
                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textTertiary,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(AppSpacing.md),
                ),
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
                maxLines: 3,
                minLines: 1,
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            if (multiPhoto) ...[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _finalizing ? null : _onAddAnotherPhoto,
                  icon: const Icon(Icons.add_a_photo_rounded, size: 20),
                  label: Text(l10n.addAnotherPhoto),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    side: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _finalizing ? null : _finalizeProof,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: _finalizing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        multiPhoto ? l10n.finishThisProof : l10n.save,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildDraftVisuals(AppLocalizations l10n) {
    final paths = _draftStoragePaths;
    if (paths.isEmpty) return const SizedBox.shrink();

    if (paths.length == 2) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildDraftPhotoTile(
              l10n,
              path: paths[0],
              index: 0,
              showDateOverlay: true,
              showPrimaryBadge: true,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildDraftPhotoTile(
              l10n,
              path: paths[1],
              index: 1,
              showDateOverlay: false,
              showPrimaryBadge: false,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildDraftPhotoTile(
          l10n,
          path: paths.first,
          index: 0,
          showDateOverlay: true,
          showPrimaryBadge: paths.length > 1,
        ),
        if (paths.length > 1) ...[
          const SizedBox(height: 10),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: paths.length - 1,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final index = i + 1;
                return _buildDraftStripThumb(l10n, paths[index], index);
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDraftPhotoTile(
    AppLocalizations l10n, {
    required String path,
    required int index,
    required bool showDateOverlay,
    required bool showPrimaryBadge,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(
              File(path),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                _confirmationHeroAsset,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) => ColoredBox(
                  color: AppColors.primary,
                  child: Center(
                    child: Icon(
                      Icons.camera_alt_rounded,
                      size: 56,
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
            ),
            if (showDateOverlay)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 72,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.primary.withValues(alpha: 0.5),
                      ],
                    ),
                  ),
                ),
              ),
            if (showDateOverlay)
              Positioned(
                left: AppSpacing.md,
                bottom: AppSpacing.md,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _overlayDateLine(l10n.languageCode),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'monospace',
                        ),
                      ),
                      Text(
                        _overlayTimeLine(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'monospace',
                        ),
                      ),
                      if (_addressRow.isNotEmpty &&
                          _addressRow != l10n.addressUnavailable) ...[
                        const SizedBox(height: 4),
                        Text(
                          _addressRow,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.88),
                            fontSize: 10,
                            fontFamily: 'monospace',
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            if (showPrimaryBadge)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    l10n.primaryPhotoBadge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            if (_draftStoragePaths.length > 1)
              Positioned(
                top: 6,
                right: 6,
                child: Material(
                  color: Colors.black.withValues(alpha: 0.45),
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => _confirmRemoveDraftAt(index),
                    tooltip: l10n.delete,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDraftStripThumb(
    AppLocalizations l10n,
    String path,
    int index,
  ) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(
              File(path),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => ColoredBox(
                color: AppColors.surfaceVariant,
                child: Icon(
                  Icons.image_not_supported_rounded,
                  color: AppColors.textTertiary,
                ),
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: Material(
                color: Colors.black.withValues(alpha: 0.45),
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  onPressed: () => _confirmRemoveDraftAt(index),
                  tooltip: l10n.delete,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _typeLabel(ProofType type, AppLocalizations l10n) => switch (type) {
        ProofType.inspection => l10n.proofTypeInspection,
        ProofType.delivery => l10n.proofTypeDelivery,
        ProofType.workProgress => l10n.proofTypeWorkProgress,
        ProofType.incident => l10n.proofTypeIncident,
        ProofType.inventory => l10n.proofTypeInventory,
        ProofType.other => l10n.proofTypeOther,
      };
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textTertiary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
