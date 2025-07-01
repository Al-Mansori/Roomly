import 'package:roomly/features/request/data/models/request_model.dart';

abstract class RequestRemoteDataSource {
  Future<List<RequestModel>> getRequests(String userId);
}

