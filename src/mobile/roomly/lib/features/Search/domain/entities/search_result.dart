class SearchResult {
  final List<Room> rooms;
  final List<Workspace> workspaces;

  SearchResult({
    required this.rooms,
    required this.workspaces,
  });
}

class Room {
  final String id;
  final String name;
  final String type;
  final String description;
  final int capacity;
  final int availableCount;
  final double pricePerHour;
  final String status;
  final List<String>? amenities;
  final List<RoomImage>? roomImages;
  final List<dynamic>? offers;
  final String workspaceId;

  Room({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.capacity,
    required this.availableCount,
    required this.pricePerHour,
    required this.status,
    this.amenities,
    this.roomImages,
    this.offers,
    required this.workspaceId,
  });
}

class RoomImage {
  final String imageUrl;

  RoomImage({required this.imageUrl});
}

class Workspace {
  final String id;
  final String name;
  final String description;
  final String address;
  final Location location;
  final String creationDate;
  final double avgRating;
  final String type;
  final List<WorkspaceImage>? workspaceImages;
  final List<dynamic>? reviews;
  final String paymentType;

  Workspace({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.location,
    required this.creationDate,
    required this.avgRating,
    required this.type,
    this.workspaceImages,
    this.reviews,
    required this.paymentType,
  });
}

class Location {
  final String id;
  final String? city;
  final String? town;
  final String? country;
  final double longitude;
  final double latitude;

  Location({
    required this.id,
    this.city,
    this.town,
    this.country,
    required this.longitude,
    required this.latitude,
  });
}

class WorkspaceImage {
  final String imageUrl;

  WorkspaceImage({required this.imageUrl});
}
