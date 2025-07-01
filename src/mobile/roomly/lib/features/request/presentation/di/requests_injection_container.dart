import 'package:get_it/get_it.dart';
import 'package:roomly/features/request/data/data_source/request_remote_data_source.dart';
import 'package:roomly/features/request/data/data_source/request_remote_data_source_impl.dart';
import 'package:roomly/features/request/data/repository/request_repository_impl.dart';
import 'package:roomly/features/request/domain/repository/request_repository.dart';
import 'package:roomly/features/request/domain/usecases/get_requests_usecase.dart';
import 'package:roomly/features/request/presentation/cubit/requests_cubit.dart';
import 'package:roomly/features/room_management/presentation/cubits/request.dart';

import '../../../../core/service_locator/service_locator.dart';
import '../../../room_management/domain/usecases/submit_request_usecase.dart';


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
  if (!sl.isRegistered<SendRequestCubit>()) {
    sl.registerFactory<SendRequestCubit>(
          () => SendRequestCubit(
        submitRequestUseCase: sl<SubmitRequest>(),
      ),
    );
  }


}


