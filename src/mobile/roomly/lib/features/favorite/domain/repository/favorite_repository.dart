import 'package:dartz/dartz.dart';
import 'package:roomly/core/error/failures.dart';
import '../entities/favorite_room_entity.dart';

abstract class FavoriteRepository {
  Future<Either<Failure, List<FavoriteRoomEntity>>> getFavoriteRooms(String userId);
  Future<Either<Failure, void>> removeFavoriteRoom(String userId, String roomId);
  Future<Either<Failure, void>> addFavoriteRoom(String userId, String roomId);
}


