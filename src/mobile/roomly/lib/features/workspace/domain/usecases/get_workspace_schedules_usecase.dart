import 'package:dartz/dartz.dart';
import 'package:roomly/core/error/failures.dart';
import 'package:roomly/features/workspace/data/models/workspace_schedule_model.dart';
import 'package:roomly/features/workspace/domain/repositories/workspace_repository.dart';

class GetWorkspaceSchedulesUseCase {
  final WorkspaceRepository repository;

  GetWorkspaceSchedulesUseCase(this.repository);

  Future<Either<Failure, List<WorkspaceScheduleModel>>> call(String workspaceId) async {
    return await repository.getWorkspaceSchedules(workspaceId);
  }
}

