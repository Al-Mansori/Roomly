import 'package:dartz/dartz.dart';
import 'package:roomly/core/error/failures.dart';
import 'package:roomly/features/favorite/domain/repository/favorite_repository.dart';
import '../entities/favorite_room_entity.dart';

class GetFavoriteRoomsUseCase {
  final FavoriteRepository repository;

  GetFavoriteRoomsUseCase(this.repository);

  Future<Either<Failure, List<FavoriteRoomEntity>>> call(String userId) async {
    return await repository.getFavoriteRooms(userId);
  }
}

