import 'package:get_it/get_it.dart';
import 'package:roomly/features/request/data/data_source/request_remote_data_source.dart';
import 'package:roomly/features/request/data/data_source/request_remote_data_source_impl.dart';
import 'package:roomly/features/request/data/repository/request_repository_impl.dart';
import 'package:roomly/features/request/domain/repository/request_repository.dart';
import 'package:roomly/features/request/domain/usecases/get_requests_usecase.dart';
import 'package:roomly/features/request/presentation/cubit/requests_cubit.dart';

final sl = GetIt.instance;

Future<void> initRequestsDependencies() async {
  // Data sources
  sl.registerLazySingleton<RequestRemoteDataSource>(
    () => RequestRemoteDataSourceImpl(dio: sl()),
  );

  // Repositories
  sl.registerLazySingleton<RequestRepository>(
    () => RequestRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton<GetRequestsUseCase>(
    () => GetRequestsUseCase(sl()),
  );

  // Cubits
  sl.registerFactory<RequestsCubit>(
    () => RequestsCubit(getRequestsUseCase: sl()),
  );
}


