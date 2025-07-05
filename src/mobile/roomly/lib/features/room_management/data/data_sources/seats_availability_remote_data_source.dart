import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../models/seats_availability_model.dart';

abstract class SeatsAvailabilityRemoteDataSource {
  Future<List<SeatsAvailabilityModel>> checkAvailability({
    required String roomId,
    required DateTime date,
  });
}
// data/datasources/remote/room_availability_remote_data_source_impl.dart
class SeatsAvailabilityRemoteDataSourceImpl
    implements SeatsAvailabilityRemoteDataSource {
  final Dio dio;

  SeatsAvailabilityRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<SeatsAvailabilityModel>> checkAvailability({
    required String roomId,
    required DateTime date,
  }) async {
    final response = await dio.get(
      'https://feminist-abigael-roomly-5d3753ef.koyeb.app/api/customer/room/availability',
      queryParameters: {
        'roomId': roomId,
        'date': DateFormat('yyyy-MM-dd').format(date),
      },
    );

    return (response.data as List)
        .map((json) => SeatsAvailabilityModel.fromJson(json))
        .toList();
  }
}