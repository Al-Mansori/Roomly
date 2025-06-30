import '../../domain/entities/search_result.dart';

class SearchResultModel extends SearchResult {
  SearchResultModel({
    required super.rooms,
    required super.workspaces,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      rooms: (json['rooms'] as List<dynamic>?)
              ?.map((roomJson) => RoomModel.fromJson(roomJson))
              .toList() ??
          [],
      workspaces: (json['workspaces'] as List<dynamic>?)
              ?.map((workspaceJson) => WorkspaceModel.fromJson(workspaceJson))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rooms': rooms.map((room) => (room as RoomModel).toJson()).toList(),
      'workspaces': workspaces
          .map((workspace) => (workspace as WorkspaceModel).toJson())
          .toList(),
    };
  }
}

class RoomModel extends Room {
  RoomModel({
    required super.id,
    required super.name,
    required super.type,
    required super.description,
    required super.capacity,
    required super.availableCount,
    required super.pricePerHour,
    required super.status,
    super.amenities,
    super.roomImages,
    super.offers,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      capacity: json['capacity'] ?? 0,
      availableCount: json['availableCount'] ?? 0,
      pricePerHour: (json['pricePerHour'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? '',
      amenities: json['amenities'] != null
          ? List<String>.from(json['amenities'])
          : null,
      roomImages: json['roomImages'] != null
          ? (json['roomImages'] as List<dynamic>)
              .map((imageJson) => RoomImageModel.fromJson(imageJson))
              .toList()
          : null,
      offers: json['offers'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
      'capacity': capacity,
      'availableCount': availableCount,
      'pricePerHour': pricePerHour,
      'status': status,
      'amenities': amenities,
      'roomImages': roomImages
          ?.map((image) => (image as RoomImageModel).toJson())
          .toList(),
      'offers': offers,
    };
  }
}

class RoomImageModel extends RoomImage {
  RoomImageModel({required super.imageUrl});

  factory RoomImageModel.fromJson(Map<String, dynamic> json) {
    return RoomImageModel(
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
    };
  }
}

class WorkspaceModel extends Workspace {
  WorkspaceModel({
    required super.id,
    required super.name,
    required super.description,
    required super.address,
    required super.location,
    required super.creationDate,
    required super.avgRating,
    required super.type,
    super.workspaceImages,
    super.reviews,
    required super.paymentType,
  });

  factory WorkspaceModel.fromJson(Map<String, dynamic> json) {
    return WorkspaceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      location: LocationModel.fromJson(json['location'] ?? {}),
      creationDate: json['creationDate'] ?? '',
      avgRating: (json['avgRating'] as num?)?.toDouble() ?? 0.0,
      type: json['type'] ?? '',
      workspaceImages: json['workspaceImages'] != null
          ? (json['workspaceImages'] as List<dynamic>)
              .map((imageJson) => WorkspaceImageModel.fromJson(imageJson))
              .toList()
          : null,
      reviews: json['reviews'],
      paymentType: json['paymentType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'location': (location as LocationModel).toJson(),
      'creationDate': creationDate,
      'avgRating': avgRating,
      'type': type,
      'workspaceImages': workspaceImages
          ?.map((image) => (image as WorkspaceImageModel).toJson())
          .toList(),
      'reviews': reviews,
      'paymentType': paymentType,
    };
  }
}

class LocationModel extends Location {
  LocationModel({
    required super.id,
    super.city,
    super.town,
    super.country,
    required super.longitude,
    required super.latitude,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] ?? '',
      city: json['city'],
      town: json['town'],
      country: json['country'],
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'city': city,
      'town': town,
      'country': country,
      'longitude': longitude,
      'latitude': latitude,
    };
  }
}

class WorkspaceImageModel extends WorkspaceImage {
  WorkspaceImageModel({required super.imageUrl});

  factory WorkspaceImageModel.fromJson(Map<String, dynamic> json) {
    return WorkspaceImageModel(
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
    };
  }
}
