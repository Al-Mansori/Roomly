import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:roomly/features/home/data/repositories/workspace_repository_impl.dart';
import 'package:roomly/features/home/domain/repositories/workspace_repository.dart';
import 'package:roomly/features/home/domain/usecases/workspace_details_usecase.dart';

import '../../../../main.dart';
import '../../../room_management/domain/usecases/get_room_details_usecase.dart';
import '../../../room_management/presentation/cubits/room_details_cubit.dart';
import '../../data/data_sources/network_service.dart';
import '../../data/data_sources/room_remote_datasource.dart';
import '../../data/data_sources/workspace_remote_datasource.dart';
import '../../data/repositories/room_repo_impl.dart';
import '../../presentation/bloc/cubit/room_cubit.dart';
import '../repositories/room_repo.dart';
import 'package:http/http.dart' as http;



Future<void> initHomeDependencies() async {
  print("🧩 initHomeDependencies STARTED");

  // Reset إذا كنت تريد إعادة التسجيل (اختياري)
  await sl.reset(); // تأكد من استيراد get_it
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio();

    // Add default configuration (optional)
    dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    );

    // Add interceptors if needed (optional)
    dio.interceptors.add(LogInterceptor());

    return dio;
  });

  // 1. تسجيل الأساسيات
  sl
    ..registerLazySingleton<http.Client>(() => http.Client())
    ..registerLazySingleton<NetworkService>(() => NetworkService());

  sl.registerLazySingleton<InternetConnectionChecker>(
        () => InternetConnectionChecker.createInstance(),
  );

  // 2. تسجيل الـ Data Sources
  sl
    ..registerLazySingleton<WorkspaceRemoteDataSource>(
          () => WorkspaceRemoteDataSourceImpl(networkService: sl()),
    )
    ..registerLazySingleton<RoomRemoteDataSource>(
          () => RoomRemoteDataSource(client: sl()),
    );

  // 3. تسجيل الـ Repositories
  sl
    ..registerLazySingleton<RoomRepository>(
          () => RoomRepositoryImpl(remoteDataSource: sl()),
    )
    ..registerLazySingleton<WorkspaceRepository>(
          () => WorkspaceRepositoryImpl(remoteDataSource: sl()),
    );

  // 4. تسجيل الـ Use Cases
  sl
    ..registerLazySingleton<GetNearbyWorkspaces>(() => GetNearbyWorkspaces(sl()))
    ..registerLazySingleton<GetTopRatedWorkspaces>(() => GetTopRatedWorkspaces(sl()))
    ..registerLazySingleton<GetWorkspaceDetails>(() => GetWorkspaceDetails(sl()))
    ..registerLazySingleton<GetWorkspaceImages>(() => GetWorkspaceImages(sl()));

  // 5. تسجيل الـ Cubits/Blocs كـ Factory
  sl.registerFactory<RoomsCubit>(() => RoomsCubit(roomRepository: sl()));

  print("✅ initHomeDependencies COMPLETED");
}