
class SearchLocationResult {
  final double latitude;
  final double longitude;
  final String displayName;
  final String address;

  const SearchLocationResult({
    required this.latitude,
    required this.longitude,
    required this.displayName,
    required this.address,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchLocationResult &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.displayName == displayName &&
        other.address == address;
  }

  @override
  int get hashCode {
    return latitude.hashCode ^
    longitude.hashCode ^
    displayName.hashCode ^
    address.hashCode;
  }
}