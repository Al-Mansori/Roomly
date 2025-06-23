import 'package:equatable/equatable.dart';
import '../../domain/entities/favorite_room_entity.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<FavoriteRoomEntity> favoriteRooms;

  const FavoriteLoaded({required this.favoriteRooms});

  @override
  List<Object> get props => [favoriteRooms];
}

class FavoriteError extends FavoriteState {
  final String message;

  const FavoriteError({required this.message});

  @override
  List<Object> get props => [message];
}

class FavoriteRoomRemoved extends FavoriteState {
  final String roomId;

  const FavoriteRoomRemoved({required this.roomId});

  @override
  List<Object> get props => [roomId];
}

