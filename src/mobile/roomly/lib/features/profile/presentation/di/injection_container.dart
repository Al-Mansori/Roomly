import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:roomly/core/network/network_info.dart';
import 'package:roomly/features/profile/data/data_source/user_local_data_source.dart';
import 'package:roomly/features/profile/data/data_source/user_remote_data_source.dart';
import 'package:roomly/features/profile/data/repository/user_repository_impl.dart';
import 'package:roomly/features/profile/domain/repository/user_repository.dart';
import 'package:roomly/features/profile/domain/usecases/delete_user.dart';
import 'package:roomly/features/profile/domain/usecases/get_cached_user.dart';
import 'package:roomly/features/profile/domain/usecases/update_user.dart';
import 'package:roomly/features/profile/presentation/cubit/profile_cubit.dart';

import '../../../../core/service_locator/service_locator.dart';


Future<void> init() async {
  //! Features - User
  // Cubit
  sl.registerFactory(
    () => ProfileCubit(
      getCachedUser: sl(),
      updateUser: sl(),
      deleteUser: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetCachedUser(sl()));
  sl.registerLazySingleton(() => UpdateUser(sl()));
  sl.registerLazySingleton(() => DeleteUser(sl()));

  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
}

