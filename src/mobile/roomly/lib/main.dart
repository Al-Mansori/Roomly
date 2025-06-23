import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomly/core/router/app_router.dart';
import 'package:roomly/features/auth/domain/usecases/ResetPasswordUseCase.dart';
import 'package:roomly/features/auth/domain/usecases/continue_with_google.dart';
import 'package:roomly/features/auth/domain/usecases/login_usecase.dart';
import 'package:http/http.dart' as http;
import 'package:roomly/features/map/presentaion/services/location_manager.dart';
import 'features/auth/data/data_sources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/complete_profile_case.dart';
import 'features/auth/domain/usecases/register_staff_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/domain/usecases/verify_usecase.dart';
import 'features/auth/presentation/blocs/auth_cubit.dart';
import 'package:dio/dio.dart';
import 'package:roomly/features/room_management/presentation/di/room_management_injection_container.dart';
import 'package:roomly/features/payment/presentation/di/payment_injection.dart'
    as payment_di;

import 'features/map/presentaion/services/cubic/location_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetIt dependencies -- Mostafa
  await initDependencies();

  // Initialize room management dependencies
  await payment_di.initPaymentDependencies();

  runApp(const RoomlyApp());
}

Future<void> initDependencies() async {
  // Register Dio first as it's needed by other dependencies
  sl.registerLazySingleton<Dio>(() => Dio());

  // Initialize room management dependencies
  await initRoomManagementDependencies();
}

class RoomlyApp extends StatelessWidget {
  const RoomlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (_) {
              final client = http.Client();
              final remoteDataSource = AuthRemoteDataSourceImpl(client: client);
              final repository =
                  AuthRepositoryImpl(remoteDataSource: remoteDataSource);

              return AuthCubit(
                  loginUseCase: LoginUseCase(repository: repository),
                  registerCustomerUseCase:
                      RegisterCustomerUseCase(repository: repository),
                  registerStaffUseCase:
                      RegisterStaffUseCase(repository: repository),
                  verifyUserUseCase: VerifyUserUseCase(repository: repository),
                  completeProfileUseCase:
                      CompleteProfileUseCase(repository: repository),
                  resetPasswordUseCase:
                      ResetPasswordUseCase(repository: repository),
                  sendForgotPasswordOtpUseCase:
                      SendForgotPasswordOtpUseCase(repository),
                  verifyResetOtpUseCase: VerifyResetOtpUseCase(repository),
                  continueWithGoogleUseCase:
                      ContinueWithGoogleUseCase(repository: repository));
            },
          ),
          BlocProvider<LocationBloc>(
            create: (_) => LocationBloc(locationManager: LocationManager()),
          ),
        ],
        child: MaterialApp.router(
          title: 'Roomly',
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter,
        ),
      ),
    );
  }
}
