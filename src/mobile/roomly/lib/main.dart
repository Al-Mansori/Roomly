import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomly/core/router/app_router.dart';
import 'package:roomly/features/auth/domain/usecases/login_usecase.dart';
import 'package:http/http.dart' as http;
import 'features/auth/data/data_sources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/complete_profile_case.dart';
import 'features/auth/domain/usecases/register_staff_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/domain/usecases/verify_usecase.dart';
import 'features/auth/presentation/blocs/auth_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const RoomlyApp());
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
              final repository = AuthRepositoryImpl(remoteDataSource: remoteDataSource);

              return AuthCubit(
                loginUseCase: LoginUseCase(repository: repository),
                registerCustomerUseCase: RegisterCustomerUseCase(repository: repository),
                registerStaffUseCase: RegisterStaffUseCase(repository: repository),
                verifyUserUseCase: VerifyUserUseCase(repository: repository),
                completeProfileUseCase: CompleteProfileUseCase(repository: repository),
              );
            },
          )
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
