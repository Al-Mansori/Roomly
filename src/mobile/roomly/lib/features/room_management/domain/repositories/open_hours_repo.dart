import '../entities/operating_entites.dart';

abstract class OperatingHoursRepository {
  Future<OperatingHours> getOperatingHours({
    required String workspaceId,
    required DateTime date,
  });
}
