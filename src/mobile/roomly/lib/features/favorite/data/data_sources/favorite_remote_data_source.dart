import 'package:dio/dio.dart';
import '../models/favorite_room_model.dart';
import '../../../BookingsStatus/data/data_sources/room_remote_data_source.dart';

class FavoriteRemoteDataSource {
  final Dio dio;
  final RoomRemoteDataSource roomRemoteDataSource;
  final String baseUrl = 'https://feminist-abigael-roomly-5d3753ef.koyeb.app/api/users';

  FavoriteRemoteDataSource({required this.dio, required this.roomRemoteDataSource});

  Future<List<FavoriteRoomModel>> getFavoriteRooms(String userId) async {
    final response = await dio.get('$baseUrl/get-favorites', queryParameters: {'userId': userId});
    final List<dynamic> data = response.data;
    List<FavoriteRoomModel> result = [];
    for (final item in data) {
      final roomId = item['roomId'];
      final workspaceId = item['workspaceId'];
      // Fetch room details (name, description, imageUrl) from room API
      final roomDetails = await roomRemoteDataSource.getRoomDetails(roomId);
      result.add(FavoriteRoomModel(
        roomId: roomId,
        workspaceId: workspaceId,
        name: roomDetails.name,
        description: roomDetails.description,
        imageUrl: roomDetails.imageUrl,
        isFavorite: true,
      ));
    }
    return result;
  }

  Future<void> addToFavorites({required String workspaceId, required String userId, required String roomId}) async {
    await dio.post('$baseUrl/add-favorites', queryParameters: {
      'workspaceId': workspaceId,
      'userId': userId,
      'roomId': roomId,
    });
  }
} 