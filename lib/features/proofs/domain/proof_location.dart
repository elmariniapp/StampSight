class ProofLocation {
  final String? address;
  final double? latitude;
  final double? longitude;

  const ProofLocation({
    this.address,
    this.latitude,
    this.longitude,
  });

  ProofLocation copyWith({
    String? address,
    double? latitude,
    double? longitude,
  }) {
    return ProofLocation(
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toMap() => {
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
      };

  factory ProofLocation.fromMap(Map<String, dynamic> map) => ProofLocation(
        address: map['address'] as String?,
        latitude: (map['latitude'] as num?)?.toDouble(),
        longitude: (map['longitude'] as num?)?.toDouble(),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProofLocation &&
          address == other.address &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => Object.hash(address, latitude, longitude);

  @override
  String toString() =>
      'ProofLocation(address: $address, lat: $latitude, lng: $longitude)';
}
