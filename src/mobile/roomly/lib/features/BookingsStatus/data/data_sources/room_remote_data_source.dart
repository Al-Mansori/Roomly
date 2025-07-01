import 'package:dio/dio.dart';
import '../../domain/entities/room_details.dart';

class RoomRemoteDataSource {
  final Dio dio;
  RoomRemoteDataSource({required this.dio});

  Future<RoomDetails> getRoomDetails(String roomId) async {
    final response = await dio.get(
      'https://feminist-abigael-roomly-5d3753ef.koyeb.app/api/customer/room/details?roomId=$roomId',
    );
    return RoomDetails.fromJson(response.data);
  }
}
