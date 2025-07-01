// get_staff_id_usecase.dart
import '../../data/repositories/get_staffId_repo.dart';

class GetStaffIdUseCase {
  final StaffRepository repository;

  GetStaffIdUseCase(this.repository);

  Future<String?> call(String workspaceId) {
    return repository.getStaffIdByWorkspaceId(workspaceId);
  }
}
