// import 'package:roomly/features/room_management/data/models/room_model.dart';
// import 'package:roomly/features/workspace/data/models/image_model.dart';
// import '../../../../core/network/app_api.dart';
// import 'package:dio/dio.dart';

// abstract class RoomRemoteDataSource {
//   Future<RoomModel> getRoomDetails(String roomId);
//   Future<List<ImageModel>> getRoomImages(String roomId);
// }

// class RoomRemoteDataSourceImpl implements RoomRemoteDataSource {
//   final Dio dio;

//   RoomRemoteDataSourceImpl({required this.dio});

//   @override
//   Future<RoomModel> getRoomDetails(String roomId) async {
//     try {
//       final response = await dio.get('${AppApi.baseUrl}/api/customer/room/details', queryParameters: {'roomId': roomId});
//       if (response.data == null) {
//         throw Exception('Failed to load room details: Response data is null');
//       }
//       return RoomModel.fromJson(response.data as Map<String, dynamic>);
//     } catch (e) {
//       throw Exception('Failed to load room details: $e');
//     }
//   }

//   @override
//   Future<List<ImageModel>> getRoomImages(String roomId) async {
//     try {
//       final response = await dio.get('${AppApi.baseUrl}/api/customer/images/room', queryParameters: {'roomId': roomId});
//       return (response.data as List).map((e) => ImageModel.fromJson(e)).toList();
//     } catch (e) {
//       throw Exception('Failed to load room images: $e');
//     }
//   }
// }



// v2 =============================================================


import 'package:roomly/features/room_management/data/models/room_model.dart';
import 'package:roomly/features/workspace/data/models/image_model.dart';
import '../../../../core/network/app_api.dart';
import 'package:dio/dio.dart';

abstract class RoomRemoteDataSource {
  Future<RoomModel> getRoomDetails(String roomId);
  Future<List<ImageModel>> getRoomImages(String roomId);
  Future<bool> checkRoomRecoveryStatus(String roomId);
}

class RoomRemoteDataSourceImpl implements RoomRemoteDataSource {
  final Dio dio;

  RoomRemoteDataSourceImpl({required this.dio});

  @override
  Future<RoomModel> getRoomDetails(String roomId) async {
    try {
      final response = await dio.get('${AppApi.baseUrl}/api/customer/room/details', queryParameters: {'roomId': roomId});
      if (response.data == null) {
        throw Exception('Failed to load room details: Response data is null');
      }
      return RoomModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to load room details: $e');
    }
  }

  @override
  Future<List<ImageModel>> getRoomImages(String roomId) async {
    try {
      final response = await dio.get('${AppApi.baseUrl}/api/customer/images/room', queryParameters: {'roomId': roomId});
      return (response.data as List).map((e) => ImageModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load room images: $e');
    }
  }

  @override
  Future<bool> checkRoomRecoveryStatus(String roomId) async {
    try {
      final response = await dio.get('${AppApi.baseUrl}/api/staff/room/recovery/check', queryParameters: {'roomId': roomId});
      if (response.data == null) {
        throw Exception('Failed to check room recovery status: Response data is null');
      }
      return response.data as bool;
    } catch (e) {
      throw Exception('Failed to check room recovery status: $e');
    }
  }
}


