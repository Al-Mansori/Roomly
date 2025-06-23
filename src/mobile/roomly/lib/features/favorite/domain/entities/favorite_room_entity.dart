import 'package:equatable/equatable.dart';

class FavoriteRoomEntity extends Equatable {
  final String roomId;
  final String? workspaceId;

  const FavoriteRoomEntity({
    required this.roomId,
    required this.workspaceId,
  });

  @override
  List<Object?> get props => [roomId, workspaceId];
}

