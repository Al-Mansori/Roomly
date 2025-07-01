import 'package:dartz/dartz.dart';
import 'package:roomly/core/error/exceptions.dart';
import 'package:roomly/core/error/failures.dart';
import 'package:roomly/features/request/data/data_source/request_remote_data_source.dart';
import 'package:roomly/features/request/domain/entities/request.dart';
import 'package:roomly/features/request/domain/repository/request_repository.dart';

class RequestRepositoryImpl implements RequestRepository {
  final RequestRemoteDataSource remoteDataSource;

  RequestRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Request>>> getRequests(String userId) async {
    try {
      final remoteRequests = await remoteDataSource.getRequests(userId);
      return Right(remoteRequests);
    } on ServerException {
      return const Left(ServerFailure(message: 'Failed to get requests from server'));
    }
  }
}


