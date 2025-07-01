// lib/features/rooms/data/models/room_model.dart
class RoomModel {
  final String id;
  final String name;
  final String? description;
  final double pricePerHour;
  final String type;
  final int capacity;
  final String status;
  final String workspaceId;
  final int? availableCount;
  final List<String>? images;

  RoomModel({
    required this.id,
    required this.name,
    this.description,
    required this.pricePerHour,
    required this.type,
    required this.capacity,
    required this.status,
    required this.workspaceId,
    this.availableCount,
    this.images,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pricePerHour: (json['pricePerHour'] as num).toDouble(),
      type: json['type'],
      capacity: json['capacity'],
      status: json['status'],
      workspaceId: json['workspaceId'],
      availableCount: json['availableCount'],
      images: json['roomImages'] != null
          ? (json['roomImages'] as List)
          .map((img) => img['imageUrl'] as String)
          .toList()
          : null,
    );
  }
}