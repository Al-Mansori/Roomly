abstract class LocationEvent {
  const LocationEvent();
}

class LoadInitialLocation extends LocationEvent {
  const LoadInitialLocation();
}

class GetCurrentLocation extends LocationEvent {
  const GetCurrentLocation();
}

class SearchLocations extends LocationEvent {
  final String query;

  const SearchLocations(this.query);
}

class SelectSearchResult extends LocationEvent {
  final double latitude;
  final double longitude;
  final String displayName;
  final String address;

  const SelectSearchResult({
    required this.latitude,
    required this.longitude,
    required this.displayName,
    required this.address,
  });
}

class SelectLocationOnMap extends LocationEvent {
  final double latitude;
  final double longitude;

  const SelectLocationOnMap({
    required this.latitude,
    required this.longitude,
  });
}

class SaveSelectedLocation extends LocationEvent {
  final double latitude;
  final double longitude;
  final String locationName;
  final String? address;

  const SaveSelectedLocation({
    required this.latitude,
    required this.longitude,
    required this.locationName,
    this.address,
  });
}

class ResetSearchState extends LocationEvent {
  const ResetSearchState();
}
