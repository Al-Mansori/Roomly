import '../entities/favorite_room.dart';

abstract class FavoriteRepository {
  Future<List<FavoriteRoom>> getFavoriteRooms(String userId);
  Future<void> addToFavorites({required String workspaceId, required String userId, required String roomId});
} 