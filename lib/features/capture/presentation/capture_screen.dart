import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../app/routes/route_names.dart';
import '../domain/capture_launch_mode.dart';
import '../../../core/di/providers.dart';
import '../../../core/privacy/contextual_permission_sheet.dart';
import '../../../l10n/app_localizations.dart';

/// Route légère : pré-sheet caméra si besoin, puis caméra native.
class CaptureScreen extends ConsumerStatefulWidget {
  const CaptureScreen({
    super.key,
    this.launchMode = CaptureLaunchMode.newProof,
  });

  final CaptureLaunchMode launchMode;

  @override
  ConsumerState<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends ConsumerState<CaptureScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _manualCameraGate = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeBeginCameraFlow());
  }

  Future<void> _maybeBeginCameraFlow() async {
    final openDirect =
        ref.read(appSettingsRepositoryProvider).openCameraDirectlyFromNewProof;
    if (!mounted) return;
    if (!openDirect) {
      setState(() => _manualCameraGate = true);
      return;
    }
    await _beginCameraFlow();
  }

  Future<void> _beginCameraFlow() async {
    var status = await Permission.camera.status;
    if (!mounted) return;

    if (status.isGranted || status.isLimited) {
      await _pickFromCamera();
      return;
    }

    final l10n = AppLocalizations.of(context);

    if (status.isPermanentlyDenied || status.isRestricted) {
      final go = await ContextualPermissionSheet.show(
        context,
        title: l10n.cameraPrePermissionTitle,
        body: l10n.cameraPrePermissionBody,
        continueLabel: l10n.permissionSheetContinue,
      );
      if (!mounted) return;
      if (!go) {
        context.pop();
        return;
      }
      await openAppSettings();
      if (!mounted) return;
      status = await Permission.camera.status;
      if (!mounted) return;
      if (status.isGranted || status.isLimited) {
        await _pickFromCamera();
      } else {
        context.pop();
      }
      return;
    }

    final go = await ContextualPermissionSheet.show(
      context,
      title: l10n.cameraPrePermissionTitle,
      body: l10n.cameraPrePermissionBody,
      continueLabel: l10n.permissionSheetContinue,
    );
    if (!mounted) return;
    if (!go) {
      context.pop();
      return;
    }

    final req = await Permission.camera.request();
    if (!mounted) return;
    if (req.isGranted || req.isLimited) {
      await _pickFromCamera();
      return;
    }
    if (req.isPermanentlyDenied && mounted) {
      await openAppSettings();
    }
    if (mounted) context.pop();
  }

  Future<void> _pickFromCamera() async {
    try {
      final x = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
      );
      if (!mounted) return;
      if (x == null) {
        if (widget.launchMode == CaptureLaunchMode.addPhotoToDraft) {
          context.pop<String?>(null);
        } else {
          context.pop();
        }
        return;
      }
      if (widget.launchMode == CaptureLaunchMode.addPhotoToDraft) {
        context.pop<String?>(x.path);
        return;
      }
      context.pushReplacementNamed(
        RouteNames.captureConfirm,
        extra: x.path,
      );
    } catch (_) {
      if (mounted) {
        if (widget.launchMode == CaptureLaunchMode.addPhotoToDraft) {
          context.pop<String?>(null);
        } else {
          context.pop();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final iconColor = Theme.of(context).colorScheme.onSurface.withValues(
          alpha: 0.55,
        );

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: iconColor, size: 22),
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.launchMode == CaptureLaunchMode.addPhotoToDraft
              ? l10n.addAnotherPhoto
              : l10n.newProof,
          style: TextStyle(
            color: iconColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _manualCameraGate
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.captureManualIntro,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: iconColor,
                        fontSize: 14,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: () {
                        setState(() => _manualCameraGate = false);
                        _beginCameraFlow();
                      },
                      icon: const Icon(Icons.photo_camera_rounded),
                      label: Text(l10n.openCamera),
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
