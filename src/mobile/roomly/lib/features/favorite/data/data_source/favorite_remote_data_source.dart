// import 'package:dio/dio.dart';
// import '../models/favorite_room_model.dart';

// abstract class FavoriteRemoteDataSource {
//   Future<List<FavoriteRoomModel>> getFavoriteRooms(String userId);
//   Future<void> removeFavoriteRoom(String userId, String roomId);
// }

// class FavoriteRemoteDataSourceImpl implements FavoriteRemoteDataSource {
//   final Dio dio;

//   FavoriteRemoteDataSourceImpl({required this.dio});

//   @override
//   Future<List<FavoriteRoomModel>> getFavoriteRooms(String userId) async {
//     final response = await dio.get(
//         'https://feminist-abigael-roomly-5d3753ef.koyeb.app/api/users/get-favorites?userId=$userId');

//     if (response.statusCode == 200) {
//       final List<dynamic> favoriteRoomsJson = response.data;
//       return favoriteRoomsJson
//           .map((json) => FavoriteRoomModel.fromJson(json))
//           .toList();
//     } else {
//       throw Exception('Failed to load favorite rooms');
//     }
//   }

//   @override
//   Future<void> removeFavoriteRoom(String userId, String roomId) async {
//     final response = await dio.delete(
//         'https://feminist-abigael-roomly-5d3753ef.koyeb.app/api/users/remove-favorite-room?userId=$userId&roomId=$roomId');

//     if (response.statusCode != 200) {
//       throw Exception('Failed to remove favorite room');
//     }
//   }
// }



// v5 -------------------------------------------------------------------------------


import 'package:dio/dio.dart';
import '../models/favorite_room_model.dart';

abstract class FavoriteRemoteDataSource {
  Future<List<FavoriteRoomModel>> getFavoriteRooms(String userId);
  Future<void> removeFavoriteRoom(String userId, String roomId);
  Future<void> addFavoriteRoom(String userId, String roomId);
}

class FavoriteRemoteDataSourceImpl implements FavoriteRemoteDataSource {
  final Dio dio;

  FavoriteRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<FavoriteRoomModel>> getFavoriteRooms(String userId) async {
    final response = await dio.get(
        'https://feminist-abigael-roomly-5d3753ef.koyeb.app/api/users/get-favorites?userId=$userId');

    if (response.statusCode == 200) {
      final List<dynamic> favoriteRoomsJson = response.data;
      return favoriteRoomsJson
          .map((json) => FavoriteRoomModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load favorite rooms');
    }
  }

  @override
  Future<void> removeFavoriteRoom(String userId, String roomId) async {
    final response = await dio.delete(
        'https://feminist-abigael-roomly-5d3753ef.koyeb.app/api/users/remove-favorite-room?userId=$userId&roomId=$roomId');

    if (response.statusCode != 200) {
      throw Exception('Failed to remove favorite room');
    }
  }
  
  @override
  Future<void> addFavoriteRoom(String userId, String roomId) async {
    final response = await dio.post(
        'https://feminist-abigael-roomly-5d3753ef.koyeb.app/api/users/add-favorite-room?userId=$userId&roomId=$roomId');

    if (response.statusCode != 200) {
      throw Exception('Failed to add favorite room');
    }
  }
}



  

