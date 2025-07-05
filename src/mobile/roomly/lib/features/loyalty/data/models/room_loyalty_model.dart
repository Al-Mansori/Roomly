
import 'package:roomly/features/loyalty/domain/entities/room_loyalty_entity.dart';

class RoomImageModel extends RoomImageEntity {
  const RoomImageModel({required super.imageUrl});

  factory RoomImageModel.fromJson(Map<String, dynamic> json) {
    return RoomImageModel(
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
    };
  }
}

class RoomModel extends RoomEntity {
  const RoomModel({
    required super.id,
    required super.name,
    required super.type,
    required super.description,
    required super.capacity,
    required super.availableCount,
    required super.pricePerHour,
    required super.status,
    required super.roomImages,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      description: json['description'] as String? ?? '',
      capacity: json['capacity'] as int? ?? 0,
      availableCount: json['availableCount'] as int? ?? 0,
      pricePerHour: (json['pricePerHour'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? '',
      roomImages: (json['roomImages'] as List<dynamic>?)
              ?.map((e) => RoomImageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
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
      'roomImages': roomImages.map((e) => (e as RoomImageModel).toJson()).toList(),
    };
  }

  RoomEntity toEntity() {
    return RoomEntity(
      id: id,
      name: name,
      type: type,
      description: description,
      capacity: capacity,
      availableCount: availableCount,
      pricePerHour: pricePerHour,
      status: status,
      roomImages: roomImages,
    );
  }
}

class TopRoomModel extends TopRoomEntity {
  const TopRoomModel({required super.room, required super.workspaceId});

  factory TopRoomModel.fromJson(Map<String, dynamic> json) {
    return TopRoomModel(
      room: RoomModel.fromJson(json['room'] as Map<String, dynamic>),
      workspaceId: json['workspaceId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'room': (room as RoomModel).toJson(),
      'workspaceId': workspaceId,
    };
  }

  TopRoomEntity toEntity() {
    return TopRoomEntity(
      room: room,
      workspaceId: workspaceId,
    );
  }
}


