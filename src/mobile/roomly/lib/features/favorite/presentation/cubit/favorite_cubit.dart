
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_favorite_rooms_usecase.dart';
import '../../domain/usecases/remove_favorite_room_usecase.dart';
import 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final GetFavoriteRoomsUseCase getFavoriteRoomsUseCase;
  final RemoveFavoriteRoomUseCase removeFavoriteRoomUseCase;

  FavoriteCubit({
    required this.getFavoriteRoomsUseCase,
    required this.removeFavoriteRoomUseCase,
  }) : super(FavoriteInitial());

  Future<void> getFavoriteRooms(String userId) async {
    emit(FavoriteLoading());
    final failureOrFavoriteRooms = await getFavoriteRoomsUseCase(userId);
    failureOrFavoriteRooms.fold(
      (failure) => emit(FavoriteError(message: failure.toString())),
      (favoriteRooms) => emit(FavoriteLoaded(favoriteRooms: favoriteRooms)),
    );
  }

  Future<void> removeFavoriteRoom(String userId, String roomId) async {
    final failureOrSuccess = await removeFavoriteRoomUseCase(userId, roomId);
    failureOrSuccess.fold(
      (failure) => emit(FavoriteError(message: failure.toString())),
      (_) => emit(FavoriteRoomRemoved(roomId: roomId)),
    );
  }
}

