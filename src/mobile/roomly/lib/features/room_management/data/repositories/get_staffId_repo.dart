// staff_repository.dart
import '../data_sources/staff_remote_datasource.dart';

abstract class StaffRepository {
  Future<String?> getStaffIdByWorkspaceId(String workspaceId);
}

// staff_repository_impl.dart
class StaffRepositoryImpl implements StaffRepository {
  final StaffRemoteDataSource remoteDataSource;

  StaffRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String?> getStaffIdByWorkspaceId(String workspaceId) {
    return remoteDataSource.getStaffIdByWorkspaceId(workspaceId);
  }
}
