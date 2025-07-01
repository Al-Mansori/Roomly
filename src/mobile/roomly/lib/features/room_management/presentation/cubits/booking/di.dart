import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;
import '../../../../../core/network/network_info.dart';
import '../../../../../core/service_locator/service_locator.dart';
import '../../../../loyalty/data/data_source/loyalty_points_remote_data_source.dart';
import '../../../../loyalty/data/repository/loyalty_points_repository_impl.dart';
import '../../../../loyalty/domain/repository/loyalty_points_repository.dart';
import '../../../../loyalty/domain/usecases/loyalty_points_usecases.dart';
import '../../../../loyalty/presentation/cubit/loyalty_points_cubit.dart';
import '../../../data/repositories/booking_repository.dart';
import '../../../domain/repositories/booking_repository_impl.dart';
import '../../../domain/usecases/reserve_room_usecase.dart';
import 'cubit/booking_cubit.dart';



void setupDependencies() {
  // InternetConnectionChecker
  if (!sl.isRegistered<InternetConnectionChecker>()) {
    sl.registerSingleton<InternetConnectionChecker>(
      InternetConnectionChecker.createInstance(),
    );
  }

  // NetworkInfo
  if (!sl.isRegistered<NetworkInfo>()) {
    sl.registerSingleton<NetworkInfo>(
      NetworkInfoImpl(sl<InternetConnectionChecker>()),
    );
  }

  // HTTP Client
  if (!sl.isRegistered<http.Client>()) {
    sl.registerSingleton<http.Client>(http.Client());
  }



  // LoyaltyPointsRemoteDataSource
  if (!sl.isRegistered<LoyaltyPointsRemoteDataSource>()) {
    sl.registerSingleton<LoyaltyPointsRemoteDataSource>(
      LoyaltyPointsRemoteDataSourceImpl(client: sl<http.Client>()),
    );
  }

  // LoyaltyPointsRepository
  if (!sl.isRegistered<LoyaltyPointsRepository>()) {
    sl.registerSingleton<LoyaltyPointsRepository>(
      LoyaltyPointsRepositoryImpl(
        remoteDataSource: sl<LoyaltyPointsRemoteDataSource>(),
        networkInfo: sl<NetworkInfo>(),
      ),
    );
  }

  // Use Cases
  if (!sl.isRegistered<GetLoyaltyPoints>()) {
    sl.registerSingleton<GetLoyaltyPoints>(
      GetLoyaltyPoints(sl<LoyaltyPointsRepository>()),
    );
  }

  if (!sl.isRegistered<AddLoyaltyPoints>()) {
    sl.registerSingleton<AddLoyaltyPoints>(
      AddLoyaltyPoints(sl<LoyaltyPointsRepository>()),
    );
  }

  if (!sl.isRegistered<RedeemLoyaltyPoints>()) {
    sl.registerSingleton<RedeemLoyaltyPoints>(
      RedeemLoyaltyPoints(sl<LoyaltyPointsRepository>()),
    );
  }

  // LoyaltyPointsCubit
  if (!sl.isRegistered<LoyaltyPointsCubit>()) {
    sl.registerFactory<LoyaltyPointsCubit>(
          () => LoyaltyPointsCubit(
        getLoyaltyPointsUseCase: sl<GetLoyaltyPoints>(),
        addLoyaltyPointsUseCase: sl<AddLoyaltyPoints>(),
        redeemLoyaltyPointsUseCase: sl<RedeemLoyaltyPoints>(),
      ),
    );
  }

  // BookingRepository
  if (!sl.isRegistered<BookingRepository>()) {
    sl.registerSingleton<BookingRepository>(
      BookingRepositoryImpl(),
    );
  }

  // ReserveRoomUseCase
  if (!sl.isRegistered<ReserveRoomUseCase>()) {
    sl.registerSingleton<ReserveRoomUseCase>(
      ReserveRoomUseCase(sl<BookingRepository>()),
    );
  }

  // BookingCubit
  if (!sl.isRegistered<BookingCubit>()) {
    sl.registerFactory<BookingCubit>(
          () => BookingCubit(sl<ReserveRoomUseCase>()),
    );
  }
}
