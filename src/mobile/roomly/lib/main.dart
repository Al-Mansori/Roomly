import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:roomly/core/router/app_router.dart';
import 'package:roomly/features/auth/domain/usecases/ResetPasswordUseCase.dart';
import 'package:roomly/features/auth/domain/usecases/login_usecase.dart';
import 'package:http/http.dart' as http;
import 'package:roomly/features/favorite/domain/entities/favorite_room.dart';
import 'package:roomly/features/favorite/domain/repositories/favorite_repository.dart';
import 'features/auth/data/data_sources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/complete_profile_case.dart';
import 'features/auth/domain/usecases/register_staff_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/domain/usecases/verify_usecase.dart';
import 'features/auth/presentation/blocs/auth_cubit.dart';
import 'features/BookingsStatus/data/data_sources/bookings_remote_data_source.dart';
import 'features/BookingsStatus/data/repositories/bookings_repository_impl.dart';
import 'features/BookingsStatus/domain/usecases/get_user_bookings.dart';
import 'features/BookingsStatus/presentation/cubit/bookings_cubit.dart';
import 'features/BookingsStatus/data/data_sources/room_remote_data_source.dart';
import 'features/favorite/data/data_sources/favorite_remote_data_source.dart';
import 'features/favorite/data/repositories/favorite_repository_impl.dart';
import 'features/favorite/domain/usecases/get_favorite_rooms.dart';
import 'features/favorite/presentation/cubit/favorite_cubit.dart';

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
              );
            },
          ),
        
          // BlocProvider<BookingsCubit>(
          //   create: (_) {
          //     final dio = Dio();
          //     final remoteDataSource = BookingsRemoteDataSourceImpl(dio: dio);
          //     final roomRemoteDataSource = RoomRemoteDataSource(dio: dio);
          //     final repository = BookingsRepositoryImpl(
          //       remoteDataSource: remoteDataSource,
          //       roomRemoteDataSource: roomRemoteDataSource,
          //     );

          //     return BookingsCubit(
          //       getUserBookings: GetUserBookings(repository),
          //     );
          //   },
          // ),
          // BlocProvider<FavoriteCubit>(
          //   create: (_) {
          //     final dio = Dio();
          //     final roomRemoteDataSource = RoomRemoteDataSource(dio: dio);
          //     final remoteDataSource = FavoriteRemoteDataSource(
          //         dio: dio, roomRemoteDataSource: roomRemoteDataSource);
          //     final repository =
          //         FavoriteRepositoryImpl(remoteDataSource: remoteDataSource);
          //     return FavoriteCubit(
          //         getFavoriteRooms: GetFavoriteRooms(repository));
          //   },
          // ),
        
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
