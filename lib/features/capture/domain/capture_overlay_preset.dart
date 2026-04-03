enum OverlayPosition { topLeft, topRight, bottomLeft, bottomRight }

class CaptureOverlayPreset {
  final String id;
  final String name;
  final bool showDate;
  final bool showTime;
  final bool showAddress;
  final bool showCoordinates;
  final OverlayPosition position;

  const CaptureOverlayPreset({
    required this.id,
    required this.name,
    this.showDate = true,
    this.showTime = true,
    this.showAddress = true,
    this.showCoordinates = false,
    this.position = OverlayPosition.bottomLeft,
  });

  CaptureOverlayPreset copyWith({
    String? id,
    String? name,
    bool? showDate,
    bool? showTime,
    bool? showAddress,
    bool? showCoordinates,
    OverlayPosition? position,
  }) {
    return CaptureOverlayPreset(
      id: id ?? this.id,
      name: name ?? this.name,
      showDate: showDate ?? this.showDate,
      showTime: showTime ?? this.showTime,
      showAddress: showAddress ?? this.showAddress,
      showCoordinates: showCoordinates ?? this.showCoordinates,
      position: position ?? this.position,
    );
  }

  static const standard = CaptureOverlayPreset(
    id: 'standard',
    name: 'Standard',
  );

  static const minimal = CaptureOverlayPreset(
    id: 'minimal',
    name: 'Minimal',
    showAddress: false,
    showCoordinates: false,
  );

  static const complete = CaptureOverlayPreset(
    id: 'complete',
    name: 'Complet',
    showCoordinates: true,
  );

  static List<CaptureOverlayPreset> get presets => [standard, minimal, complete];
}
