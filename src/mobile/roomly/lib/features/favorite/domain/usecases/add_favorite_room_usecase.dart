import 'package:dartz/dartz.dart';
import 'package:roomly/core/error/failures.dart';
import 'package:roomly/features/favorite/domain/repository/favorite_repository.dart';

class AddFavoriteRoomUseCase {
  final FavoriteRepository repository;

  AddFavoriteRoomUseCase({required this.repository});

  Future<Either<Failure, void>> call(AddFavoriteRoomParams params) async {
    return await repository.addFavoriteRoom(params.userId, params.roomId);
  }
}

class AddFavoriteRoomParams {
  final String userId;
  final String roomId;

  AddFavoriteRoomParams({required this.userId, required this.roomId});
}
