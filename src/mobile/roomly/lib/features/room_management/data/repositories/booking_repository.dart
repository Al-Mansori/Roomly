import 'dart:convert';

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/booking_repository_impl.dart';
import 'package:http/http.dart' as http;


class BookingRepositoryImpl implements BookingRepository {
  @override
  Future<Either<Failure, String>> reserveRoom(BookingRequest request) async {
    try {

      final uri = Uri.parse(
          'https://feminist-abigael-roomly-5d3753ef.koyeb.app/api/customer/reserve'
      ).replace(queryParameters: {
        'paymentMethod': request.paymentMethod,
        'amenitiesCount': request.amenitiesCount.toString(),
        'startTime': request.startTime,
        'endTime': request.endTime,
        'userId': request.userId,
        'workspaceId': request.workspaceId,
        'roomId': request.roomId,
      });

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      final queryUrl = Uri.parse(
          'https://feminist-abigael-roomly-5d3753ef.koyeb.app/api/customer/reserve?' +
              'paymentMethod=${request.paymentMethod}&' +
              'amenitiesCount=${request.amenitiesCount}&' +
              'startTime=${request.startTime}&' +
              'endTime=${request.endTime}&' +
              'userId=${request.userId}&' +
              'workspaceId=${request.workspaceId}&' +
              'roomId=${request.roomId}'
      );
      print("🌐 Full URL with query params: $queryUrl");

// 🧪 طباعة كل التفاصيل لو حصل خطأ
      print("📤 Sent data:");
      print(json.encode({
        'paymentMethod': request.paymentMethod,
        'amenitiesCount': request.amenitiesCount,
        'startTime': request.startTime,
        'endTime': request.endTime,
        'userId': request.userId,
        'workspaceId': request.workspaceId,
        'roomId': request.roomId,
      }));

      print("📥 Response status: ${response.statusCode}");
      print("📥 Response body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final reservationId = responseData['reservationId'] as String;
        return Right(reservationId);
      } else {
        return Left(ServerFailure(message: 'Failed to reserve room: ${response.body}'));
      }
    } catch (e) {
      return Left(ServerFailure( message: e.toString()));
    }
  }
}