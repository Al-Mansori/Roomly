
import 'package:dartz/dartz.dart';
import 'package:roomly/core/error/failures.dart';
import 'package:roomly/features/favorite/domain/repository/favorite_repository.dart';

class RemoveFavoriteRoomUseCase {
  final FavoriteRepository repository;

  RemoveFavoriteRoomUseCase(this.repository);

  Future<Either<Failure, void>> call(String userId, String roomId) async {
    return await repository.removeFavoriteRoom(userId, roomId);
  }
}

