import 'package:dartz/dartz.dart';
import 'package:roomly/core/error/failures.dart';
import 'package:roomly/features/workspace/domain/entities/user_entity_workspace.dart';
import 'package:roomly/features/workspace/domain/repositories/workspace_repository.dart';

class GetUserNameUseCase {
  final WorkspaceRepository repository;

  GetUserNameUseCase(this.repository);

  Future<Either<Failure, UserEntity2>> call(String userId) async {
    return await repository.getUserName(userId);
  }
}


