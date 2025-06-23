import 'package:dartz/dartz.dart';
import 'package:roomly/core/error/failures.dart';
import 'package:roomly/features/request/domain/entities/request.dart';

abstract class RequestRepository {
  Future<Either<Failure, List<Request>>> getRequests(String userId);
}

