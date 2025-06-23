import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:roomly/features/favorite/data/data_source/favorite_remote_data_source.dart';
import 'package:roomly/features/favorite/data/repository/favorite_repository_impl.dart';
import 'package:roomly/features/favorite/domain/repository/favorite_repository.dart';
import 'package:roomly/features/favorite/domain/usecases/get_favorite_rooms_usecase.dart';
import 'package:roomly/features/favorite/domain/usecases/add_favorite_room_usecase.dart';
import 'package:roomly/features/favorite/domain/usecases/remove_favorite_room_usecase.dart';

final sl = GetIt.instance;

Future<void> initFavoriteDependencies() async {
  // Use cases
  sl.registerLazySingleton(() => GetFavoriteRoomsUseCase(sl()));
  sl.registerLazySingleton(() => AddFavoriteRoomUseCase(repository: sl()));
  sl.registerLazySingleton(() => RemoveFavoriteRoomUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<FavoriteRepository>(
    () => FavoriteRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<FavoriteRemoteDataSource>(
    () => FavoriteRemoteDataSourceImpl(dio: sl<Dio>()),
  );
}

