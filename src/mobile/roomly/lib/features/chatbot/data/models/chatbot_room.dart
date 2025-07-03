// class Room {
//   final int availableCount;
//   final int capacity;
//   final String description;
//   final int pricePerHour;
//   final String roomId;
//   final String roomName;
//   final String roomStatus;
//   final String roomType;
//   final String workspaceId;
//   final String? imageUrl;

//   Room({
//     required this.availableCount,
//     required this.capacity,
//     required this.description,
//     required this.pricePerHour,
//     required this.roomId,
//     required this.roomName,
//     required this.roomStatus,
//     required this.roomType,
//     required this.workspaceId,
//     this.imageUrl,
//   });

//   factory Room.fromJson(Map<String, dynamic> json) {
//     return Room(
//       availableCount: json['available_count'] ?? 0,
//       capacity: json['capacity'] ?? 0,
//       description: json['description'] ?? '',
//       pricePerHour: json['price_per_hour'] ?? 0,
//       roomId: json['room_id'] ?? '',
//       roomName: json['room_name'] ?? '',
//       roomStatus: json['room_status'] ?? '',
//       roomType: json['room_type'] ?? '',
//       workspaceId: json['workspace_id'] ?? '',
//       imageUrl: json['imageUrl'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'available_count': availableCount,
//       'capacity': capacity,
//       'description': description,
//       'price_per_hour': pricePerHour,
//       'room_id': roomId,
//       'room_name': roomName,
//       'room_status': roomStatus,
//       'room_type': roomType,
//       'workspace_id': workspaceId,
//       'imageUrl': imageUrl,
//     };
//   }

//   Room copyWith({
//     int? availableCount,
//     int? capacity,
//     String? description,
//     int? pricePerHour,
//     String? roomId,
//     String? roomName,
//     String? roomStatus,
//     String? roomType,
//     String? workspaceId,
//     String? imageUrl,
//   }) {
//     return Room(
//       availableCount: availableCount ?? this.availableCount,
//       capacity: capacity ?? this.capacity,
//       description: description ?? this.description,
//       pricePerHour: pricePerHour ?? this.pricePerHour,
//       roomId: roomId ?? this.roomId,
//       roomName: roomName ?? this.roomName,
//       roomStatus: roomStatus ?? this.roomStatus,
//       roomType: roomType ?? this.roomType,
//       workspaceId: workspaceId ?? this.workspaceId,
//       imageUrl: imageUrl ?? this.imageUrl,
//     );
//   }
// }


// v2 ------------------------------------------------------------------------------


class Room {
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

  Room({
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

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      availableCount: (json["available_count"] as num?)?.toInt() ?? 0,
      capacity: (json["capacity"] as num?)?.toInt() ?? 0,
      description: json["description"] ?? "",
      pricePerHour: (json["price_per_hour"] as num?)?.toInt() ?? 0,
      roomId: json['room_id'] ?? '',
      roomName: json['room_name'] ?? '',
      roomStatus: json['room_status'] ?? '',
      roomType: json['room_type'] ?? '',
      workspaceId: json['workspace_id'] ?? '',
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'available_count': availableCount,
      'capacity': capacity,
      'description': description,
      'price_per_hour': pricePerHour,
      'room_id': roomId,
      'room_name': roomName,
      'room_status': roomStatus,
      'room_type': roomType,
      'workspace_id': workspaceId,
      'imageUrl': imageUrl,
    };
  }

  Room copyWith({
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
    return Room(
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

