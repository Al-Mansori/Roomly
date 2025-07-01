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

import '../../../../core/service_locator/service_locator.dart';
import '../../data/repositories/payment_repo_impl.dart';
import '../../domain/repositories/payment_repo_final.dart';
import '../../domain/usecases/process_payment_usecase.dart';


Future<void> initPaymentDependencies() async {
  // External
  if (!sl.isRegistered<http.Client>()) {
    sl.registerLazySingleton<http.Client>(() => http.Client());
  }

  if (!sl.isRegistered<InternetConnectionChecker>()) {
    sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  }

  // Core
  if (!sl.isRegistered<NetworkInfo>()) {
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  }

  if (!sl.isRegistered<AppApi>()) {
    sl.registerLazySingleton(() => AppApi());
  }

  // Data sources
  sl.registerLazySingleton<PaymentRemoteDataSource>(
        () => PaymentRemoteDataSourceImpl(
      client: sl(),
      appApi: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetUserCardsUseCase(sl()));
  sl.registerLazySingleton(() => AddCardUseCase(sl()));
// Update the ProcessPaymentUseCase registration to match the implementation
  sl.registerLazySingleton<ProcessPaymentUseCase>(() => ProcessPaymentUseCaseImpl(sl()));

// Make sure the PaymentRepository is properly registered
  sl.registerLazySingleton<PaymentRepository>(
        () => PaymentRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<PaymentRepositoryFinal>(
        () => PaymentRepositoryFinalImpl( // تأكد من وجود هذا الكلاس
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  // Cubit
  sl.registerFactory(
        () => PaymentCubit(
      getUserCardsUseCase: sl(),
      addCardUseCase: sl(),
      processPaymentUseCase: sl(),
    ),
  );
}