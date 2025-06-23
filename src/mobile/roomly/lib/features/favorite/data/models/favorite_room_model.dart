import '../../domain/entities/favorite_room_entity.dart';

class FavoriteRoomModel extends FavoriteRoomEntity {
  const FavoriteRoomModel({
    required String roomId,
    required String? workspaceId,
  }) : super(
          roomId: roomId,
          workspaceId: workspaceId,
        );

  factory FavoriteRoomModel.fromJson(Map<String, dynamic> json) {
    return FavoriteRoomModel(
      roomId: json["roomId"],
      workspaceId: json["workspaceId"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "roomId": roomId,
      "workspaceId": workspaceId,
    };
  }
}

