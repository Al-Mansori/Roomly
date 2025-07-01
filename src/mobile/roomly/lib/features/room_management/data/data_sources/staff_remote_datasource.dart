// staff_remote_data_source.dart
import 'package:dio/dio.dart';

abstract class StaffRemoteDataSource {
  Future<String?> getStaffIdByWorkspaceId(String workspaceId);
}

// staff_remote_data_source_impl.dart
class StaffRemoteDataSourceImpl implements StaffRemoteDataSource {
  final Dio dio;

  StaffRemoteDataSourceImpl({required this.dio});

  @override
  Future<String?> getStaffIdByWorkspaceId(String workspaceId) async {
    try {
      final response = await dio.get(
        'https://feminist-abigael-roomly-5d3753ef.koyeb.app/api/staff/workspace/staff',
        queryParameters: {'workspaceId': workspaceId},
      );

      // التحقق من صحة الاستجابة
      if (response.statusCode != 200) {
        return null;
      }

      // معالجة البيانات بطرق آمنة
      return _parseStaffId(response.data);
    } on DioException catch (e) {
      throw Exception('فشل في جلب staff ID: ${e.message}');
    } catch (e) {
      throw Exception('خطأ غير متوقع: $e');
    }
  }

  String? _parseStaffId(dynamic responseData) {
    try {
      // الحالة 1: إذا كانت البيانات عبارة عن List
      if (responseData is List) {
        if (responseData.isNotEmpty) {
          return responseData.first.toString(); // تحويل آمن لأول عنصر
        }
        return null;
      }

      // الحالة 2: إذا كانت البيانات غير متوقعة
      throw FormatException('تنسيق بيانات غير معروف');
    } catch (e) {
      throw FormatException('فشل في تحليل staff ID: $e');
    }
  }
}