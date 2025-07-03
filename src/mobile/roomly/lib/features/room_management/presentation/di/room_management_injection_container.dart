// import 'package:dio/dio.dart';
// import 'package:get_it/get_it.dart';
// import 'package:roomly/features/room_management/data/data_sources/room_remote_data_source.dart';
// import 'package:roomly/features/room_management/data/data_sources/offer_remote_data_source.dart';
// import 'package:roomly/features/room_management/data/repositories/room_repository_impl.dart';
// import 'package:roomly/features/room_management/domain/repositories/room_repository.dart';
// import 'package:roomly/features/room_management/domain/usecases/get_room_details_usecase.dart';
// import 'package:roomly/features/room_management/domain/usecases/get_room_images_usecase.dart';
// import 'package:roomly/features/room_management/domain/usecases/get_room_offers_usecase.dart';
// import 'package:roomly/features/room_management/presentation/cubits/room_details_cubit.dart';

// import '../../../../core/service_locator/service_locator.dart';


// Future<void> initRoomManagementDependencies() async {
//   // Cubits
//   sl.registerFactory(
//         () => RoomDetailsCubit(
//       getRoomDetailsUseCase: sl(),
//       getRoomImagesUseCase: sl(),
//       getRoomOffersUseCase: sl(),
//       getFavoriteRoomsUseCase: sl(),
//       addFavoriteRoomUseCase: sl(),
//       removeFavoriteRoomUseCase: sl(),
//     ),
//   );

//   // Use cases
//   sl.registerLazySingleton(() => GetRoomDetailsUseCase(sl()));
//   sl.registerLazySingleton(() => GetRoomImagesUseCase(sl()));
//   sl.registerLazySingleton(() => GetRoomOffersUseCase(sl()));

//   // Repositories
//   sl.registerLazySingleton<RoomRepository>(
//         () => RoomRepositoryImpl(
//       remoteDataSource: sl(),
//       offerRemoteDataSource: sl(),
//     ),
//   );

//   // Data sources
//   sl.registerLazySingleton<RoomRemoteDataSource>(
//         () => RoomRemoteDataSourceImpl(dio: sl<Dio>()),
//   );
//   sl.registerLazySingleton<OfferRemoteDataSource>(
//         () => OfferRemoteDataSourceImpl(dio: sl<Dio>()),
//   );
// }



// v2---------------------------------------------------------------------------

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:roomly/features/room_management/data/data_sources/room_remote_data_source.dart';
import 'package:roomly/features/room_management/data/data_sources/offer_remote_data_source.dart';
import 'package:roomly/features/room_management/data/repositories/room_repository_impl.dart';
import 'package:roomly/features/room_management/domain/repositories/room_repository.dart';
import 'package:roomly/features/room_management/domain/usecases/get_room_details_usecase.dart';
import 'package:roomly/features/room_management/domain/usecases/get_room_images_usecase.dart';
import 'package:roomly/features/room_management/domain/usecases/get_room_offers_usecase.dart';
import 'package:roomly/features/room_management/domain/usecases/check_room_recovery_status_usecase.dart';
import 'package:roomly/features/room_management/presentation/cubits/room_details_cubit.dart';

final sl = GetIt.instance;

Future<void> initRoomManagementDependencies() async {
  // Cubits
  sl.registerFactory(
    () => RoomDetailsCubit(
      getRoomDetailsUseCase: sl(),
      getRoomImagesUseCase: sl(),
      getRoomOffersUseCase: sl(),
      getFavoriteRoomsUseCase: sl(),
      addFavoriteRoomUseCase: sl(),
      removeFavoriteRoomUseCase: sl(),
      checkRoomRecoveryStatusUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetRoomDetailsUseCase(sl()));
  sl.registerLazySingleton(() => GetRoomImagesUseCase(sl()));
  sl.registerLazySingleton(() => GetRoomOffersUseCase(sl()));
  sl.registerLazySingleton(() => CheckRoomRecoveryStatusUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<RoomRepository>(
    () => RoomRepositoryImpl(
      remoteDataSource: sl(),
      offerRemoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<RoomRemoteDataSource>(
    () => RoomRemoteDataSourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<OfferRemoteDataSource>(
    () => OfferRemoteDataSourceImpl(dio: sl<Dio>()),
  );
}


