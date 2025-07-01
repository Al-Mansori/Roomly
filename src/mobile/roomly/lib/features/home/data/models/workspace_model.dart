import '../../domain/entities/workspace.dart';

import '../../domain/entities/workspace.dart';

class WorkspaceModel extends Workspace {
  const WorkspaceModel({
    required super.id,
    required super.name,
    super.description,
    super.address,
    required super.city,
    super.town,
    required super.type,
    required super.rating,
    super.distanceKm,
    super.priceRange,
    super.amenities,
    super.matchReason,
    super.creationDate,
    super.rooms,
    super.images, // Added images list
  });

  // Factory for nearby workspaces API
  factory WorkspaceModel.fromNearbyJson(Map<String, dynamic> json) {
    return WorkspaceModel(
      id: json['workspace_id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown Workspace',
      city: json['city']?.toString() ?? '',
      type: json['type']?.toString() ?? 'General',
      rating: _parseDouble(json['rating']),
      distanceKm: _parseDouble(json['distance_km']),
      images: json['images'] != null
          ? (json['images'] as List).map((img) => img['url']?.toString() ?? '').toList()
          : [],
    );
  }

  // Factory for top rated workspaces API
  factory WorkspaceModel.fromTopRatedJson(Map<String, dynamic> json) {
    return WorkspaceModel(
      id: json['workspace_id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown Workspace',
      city: json['city']?.toString() ?? '',
      town: json['town']?.toString(),
      type: json['type']?.toString() ?? 'General',
      rating: _parseDouble(json['avg_rating']),
      priceRange: json['price_range']?.toString(),
      amenities: json['amenities'] != null
          ? List<String>.from(json['amenities'].map((a) => a?.toString() ?? ''))
          : null,
      matchReason: json['match_reason']?.toString(),
      images: json['images'] != null
          ? List<String>.from(json['images'].map((img) {
        if (img is Map && img['url'] != null) return img['url'].toString();
        if (img is String) return img;
        return '';
      }))
          : [],

    );
  }

  // Factory for workspace details API
  factory WorkspaceModel.fromDetailsJson(Map<String, dynamic> json) {
    return WorkspaceModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown Workspace',
      description: json['description']?.toString(),
      address: json['address']?.toString(),
      city: json['city']?.toString() ?? '',
      type: json['type']?.toString() ?? 'General',
      rating: _parseDouble(json['avgRating']),
      creationDate: json['creationDate'] != null
          ? DateTime.tryParse(json['creationDate'].toString())
          : null,
      rooms: json['rooms'] != null
          ? (json['rooms'] as List).map((r) => RoomModel.fromJson(r)).toList()
          : null,
      images: json['images'] != null
          ? List<String>.from(json['images'].map((img) {
        if (img is Map && img['url'] != null) return img['url'].toString();
        if (img is String) return img;
        return '';
      }))
          : [],

    );
  }

  // Convert to JSON for local storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'city': city,
      'town': town,
      'type': type,
      'rating': rating,
      'distance_km': distanceKm,
      'price_range': priceRange,
      'amenities': amenities?.join(','),
      'match_reason': matchReason,
      'creation_date': creationDate?.toIso8601String(),
      'images': images?.join('||'), // Using double pipe as separator
    };
  }

  // Factory from local JSON
  factory WorkspaceModel.fromLocalJson(Map<String, dynamic> json) {
    print("📥 Received JSON in fromJson: $json"); // ✅ هنا الطباعه

    return WorkspaceModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown Workspace',
      description: json['description']?.toString(),
      address: json['address']?.toString(),
      city: json['city']?.toString() ?? '',
      town: json['town']?.toString(),
      type: json['type']?.toString() ?? 'General',
      rating: _parseDouble(json['rating']),
      distanceKm: _parseDouble(json['distance_km']),
      priceRange: json['price_range']?.toString(),
      amenities: json['amenities']?.toString()?.split(','),
      matchReason: json['match_reason']?.toString(),
      creationDate: json['creation_date'] != null
          ? DateTime.tryParse(json['creation_date'].toString())
          : null,
      images: json['images']?.toString()?.split('||') ?? [],
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}

class RoomModel extends Room {
  const RoomModel({
    required super.id,
    required super.name,
    required super.type,
    super.description,
    required super.capacity,
    required super.availableCount,
    required super.pricePerHour,
    required super.status,
    super.amenities,
    super.images, // Changed from roomImages to images
    super.offers,
  });


  factory RoomModel.fromJson(Map<String, dynamic> json) {
    print("📥 Received JSON in fromJson: $json"); // ✅ هنا الطباعه
    final roomImages = (json['roomImages'] as List?) ?? [];

    final parsedImages = roomImages
        .whereType<Map<String, dynamic>>()
        .map((img) => img['imageUrl'] as String)
        .toList();

    return RoomModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown Room',
      type: json['type']?.toString() ?? 'General',
      description: json['description']?.toString(),
      capacity: json['capacity'] as int? ?? 0,
      availableCount: json['availableCount'] as int? ?? 0,
      pricePerHour: WorkspaceModel._parseDouble(json['pricePerHour']),
      status: json['status']?.toString() ?? 'available',
      amenities: json['amenities'] != null
          ? List<String>.from(json['amenities'].map((a) => a?.toString() ?? ''))
          : null,
      images: parsedImages, // Provide empty list instead of null
      offers: json['offers'] != null
          ? List<String>.from(json['offers'].map((o) => o?.toString() ?? ''))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
      'capacity': capacity,
      'available_count': availableCount,
      'price_per_hour': pricePerHour,
      'status': status,
      'amenities': amenities?.join(','),
      'offers': offers?.join(','),
      'images': images?.join('||'),
    };
  }

  factory RoomModel.fromLocalJson(Map<String, dynamic> json) {
    final List<String> parsedImages = json['images']?.toString().split('||') ?? [];

    return RoomModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown Room',
      type: json['type']?.toString() ?? 'General',
      description: json['description']?.toString(),
      capacity: json['capacity'] as int? ?? 0,
      availableCount: json['available_count'] as int? ?? 0,
      pricePerHour: WorkspaceModel._parseDouble(json['price_per_hour']),
      status: json['status']?.toString() ?? 'available',
      amenities: json['amenities']?.toString()?.split(','),
      offers: json['offers']?.toString()?.split(','),
      images: parsedImages,
    );
  }
}

// Simplified image models since we're handling lists directly in Workspace/Room
class WorkspaceImageModel {
  final String workspaceId;
  final List<String> urls;

  const WorkspaceImageModel({
    required this.workspaceId,
    required this.urls,
  });

  factory WorkspaceImageModel.fromJson(Map<String, dynamic> json) {
    return WorkspaceImageModel(
      workspaceId: json['workspaceId']?.toString() ?? '',
      urls: json['images'] != null
          ? (json['images'] as List).map((i) => i['url']?.toString() ?? '').toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workspace_id': workspaceId,
      'images': urls.map((url) => {'url': url}).toList(),
    };
  }
}