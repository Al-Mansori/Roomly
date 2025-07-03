import 'package:roomly/features/BookingsStatus/data/data_sources/bookings_remote_data_source.dart';

import '../entities/booking_with_room.dart';
import 'package:dio/dio.dart';

abstract class BookingsRepository {
  Future<List<BookingWithRoom>> getUserBookings(String userId);
  Future<void> cancelReservation(
      {required String reservationId, required String userId});
}

final dio = Dio();
// You can configure dio here if needed
// dio.options.baseUrl = 'https://feminist-abigael-roomly-5d3753ef.koyeb.app/api';
// dio.options.connectTimeout = const Duration(seconds: 5);
// dio.options.receiveTimeout = const Duration(seconds: 3);

final remoteDataSource = BookingsRemoteDataSourceImpl(dio: dio);
