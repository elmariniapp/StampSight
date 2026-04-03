import 'dart:convert';

import 'proof_location.dart';
import 'proof_overlay_data.dart';
import 'proof_file_ref.dart';

enum ProofType {
  inspection,
  delivery,
  workProgress,
  incident,
  inventory,
  other,
}

enum ProofSource { local }

class Proof {
  final String id;
  final String title;
  final String? description;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final ProofType proofType;
  final ProofFileRef fileRef;
  final ProofLocation? location;
  final ProofOverlayData overlayData;
  final bool isFavorite;
  final ProofSource source;
  final String? clientId;
  final String? siteMissionId;

  /// Additional images attached to this proof (multi-photo support).
  /// Empty list for legacy single-image proofs — fully backward compatible.
  final List<String> additionalImagePaths;

  const Proof({
    required this.id,
    required this.title,
    this.description,
    required this.createdAt,
    this.updatedAt,
    required this.proofType,
    required this.fileRef,
    this.location,
    required this.overlayData,
    this.isFavorite = false,
    this.source = ProofSource.local,
    this.clientId,
    this.siteMissionId,
    this.additionalImagePaths = const [],
  });

  String get imagePath => fileRef.originalPath;
  String? get thumbnailPath => fileRef.thumbnailPath;
  String? get address => location?.address;
  double? get latitude => location?.latitude;
  double? get longitude => location?.longitude;
  String get overlayDateText => overlayData.dateText;
  String get overlayTimeText => overlayData.timeText;
  String? get overlayAddressText => overlayData.addressText;

  bool get isClassified => clientId != null;

  bool get hasAdditionalImages => additionalImagePaths.isNotEmpty;

  int get totalImageCount => 1 + additionalImagePaths.length;

  Proof copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    ProofType? proofType,
    ProofFileRef? fileRef,
    ProofLocation? location,
    ProofOverlayData? overlayData,
    bool? isFavorite,
    ProofSource? source,
    Object? clientId = _sentinel,
    Object? siteMissionId = _sentinel,
    List<String>? additionalImagePaths,
  }) {
    return Proof(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      proofType: proofType ?? this.proofType,
      fileRef: fileRef ?? this.fileRef,
      location: location ?? this.location,
      overlayData: overlayData ?? this.overlayData,
      isFavorite: isFavorite ?? this.isFavorite,
      source: source ?? this.source,
      clientId: clientId == _sentinel ? this.clientId : clientId as String?,
      siteMissionId: siteMissionId == _sentinel
          ? this.siteMissionId
          : siteMissionId as String?,
      additionalImagePaths:
          additionalImagePaths ?? this.additionalImagePaths,
    );
  }

  static const Object _sentinel = Object();

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'proofType': proofType.name,
        'fileRef': fileRef.toMap(),
        'location': location?.toMap(),
        'overlayData': overlayData.toMap(),
        'isFavorite': isFavorite,
        'source': source.name,
        'clientId': clientId,
        'siteMissionId': siteMissionId,
        if (additionalImagePaths.isNotEmpty)
          'additionalImagePaths': additionalImagePaths,
      };

  factory Proof.fromMap(Map<String, dynamic> map) => Proof(
        id: map['id'] as String,
        title: map['title'] as String,
        description: map['description'] as String?,
        createdAt: DateTime.parse(map['createdAt'] as String),
        updatedAt: map['updatedAt'] != null
            ? DateTime.parse(map['updatedAt'] as String)
            : null,
        proofType: ProofType.values.firstWhere(
          (e) => e.name == map['proofType'],
          orElse: () => ProofType.other,
        ),
        fileRef: ProofFileRef.fromMap(map['fileRef'] as Map<String, dynamic>),
        location: map['location'] != null
            ? ProofLocation.fromMap(map['location'] as Map<String, dynamic>)
            : null,
        overlayData: ProofOverlayData.fromMap(
            map['overlayData'] as Map<String, dynamic>),
        isFavorite: map['isFavorite'] as bool? ?? false,
        source: ProofSource.local,
        clientId: map['clientId'] as String?,
        siteMissionId: map['siteMissionId'] as String?,
        additionalImagePaths: (map['additionalImagePaths'] as List<dynamic>?)
                ?.cast<String>() ??
            const [],
      );

  String toJson() => json.encode(toMap());

  factory Proof.fromJson(String source) =>
      Proof.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Proof && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Proof(id: $id, title: $title)';
}
