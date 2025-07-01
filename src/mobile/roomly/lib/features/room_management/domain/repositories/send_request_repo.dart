// lib/features/request/domain/repositories/request_repository.dart
import '../entities/request_entity.dart';


abstract class RequestRepository {
  Future<String> submitRequest({
    required String type,
    required String details,
    required String userId,
    String? staffId,
  });
}