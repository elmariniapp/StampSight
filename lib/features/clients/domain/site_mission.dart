enum SiteMissionType {
  intervention,
  maintenance,
  delivery,
  control,
  other,
}

class SiteMission {
  final String id;
  final String clientId;
  final String name;
  final SiteMissionType type;
  final String? address;
  final String? note;

  const SiteMission({
    required this.id,
    required this.clientId,
    required this.name,
    required this.type,
    this.address,
    this.note,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'clientId': clientId,
        'name': name,
        'type': type.name,
        'address': address,
        'note': note,
      };

  factory SiteMission.fromMap(Map<String, dynamic> map) => SiteMission(
        id: map['id'] as String,
        clientId: map['clientId'] as String,
        name: map['name'] as String,
        type: SiteMissionType.values.firstWhere(
          (e) => e.name == map['type'],
          orElse: () => SiteMissionType.other,
        ),
        address: map['address'] as String?,
        note: map['note'] as String?,
      );

  SiteMission copyWith({
    String? id,
    String? clientId,
    String? name,
    SiteMissionType? type,
    String? address,
    String? note,
  }) {
    return SiteMission(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      name: name ?? this.name,
      type: type ?? this.type,
      address: address ?? this.address,
      note: note ?? this.note,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is SiteMission && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
