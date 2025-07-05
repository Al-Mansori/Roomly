// data/repositories/operating_hours_repository_impl.dart
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/operating_entites.dart';
import '../../domain/repositories/open_hours_repo.dart';

class OperatingHoursRepositoryImpl implements OperatingHoursRepository {
  final Dio dio;

  OperatingHoursRepositoryImpl({required this.dio});

  @override
  Future<OperatingHours> getOperatingHours({
    required String workspaceId,
    required DateTime date,
  }) async {
    try {
      final response = await dio.get(
        'https://feminist-abigael-roomly-5d3753ef.koyeb.app/api/customer/workspace/operating-hours',
        queryParameters: {
          'workspaceId': workspaceId,
          'date': DateFormat('yyyy-MM-dd').format(date),
        },
      );

      return OperatingHours(
        startTime: DateTime.parse(response.data['startTime']),
        endTime: DateTime.parse(response.data['endTime']),
      );
    } catch (e) {
      throw Exception('Failed to fetch operating hours: $e');
    }
  }
}