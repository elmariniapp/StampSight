class ProofOverlayData {
  final String dateText;
  final String timeText;
  final String? addressText;

  const ProofOverlayData({
    required this.dateText,
    required this.timeText,
    this.addressText,
  });

  ProofOverlayData copyWith({
    String? dateText,
    String? timeText,
    String? addressText,
  }) {
    return ProofOverlayData(
      dateText: dateText ?? this.dateText,
      timeText: timeText ?? this.timeText,
      addressText: addressText ?? this.addressText,
    );
  }

  Map<String, dynamic> toMap() => {
        'dateText': dateText,
        'timeText': timeText,
        'addressText': addressText,
      };

  factory ProofOverlayData.fromMap(Map<String, dynamic> map) =>
      ProofOverlayData(
        dateText: map['dateText'] as String,
        timeText: map['timeText'] as String,
        addressText: map['addressText'] as String?,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProofOverlayData &&
          dateText == other.dateText &&
          timeText == other.timeText &&
          addressText == other.addressText;

  @override
  int get hashCode => Object.hash(dateText, timeText, addressText);
}
