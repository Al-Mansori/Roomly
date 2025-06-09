import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomly/features/room_management/domain/usecases/get_room_details_usecase.dart';
import 'package:roomly/features/room_management/domain/usecases/get_room_images_usecase.dart';
import 'package:roomly/features/room_management/presentation/cubits/room_details_state.dart';

class RoomDetailsCubit extends Cubit<RoomDetailsState> {
  final GetRoomDetailsUseCase getRoomDetailsUseCase;
  final GetRoomImagesUseCase getRoomImagesUseCase;

  RoomDetailsCubit({
    required this.getRoomDetailsUseCase,
    required this.getRoomImagesUseCase,
  }) : super(RoomDetailsInitial());

  Future<void> getRoomDetails(String roomId) async {
    emit(RoomDetailsLoading());
    try {
      final room = await getRoomDetailsUseCase(roomId);
      final images = await getRoomImagesUseCase(roomId);
      emit(RoomDetailsLoaded(room: room, images: images));
    } catch (e) {
      emit(RoomDetailsError(message: e.toString()));
    }
  }
}

