import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:roomly/core/error/failures.dart';
import 'package:roomly/features/loyalty/domain/usecases/loyalty_points_usecases.dart';
import 'package:roomly/features/request/domain/entities/request.dart';
import 'package:roomly/features/request/domain/repository/request_repository.dart';

class GetRequestsUseCase extends UseCase<List<Request>, Params> {
  final RequestRepository repository;

  GetRequestsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Request>>> call(Params params) async {
    return await repository.getRequests(params.userId);
  }
}

class Params extends Equatable {
  final String userId;

  const Params({required this.userId});

  @override
  List<Object> get props => [userId];
}


