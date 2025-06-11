import '../entities/favorite_room.dart';
import '../repositories/favorite_repository.dart';

class GetFavoriteRooms {
  final FavoriteRepository repository;
  GetFavoriteRooms(this.repository);

  Future<List<FavoriteRoom>> call(String userId) async {
    return await repository.getFavoriteRooms(userId);
  }
} 