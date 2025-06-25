import 'package:dartz/dartz.dart';
import 'package:roomly/core/error/failures.dart';
import 'package:roomly/features/favorite/domain/repository/favorite_repository.dart';
import '../data_source/favorite_remote_data_source.dart';
import '../../domain/entities/favorite_room_entity.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteRemoteDataSource remoteDataSource;

  FavoriteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<FavoriteRoomEntity>>> getFavoriteRooms(String userId) async {
    try {
      final result = await remoteDataSource.getFavoriteRooms(userId);
      return Right(result);
    } catch (e) {
      return const Left(ServerFailure(message: 'Failed to load favorite rooms'));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavoriteRoom(String userId, String roomId) async {
    try {
      await remoteDataSource.removeFavoriteRoom(userId, roomId);
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure(message: 'Failed to remove favorite room'));
    }
  }

  @override
  Future<Either<Failure, void>> addFavoriteRoom(String userId, String roomId) async {
    try {
      await remoteDataSource.addFavoriteRoom(userId, roomId);
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure(message: 'Failed to add favorite room'));
    }
  }
}




  

