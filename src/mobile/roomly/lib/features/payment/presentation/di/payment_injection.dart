import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:roomly/core/network/app_api.dart';
import 'package:roomly/core/network/network_info.dart';
import 'package:roomly/features/payment/data/data_source/payment_remote_data_source.dart';
import 'package:roomly/features/payment/data/repositories/payment_repository_impl.dart';
import 'package:roomly/features/payment/domain/repositories/payment_repository.dart';
import 'package:roomly/features/payment/domain/usecases/add_card_usecase.dart';
import 'package:roomly/features/payment/domain/usecases/get_user_cards_usecase.dart';
import 'package:roomly/features/payment/presentation/cubit/payment_cubit.dart';

final sl = GetIt.instance;

Future<void> initPaymentDependencies() async {
  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => AppApi());

  // Data sources
  sl.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(
      client: sl(),
      appApi: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetUserCardsUseCase(sl()));
  sl.registerLazySingleton(() => AddCardUseCase(sl()));

  // Cubit
  sl.registerFactory(
    () => PaymentCubit(
      getUserCardsUseCase: sl(),
      addCardUseCase: sl(),
    ),
  );
}

