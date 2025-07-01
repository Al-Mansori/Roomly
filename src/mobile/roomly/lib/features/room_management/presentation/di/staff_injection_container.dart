import 'package:get_it/get_it.dart';

import '../../../../core/service_locator/service_locator.dart';
import '../../data/data_sources/staff_remote_datasource.dart';
import '../../data/repositories/get_staffId_repo.dart';
import '../../domain/usecases/get_staffId_usecase.dart';

Future<void> initStaffDependencies() async {
  if (!sl.isRegistered<StaffRemoteDataSource>()) {
    sl.registerLazySingleton<StaffRemoteDataSource>(
          () => StaffRemoteDataSourceImpl(dio: sl()),
    );
  }

  if (!sl.isRegistered<StaffRepository>()) {
    sl.registerLazySingleton<StaffRepository>(
          () => StaffRepositoryImpl(remoteDataSource: sl()),
    );
  }

  if (!sl.isRegistered<GetStaffIdUseCase>()) {
    sl.registerLazySingleton<GetStaffIdUseCase>(
          () => GetStaffIdUseCase(sl()),
    );
  }
}
