// lib/features/rooms/presentation/cubit/rooms_cubit.dart
import 'package:bloc/bloc.dart';

import '../../../domain/repositories/room_repo.dart';
import '../state/room_state.dart';


class RoomsCubit extends Cubit<RoomsStateForType> {
  final RoomRepository roomRepository;

  RoomsCubit({required this.roomRepository}) : super(RoomsInitialForType());

  Future<void> fetchRoomsByType(String type) async {
    emit(RoomsLoadingForType());
    try {
      final rooms = await roomRepository.getRoomsByType(type);
      emit(RoomsLoadedForType(rooms: rooms));
    } catch (e) {
      emit(RoomsErrorForType(message: e.toString()));
    }
  }
}