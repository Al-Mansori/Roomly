import 'package:dio/dio.dart';
import '../models/booking_model.dart';

abstract class BookingsRemoteDataSource {
  Future<List<Map<String, dynamic>>> getUserBookings(String userId);
}

class BookingsRemoteDataSourceImpl implements BookingsRemoteDataSource {
  final Dio dio;
  final String baseUrl =
      'https://feminist-abigael-roomly-5d3753ef.koyeb.app/api';

  BookingsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<Map<String, dynamic>>> getUserBookings(String userId) async {
    try {
      final response = await dio.get(
        '$baseUrl/customer/reservations/user/$userId',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList
            .map((json) => {
                  'reservation': BookingModel.fromJson(json['reservation']),
                  'roomId': json['roomId'],
                  'workspaceId': json['workspaceId'],
                })
            .toList();
      } else {
        throw Exception('Failed to load bookings');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load bookings: ${e.message}');
    }
  }
}
