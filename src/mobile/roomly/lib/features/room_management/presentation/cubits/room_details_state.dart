import 'package:equatable/equatable.dart';
import 'package:roomly/features/room_management/domain/entities/room_entity.dart';
import 'package:roomly/features/workspace/domain/entities/image_entity.dart';

abstract class RoomDetailsState extends Equatable {
  const RoomDetailsState();

  @override
  List<Object?> get props => [];
}

class RoomDetailsInitial extends RoomDetailsState {}

class RoomDetailsLoading extends RoomDetailsState {}

class RoomDetailsLoaded extends RoomDetailsState {
  final RoomEntity room;
  final List<ImageEntity> images;

  const RoomDetailsLoaded({required this.room, required this.images});

  @override
  List<Object?> get props => [room, images];
}

class RoomDetailsError extends RoomDetailsState {
  final String message;

  const RoomDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}

