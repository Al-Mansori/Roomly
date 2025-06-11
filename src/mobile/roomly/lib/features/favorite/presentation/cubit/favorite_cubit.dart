import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/favorite_room.dart';
import '../../domain/usecases/get_favorite_rooms.dart';

abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<FavoriteRoom> rooms;
  FavoriteLoaded(this.rooms);
}

class FavoriteError extends FavoriteState {
  final String message;
  FavoriteError(this.message);
}

class FavoriteCubit extends Cubit<FavoriteState> {
  final GetFavoriteRooms getFavoriteRooms;
  FavoriteCubit({required this.getFavoriteRooms}) : super(FavoriteInitial());

  Future<void> loadFavorites(String userId) async {
    emit(FavoriteLoading());
    try {
      final rooms = await getFavoriteRooms(userId);
      emit(FavoriteLoaded(rooms));
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }
}
