


import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:roomly/features/room_management/presentation/cubits/request.dart';

import '../../../../core/network/network_info.dart';
import '../../../../core/service_locator/service_locator.dart';
import '../../data/data_sources/api_service.dart';
import '../../data/data_sources/request_remote_datasource.dart';
import '../../data/repositories/request_repository_impl.dart';
import '../../domain/repositories/send_request_repo.dart';
import '../../domain/usecases/submit_request_usecase.dart';



Future<void> initSendRequestDependencies() async {

  sl.registerLazySingleton<ApiService>(
        () => ApiService(
      baseUrl: 'https://feminist-abigael-roomly-5d3753ef.koyeb.app/api/customer/request?',
      dio: sl<Dio>(),
    ),
  );

  if (!sl.isRegistered<NetworkInfo>()) {
    sl.registerSingleton<NetworkInfo>(
      NetworkInfoImpl(sl<InternetConnectionChecker>()),
    );
  }

  sl.registerSingleton<RequestRemoteDataSource>(
    RequestRemoteDataSourceImpl(apiService: sl<ApiService>()),
  );

  sl.registerSingleton<RequestRepository>(
    RequestRepositoryImpl(
      remoteDataSource: sl<RequestRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  sl.registerSingleton<SubmitRequest>(
    SubmitRequest(sl<RequestRepository>()),
  );

  if (!sl.isRegistered<SendRequestCubit>()) {
    sl.registerFactory<SendRequestCubit>(
          () => SendRequestCubit(
        submitRequestUseCase: sl<SubmitRequest>(),
      ),
    );
  }

}
