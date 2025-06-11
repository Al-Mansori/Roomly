import '../../domain/entities/favorite_room.dart';

class FavoriteRoomModel extends FavoriteRoom {
  FavoriteRoomModel({
    required String roomId,
    required String workspaceId,
    required String name,
    required String description,
    required String imageUrl,
    required bool isFavorite,
  }) : super(
    roomId: roomId,
    workspaceId: workspaceId,
    name: name,
    description: description,
    imageUrl: imageUrl,
    isFavorite: isFavorite,
  );

  factory FavoriteRoomModel.fromJson(Map<String, dynamic> json) {
    return FavoriteRoomModel(
      roomId: json['roomId'],
      workspaceId: json['workspaceId'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      isFavorite: true,
    );
  }
} 