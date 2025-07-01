import 'package:equatable/equatable.dart';

class Workspace extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? address;
  final String city;
  final String? town;
  final String type;
  final double rating;
  final double? distanceKm;
  final String? priceRange;
  final List<String>? amenities;
  final String? matchReason;
  final DateTime? creationDate;
  final List<Room>? rooms;
  final List<String> images; // Changed to support multiple images

  const Workspace({
    required this.id,
    required this.name,
    this.description,
    this.address,
    required this.city,
    this.town,
    required this.type,
    required this.rating,
    this.distanceKm,
    this.priceRange,
    this.amenities,
    this.matchReason,
    this.creationDate,
    this.rooms,
    this.images = const [], // Default empty list
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    address,
    city,
    town,
    type,
    rating,
    distanceKm,
    priceRange,
    amenities,
    matchReason,
    creationDate,
    rooms,
    images,
  ];

  Workspace copyWith({
    String? id,
    String? name,
    String? description,
    String? address,
    String? city,
    String? town,
    String? type,
    double? rating,
    double? distanceKm,
    String? priceRange,
    List<String>? amenities,
    String? matchReason,
    DateTime? creationDate,
    List<Room>? rooms,
    List<String>? images,
  }) {
    return Workspace(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      city: city ?? this.city,
      town: town ?? this.town,
      type: type ?? this.type,
      rating: rating ?? this.rating,
      distanceKm: distanceKm ?? this.distanceKm,
      priceRange: priceRange ?? this.priceRange,
      amenities: amenities ?? this.amenities,
      matchReason: matchReason ?? this.matchReason,
      creationDate: creationDate ?? this.creationDate,
      rooms: rooms ?? this.rooms,
      images: images ?? this.images,
    );
  }

  String get primaryImage => images.isNotEmpty ? images.first : '';
}

class Room extends Equatable {
  final String id;
  final String name;
  final String type;
  final String? description;
  final int capacity;
  final int availableCount;
  final double pricePerHour;
  final String status;
  final List<String>? amenities;
  final List<String> images; // Changed from RoomImage to simple strings
  final List<String>? offers;
  final String? rating;

  const Room({
    required this.id,
    required this.name,
    required this.type,
    this.description,
    required this.capacity,
    required this.availableCount,
    required this.pricePerHour,
    required this.status,
    this.amenities,
    this.images = const [], // Default empty list
    this.offers,
    this.rating
  });

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    description,
    capacity,
    availableCount,
    pricePerHour,
    status,
    amenities,
    images,
    offers,
  ];

  Room copyWith({
    String? id,
    String? name,
    String? type,
    String? description,
    int? capacity,
    int? availableCount,
    double? pricePerHour,
    String? status,
    List<String>? amenities,
    List<String>? images,
    List<String>? offers,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      capacity: capacity ?? this.capacity,
      availableCount: availableCount ?? this.availableCount,
      pricePerHour: pricePerHour ?? this.pricePerHour,
      status: status ?? this.status,
      amenities: amenities ?? this.amenities,
      images: images ?? this.images,
      offers: offers ?? this.offers,
    );
  }

  String get primaryImage => images.isNotEmpty ? images.first : '';
}

// Simplified image classes since we're now handling lists directly
class WorkspaceImage extends Equatable {
  final String workspaceId;
  final List<String> imageUrls;

  const WorkspaceImage({
    required this.workspaceId,
    required this.imageUrls,
  });

  @override
  List<Object?> get props => [workspaceId, imageUrls];
}