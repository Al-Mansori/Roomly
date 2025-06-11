import '../repositories/favorite_repository.dart';

class AddToFavorites {
  final FavoriteRepository repository;
  AddToFavorites(this.repository);

  Future<void> call(
      {required String workspaceId,
      required String userId,
      required String roomId}) async {
    await repository.addToFavorites(
        workspaceId: workspaceId, userId: userId, roomId: roomId);
  }
}
