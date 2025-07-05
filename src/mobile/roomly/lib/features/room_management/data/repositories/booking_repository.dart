import 'dart:convert';

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/booking_repository_impl.dart';
import 'package:http/http.dart' as http;


class BookingRepositoryImpl implements BookingRepository {
  @override
//   Future<Either<Failure, String>> reserveRoom(BookingRequest request) async {
//     try {

//       final queryParams = {
//         'paymentMethod': request.paymentMethod,
//         'amenitiesCount': request.amenitiesCount.toString(),
//         'startTime': request.startTime,
//         'endTime': request.endTime,
//         'userId': request.userId,
//         'workspaceId': request.workspaceId,
//         'roomId': request.roomId,
//       };

// // Only add loyaltyPoints if it's not null
//       if (request.loyalityPoint != null) {
//         queryParams['loyaltyPoints'] = request.loyalityPoint.toString();
//       }

//       final uri = Uri.parse(
//           'https://feminist-abigael-roomly-5d3753ef.koyeb.app/api/customer/reserve'
//       ).replace(queryParameters: queryParams);

//       final response = await http.post(
//         uri,
//         headers: {
//           'Content-Type': 'application/json',
//         },
//       );

// // 🧪 طباعة كل التفاصيل لو حصل خطأ
//       print("📤 Sent data:");
//       print(json.encode({
//         'paymentMethod': request.paymentMethod,
//         'amenitiesCount': request.amenitiesCount,
//         'startTime': request.startTime,
//         'endTime': request.endTime,
//         'userId': request.userId,
//         'workspaceId': request.workspaceId,
//         'roomId': request.roomId,
//       }));

//       print("📥 Response status: ${response.statusCode}");
//       print("📥 Response body: ${response.body}");

//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
//         final reservationId = responseData['reservationId'] as String;
//         return Right(reservationId);
//       } else {
//         return Left(ServerFailure(message: 'Failed to reserve room: ${response.body}'));
//       }
//     } catch (e) {
//       return Left(ServerFailure( message: e.toString()));
//     }
//   }

  Future<Either<Failure, String>> reserveRoom(BookingRequest request) async {
    try {
      print("🔍 [DEBUG] Starting reserveRoom()");

      print("📥 [DEBUG] Received BookingRequest:");
      print("       Payment Method: ${request.paymentMethod}");
      print("       Amenities Count: ${request.amenitiesCount}");
      print("       Start Time: ${request.startTime}");
      print("       End Time: ${request.endTime}");
      print("       User ID: ${request.userId}");
      print("       Workspace ID: ${request.workspaceId}");
      print("       Room ID: ${request.roomId}");
      print("       Reservation Type: ${request.reservationType}");
      print("       Loyalty Points: ${request.loyalityPoint}");

      final baseUrl = 'https://feminist-abigael-roomly-5d3753ef.koyeb.app/api/customer/reserve';

      final rawQueryParams = [
        'paymentMethod=${request.paymentMethod}',
        'amenitiesCount=${request.amenitiesCount}',
        'startTime=${request.startTime}',
        'endTime=${request.endTime}',
        'userId=${request.userId}',
        'workspaceId=${request.workspaceId}',
        'reservationType=${request.reservationType}',
        'roomId=${request.roomId}',
      ];

      if (request.loyalityPoint != null && request.loyalityPoint != 0) {
        rawQueryParams.add('loyaltyPoints=${request.loyalityPoint}');
      }

      print("🧱 [DEBUG] Constructed query parameters:");
      rawQueryParams.forEach((param) {
        print("       $param");
      });

      final fullUrl = '$baseUrl?${rawQueryParams.join('&')}';

      print("🌐 [DEBUG] Manually constructed URL: $fullUrl");

      final uri = Uri.parse(fullUrl);

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );


      print("📤 [DEBUG] POST request sent");
      print("       Headers: ${{'Content-Type': 'application/json'}}");

      print("📥 [DEBUG] Response received:");
      print("       Status Code: ${response.statusCode}");
      print("       Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final reservationId = responseData['reservationId'] as String?;
        if (reservationId == null) {
          print("⚠️ [DEBUG] Response did not contain reservationId");
          return Left(ServerFailure(message: 'Reservation ID not found in response.'));
        }
        print("✅ [DEBUG] Reservation successful! ID: $reservationId");
        return Right(reservationId);
      } else {
        print("❌ [DEBUG] Server responded with an error: ${response.body}");
        return Left(ServerFailure(message: 'Failed to reserve room: ${response.body}'));
      }
    } catch (e, stackTrace) {
      print("💥 [DEBUG] Exception caught: $e");
      print("🧱 [DEBUG] StackTrace: $stackTrace");
      return Left(ServerFailure(message: e.toString()));
    }
  }
}