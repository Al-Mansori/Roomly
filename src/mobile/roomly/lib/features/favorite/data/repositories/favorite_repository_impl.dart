import '../../domain/entities/favorite_room.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../data_sources/favorite_remote_data_source.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteRemoteDataSource remoteDataSource;
  FavoriteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<FavoriteRoom>> getFavoriteRooms(String userId) async {
    return await remoteDataSource.getFavoriteRooms(userId);
  }

  @override
  Future<void> addToFavorites({required String workspaceId, required String userId, required String roomId}) async {
    await remoteDataSource.addToFavorites(workspaceId: workspaceId, userId: userId, roomId: roomId);
  }
} 