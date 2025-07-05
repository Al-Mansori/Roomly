import 'package:equatable/equatable.dart';

class RoomImageEntity extends Equatable {
  final String imageUrl;

  const RoomImageEntity({required this.imageUrl});

  @override
  List<Object?> get props => [imageUrl];
}

class RoomEntity extends Equatable {
  final String id;
  final String name;
  final String type;
  final String description;
  final int capacity;
  final int availableCount;
  final double pricePerHour;
  final String status;
  final List<RoomImageEntity> roomImages;

  const RoomEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.capacity,
    required this.availableCount,
    required this.pricePerHour,
    required this.status,
    required this.roomImages,
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
        roomImages,
      ];
}

class TopRoomEntity extends Equatable {
  final RoomEntity room;
  final String workspaceId;

  const TopRoomEntity({required this.room, required this.workspaceId});

  @override
  List<Object?> get props => [room, workspaceId];
}


