class RoomEntity {
  final int availableCount;
  final int capacity;
  final String description;
  final int pricePerHour;
  final String roomId;
  final String roomName;
  final String roomStatus;
  final String roomType;
  final String workspaceId;
  final String? imageUrl;

  RoomEntity({
    required this.availableCount,
    required this.capacity,
    required this.description,
    required this.pricePerHour,
    required this.roomId,
    required this.roomName,
    required this.roomStatus,
    required this.roomType,
    required this.workspaceId,
    this.imageUrl,
  });

  RoomEntity copyWith({
    int? availableCount,
    int? capacity,
    String? description,
    int? pricePerHour,
    String? roomId,
    String? roomName,
    String? roomStatus,
    String? roomType,
    String? workspaceId,
    String? imageUrl,
  }) {
    return RoomEntity(
      availableCount: availableCount ?? this.availableCount,
      capacity: capacity ?? this.capacity,
      description: description ?? this.description,
      pricePerHour: pricePerHour ?? this.pricePerHour,
      roomId: roomId ?? this.roomId,
      roomName: roomName ?? this.roomName,
      roomStatus: roomStatus ?? this.roomStatus,
      roomType: roomType ?? this.roomType,
      workspaceId: workspaceId ?? this.workspaceId,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

