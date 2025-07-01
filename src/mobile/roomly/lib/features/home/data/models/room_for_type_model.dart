// lib/features/rooms/data/models/room_model.dart
class RoomModelForType {
  final String id;
  final String name;
  final String? description;
  final double pricePerHour;
  final String type;
  final int capacity;
  final String status;
  final String workspaceId; // Only added here
  final int availableCount;
  final List<String>? images;

  RoomModelForType({
    required this.id,
    required this.name,
    this.description,
    required this.pricePerHour,
    required this.type,
    required this.capacity,
    required this.status,
    required this.workspaceId, // Added here
    required this.availableCount,
    this.images,
  });

  factory RoomModelForType.fromJson(Map<String, dynamic> json) {
    return RoomModelForType(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pricePerHour: (json['pricePerHour'] as num).toDouble(),
      type: json['type'],
      capacity: json['capacity'],
      status: json['status'],
      workspaceId: json['workspaceId'], // Added here
      availableCount: json['availableCount'],
      images: json['roomImages'] != null
          ? (json['roomImages'] as List)
          .map((img) => img['imageUrl'] as String)
          .toList()
          : null,

    );
  }
}