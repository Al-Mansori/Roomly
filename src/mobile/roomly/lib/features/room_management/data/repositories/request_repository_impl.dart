
import 'package:roomly/features/room_management/domain/entities/request_entity.dart';

import '../../domain/repositories/send_request_repo.dart';
import '../data_sources/request_remote_datasource.dart';

// lib/features/request/data/repositories/request_repository_impl.dart
import 'package:roomly/core/network/network_info.dart';

class RequestRepositoryImpl implements RequestRepository {
  final RequestRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  RequestRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<String> submitRequest({
    required String type,
    required String details,
    required String userId,
    String? staffId,
  }) async {
    if (await networkInfo.isConnected) {
      return await remoteDataSource.submitRequest(
        type: type,
        details: details,
        userId: userId,
        staffId: staffId,
      );
    } else {
      throw Exception('No internet connection');
    }
  }
}