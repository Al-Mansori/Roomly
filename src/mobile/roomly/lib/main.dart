import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:roomly/core/router/app_router.dart';
import 'package:roomly/features/auth/domain/usecases/ResetPasswordUseCase.dart';
import 'package:roomly/features/auth/domain/usecases/continue_with_google.dart';
import 'package:roomly/features/auth/domain/usecases/login_usecase.dart';
import 'package:http/http.dart' as http;
import 'package:roomly/features/splash/presentation/splash_screen.dart';
import 'features/auth/data/data_sources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/complete_profile_case.dart';
import 'features/auth/domain/usecases/register_staff_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/domain/usecases/verify_usecase.dart';
import 'features/auth/presentation/blocs/auth_cubit.dart';
import 'package:dio/dio.dart';
import 'package:roomly/features/room_management/presentation/di/room_management_injection_container.dart';
import 'package:roomly/features/payment/presentation/di/payment_injection.dart' as payment_di;
import 'package:roomly/features/request/presentation/di/requests_injection_container.dart' as requests_di;
import 'package:roomly/features/favorite/presentation/di/favorite_injection_container.dart' as favorite_di;

import 'features/home/domain/usecases/initHomeDependencies.dart';
import 'features/home/presentation/bloc/cubit/workspace_cubit.dart';
import 'features/room_management/presentation/cubits/booking/di.dart';
import 'features/room_management/presentation/cubits/di_request.dart' as request_di;
import 'features/room_management/presentation/cubits/di_request.dart';
import 'features/room_management/presentation/di/staff_injection_container.dart';
final sl = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies(); // ⬅️ استنى تسجيل كل الـ dependencies

  runApp(const RoomlyApp());
}


Future<void> initDependencies() async {
  // Dio
  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton<Dio>(() => Dio());
  }

  // Core
  setupDependencies();


  await initHomeDependencies();
  setupDependencies(); // ✅ موجودة هنا

  await Future.wait([
    initRoomManagementDependencies(),
    payment_di.initPaymentDependencies(),
    requests_di.initRequestsDependencies(),
    favorite_di.initFavoriteDependencies(),
  ]);
  await initSendRequestDependencies();
  // await payment_di.initPaymentDependencies();
  // await requests_di.initRequestsDependencies();
  await initStaffDependencies(); // ⬅️ الجديد

}


class RoomlyApp extends StatelessWidget {
  const RoomlyApp({super.key});

  Future<void> _initializeApp() async {
    await Future.wait([
      Future.delayed(const Duration(seconds: 5)), // optional delay
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: FutureBuilder(
        future: _initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: SplashScreen(),
            );
          }

          return MultiBlocProvider(
            providers: [
              BlocProvider<AuthCubit>(
                create: (_) {
                  final client = http.Client();
                  final remoteDataSource = AuthRemoteDataSourceImpl(client: client);
                  final repository = AuthRepositoryImpl(remoteDataSource: remoteDataSource);

                  return AuthCubit(
                    loginUseCase: LoginUseCase(repository: repository),
                    registerCustomerUseCase: RegisterCustomerUseCase(repository: repository),
                    registerStaffUseCase: RegisterStaffUseCase(repository: repository),
                    verifyUserUseCase: VerifyUserUseCase(repository: repository),
                    completeProfileUseCase: CompleteProfileUseCase(repository: repository),
                    resetPasswordUseCase: ResetPasswordUseCase(repository: repository),
                    sendForgotPasswordOtpUseCase: SendForgotPasswordOtpUseCase(repository),
                    verifyResetOtpUseCase: VerifyResetOtpUseCase(repository),
                    continueWithGoogleUseCase: ContinueWithGoogleUseCase(repository: repository),
                  );
                },
              ),
              BlocProvider<WorkspaceCubit>(

                create: (_) => WorkspaceCubit(

                  getNearbyWorkspaces: sl(),
                  getTopRatedWorkspaces: sl(),
                  getWorkspaceDetails: sl(),
                  getWorkspaceImages: sl(),
                )..loadInitialData(),
              ),

            ],
            child: MaterialApp.router(
              title: 'Roomly',
              debugShowCheckedModeBanner: false,
              routerConfig: appRouter,
            ),
          );
        },
      ),
    );
  }
}
