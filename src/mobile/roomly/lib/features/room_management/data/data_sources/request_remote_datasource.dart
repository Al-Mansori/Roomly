import '../../domain/entities/request_entity.dart';
import '../models/request_model.dart';
import 'api_service.dart';

abstract class RequestRemoteDataSource {
  Future<String> submitRequest({
    required String type,
    required String details,
    required String userId,
    String? staffId,
  });
}


class RequestRemoteDataSourceImpl implements RequestRemoteDataSource {
  final ApiService apiService;

  RequestRemoteDataSourceImpl({required this.apiService});

  @override
  Future<String> submitRequest({
    required String type,
    required String details,
    required String userId,
    String? staffId,
  }) async {
    final json = await apiService.post(
      '/customer/request',
      queryParameters: {
        'type': type,
        'details': details,
        'userId': userId,
        'staffId': staffId,
      },

    );

    if (json is String) {
      if (json.toLowerCase().contains("success")) {
        return "Request sent successfully!";
      } else {
        return "Unexpected server response: $json";
      }
    }


    // ✅ لو فعلاً JSON
    if (json is Map<String, dynamic>) {
      return "Request sent successfully!";
    }
    throw Exception("Invalid response type: ${json.runtimeType}");

  }
}