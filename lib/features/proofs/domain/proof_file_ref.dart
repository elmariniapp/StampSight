class ProofFileRef {
  final String originalPath;
  final String? thumbnailPath;
  final String? exportedPath;

  const ProofFileRef({
    required this.originalPath,
    this.thumbnailPath,
    this.exportedPath,
  });

  ProofFileRef copyWith({
    String? originalPath,
    String? thumbnailPath,
    String? exportedPath,
  }) {
    return ProofFileRef(
      originalPath: originalPath ?? this.originalPath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      exportedPath: exportedPath ?? this.exportedPath,
    );
  }

  Map<String, dynamic> toMap() => {
        'originalPath': originalPath,
        'thumbnailPath': thumbnailPath,
        'exportedPath': exportedPath,
      };

  factory ProofFileRef.fromMap(Map<String, dynamic> map) => ProofFileRef(
        originalPath: map['originalPath'] as String,
        thumbnailPath: map['thumbnailPath'] as String?,
        exportedPath: map['exportedPath'] as String?,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProofFileRef &&
          originalPath == other.originalPath &&
          thumbnailPath == other.thumbnailPath &&
          exportedPath == other.exportedPath;

  @override
  int get hashCode => Object.hash(originalPath, thumbnailPath, exportedPath);
}
