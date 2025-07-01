
import 'package:roomly/features/room_management/domain/entities/request_entity.dart';

import '../repositories/send_request_repo.dart';

class SubmitRequest {
  final RequestRepository repository;

  SubmitRequest(this.repository);

  Future<String> call({
    required String type,
    required String details,
    required String userId,
    String? staffId,
  }) async {
    return await repository.submitRequest(
      type: type,
      details: details,
      userId: userId,
      staffId: staffId,
    );
  }
}