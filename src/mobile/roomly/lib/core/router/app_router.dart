import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:roomly/core/network/network_info.dart';
import 'package:roomly/features/BookingsStatus/data/data_sources/bookings_remote_data_source.dart';
import 'package:roomly/features/BookingsStatus/data/data_sources/room_remote_data_source.dart';
import 'package:roomly/features/BookingsStatus/data/repositories/bookings_repository_impl.dart';
import 'package:roomly/features/BookingsStatus/domain/usecases/get_user_bookings.dart';
import 'package:roomly/features/BookingsStatus/presentation/cubit/bookings_cubit.dart';
import 'package:roomly/features/BookingsStatus/presentation/screens/Activity.dart';
import 'package:roomly/features/account/presentation/account_screen.dart';
import 'package:roomly/features/auth/presentation/screens/OTP_Screen.dart';
import 'package:roomly/features/favorite/data/data_sources/favorite_remote_data_source.dart';
import 'package:roomly/features/favorite/data/repositories/favorite_repository_impl.dart';
import 'package:roomly/features/favorite/domain/usecases/get_favorite_rooms.dart';
import 'package:roomly/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:roomly/features/help/presentation/screens/about_app_screen.dart';
import 'package:roomly/features/help/presentation/screens/help_center_screen.dart';
import 'package:roomly/features/help/presentation/screens/report_problem_screen.dart';
import 'package:roomly/features/help/presentation/screens/settings_screen.dart';
import 'package:roomly/features/help/presentation/screens/terms_and_policies_screen.dart';
import 'package:roomly/features/home/presentation/home_screen.dart';
import 'package:roomly/features/loyalty/presentation/screens/loyalty_page.dart';
import 'package:roomly/features/payment/presentation/add_card_screen.dart';
import 'package:roomly/features/payment/presentation/cards_screen.dart';
import 'package:roomly/features/profile/data/data_source/user_local_data_source.dart';
import 'package:roomly/features/profile/data/data_source/user_remote_data_source.dart';
import 'package:roomly/features/profile/data/repository/user_repository_impl.dart';
import 'package:roomly/features/profile/domain/usecases/delete_user.dart';
import 'package:roomly/features/profile/domain/usecases/get_cached_user.dart';
import 'package:roomly/features/profile/domain/usecases/update_user.dart';
import 'package:roomly/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:roomly/features/profile/presentation/screens/profile_screen.dart';
import 'package:roomly/features/room_management/presentation/cubits/room_details_cubit.dart';
import 'package:roomly/features/room_management/presentation/di/room_management_injection_container.dart'
    as di;
import 'package:roomly/features/room_management/presentation/screens/room_details_screen.dart';
import 'package:roomly/features/room_management/presentation/screens/room_list_screen.dart';
import 'package:roomly/features/room_management/presentation/screens/Booking_2nd_Screen.dart';
import 'package:roomly/features/room_management/presentation/screens/reservation_qrcode_screen.dart';
import 'package:roomly/features/workspace/presentation/screens/workspace_details_screen.dart';
import '../../features/auth/presentation/screens/forget_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/Search/filter_screen.dart';
import 'package:roomly/features/favorite/presentation/screens/favorite_screen.dart';
import 'package:roomly/features/workspace/domain/usecases/get_user_name_usecase.dart';
import 'package:roomly/features/workspace/domain/usecases/get_workspace_reviews_usecase.dart';
import 'package:roomly/features/workspace/domain/usecases/submit_review_usecase.dart';
import 'package:roomly/features/workspace/presentation/cubits/reviews_cubit.dart';
import 'package:roomly/features/workspace/presentation/screens/reviews_screen.dart';
import 'package:roomly/features/workspace/data/data_sources/workspace_remote_data_source_impl.dart';
import 'package:roomly/features/workspace/data/repositories/workspace_repository_impl.dart';
import 'package:roomly/features/workspace/domain/usecases/get_room_details_usecase.dart';
import 'package:roomly/features/workspace/domain/usecases/get_workspace_details_usecase.dart';
import 'package:roomly/features/workspace/presentation/cubits/workspace_details_cubit.dart';

import '../../features/map/presentaion/map_screen.dart';
import '../../features/map/presentaion/services/cubic/location_bloc.dart';
import '../../features/map/presentaion/services/geocoding_service.dart';
import '../../features/map/presentaion/services/location_manager.dart';
import '../../features/map/presentaion/services/location_service.dart';
import '../../features/map/presentaion/services/secure_storage_service.dart';
import '../../features/map/presentaion/services/state/location_event.dart';


final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => LocationBloc(locationManager: LocationManager())..add(LoadInitialLocation()),
          child: const HomeScreen(),
        );
      },
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    // GoRoute(path: '/complete-profile', builder: (context, state) =>  CompleteProfileScreen(userId: )),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/verify-otp',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return OtpVerifyScreen(
          email: data['email'],
          userId: data['userId'],
          isStaff: data['isStaff'],
          password: data['password'],
          type: data['type'],
        );
      },
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        final email = data['email'] as String;

        return ResetPasswordScreen(email: email);
      },
    ),
    GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgetPasswordScreen()),

    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    GoRoute(
      path: '/map',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;

        return BlocProvider(
          create: (context) => LocationBloc(locationManager: LocationManager())
            ..add(const LoadInitialLocation()),
          child: const MapScreen(), // أو اللي عندك
        );

      },
    ),

    GoRoute(
      path: '/profile',
      builder: (context, state) => BlocProvider(
        create: (context) => ProfileCubit(
          getCachedUser: GetCachedUser(
            UserRepositoryImpl(
              remoteDataSource: UserRemoteDataSourceImpl(client: http.Client()),
              localDataSource: UserLocalDataSourceImpl(),
              networkInfo: NetworkInfoImpl(InternetConnectionChecker.createInstance()),
            ),
          ),
          updateUser: UpdateUser(
            UserRepositoryImpl(
              remoteDataSource: UserRemoteDataSourceImpl(client: http.Client()),
              localDataSource: UserLocalDataSourceImpl(),
              networkInfo: NetworkInfoImpl(InternetConnectionChecker.createInstance()),
            ),
          ),
          deleteUser: DeleteUser(
            UserRepositoryImpl(
              remoteDataSource: UserRemoteDataSourceImpl(client: http.Client()),
              localDataSource: UserLocalDataSourceImpl(),
              networkInfo: NetworkInfoImpl(InternetConnectionChecker.createInstance()),
            ),
          ),
        ),
        child: const ProfileScreen(),
      ),
    ),

    GoRoute(
      path: '/date',
      builder: (context, state) => SelectDataScreen(),
    ),

    GoRoute(
      path: '/account',
      builder: (context, state) => AccountPage(),
    ),

    GoRoute(
      path: '/loyalty',
      builder: (context, state) => const LoyaltyPage(),
    ),

    // GoRoute(
    //   path: '/workspace/:id',
    //   builder: (context, state) {
    //     final String id = state.pathParameters['id']!;
    //     return WorkspaceDetailsScreen(workspaceId: id);
    //   },
    // ),

    GoRoute(
      path: '/workspace/:id',
      builder: (context, state) {
        final String id = state.pathParameters['id']!;
        return BlocProvider<WorkspaceDetailsCubit>(
          create: (context) {
            // Create dependencies manually
            final client = http.Client();
            final remoteDataSource = WorkspaceRemoteDataSourceImpl(client: client);
            final repository = WorkspaceRepositoryImpl(remoteDataSource: remoteDataSource);
            final getWorkspaceDetailsUseCase = GetWorkspaceDetailsUseCase(repository: repository);
            final getWorkspaceReviewsUseCase = GetWorkspaceReviewsUseCase(repository);
            final getRoomDetailsUseCase = GetRoomDetailsUseCase(repository: repository);
            
            return WorkspaceDetailsCubit(
              getWorkspaceDetailsUseCase: getWorkspaceDetailsUseCase,
              getRoomDetailsUseCase: getRoomDetailsUseCase, 
              getWorkspaceReviewsUseCase: getWorkspaceReviewsUseCase,
            );
          },
          child: WorkspaceDetailsScreen(workspaceId: id),
        );
      },
    ),

    GoRoute(
      path: '/reservation-qrcode',
      builder: (context, state) => const ReservationQRCodeScreen(),
    ),

    // GoRoute(
    //   path: '/reviews',
    //   builder: (context, state) => const ReviewsScreen(),
    // ),

    GoRoute(
      path: '/reviews/:workspaceId',
      builder: (context, state) {
        final String workspaceId = state.pathParameters['workspaceId']!;
        return BlocProvider<ReviewsCubit>(
          create: (context) {
            // Create dependencies manually
            final client = http.Client();
            final remoteDataSource = WorkspaceRemoteDataSourceImpl(client: client);
            final repository = WorkspaceRepositoryImpl(remoteDataSource: remoteDataSource);
            final getWorkspaceReviewsUseCase = GetWorkspaceReviewsUseCase(repository);
            
            return ReviewsCubit(
              getWorkspaceReviewsUseCase: getWorkspaceReviewsUseCase,
              getUserNameUseCase: GetUserNameUseCase(repository),
              submitReviewUseCase: SubmitReviewUseCase(repository),
            );
          },
          child: ReviewsScreen(workspaceId: workspaceId),
        );
      },
    ),


    GoRoute(
      path: '/cards',
      builder: (context, state) => const CardsScreen(),
    ),
    GoRoute(
      path: '/add-card',
      builder: (context, state) => const AddCardScreen(),
    ),
    GoRoute(
      path: '/filter',
      builder: (context, state) => const FilterScreen(),
    ),

    GoRoute(
        path: '/rooms', builder: (context, state) => const RoomListScreen()),

    // GoRoute(
    //   path: '/room/:id',
    //   builder: (context, state) {
    //     final String id = state.pathParameters['id'] ?? '';
    //     return BlocProvider<RoomDetailsCubit>(
    //       create: (context) => di.sl<RoomDetailsCubit>(),
    //       child: RoomDetailsScreen(roomId: id),
    //     );
    //   },
    // ),

    GoRoute(
      path: '/room/:id',
      builder: (context, state) {
        final String id = state.pathParameters['id'] ?? '';
        return BlocProvider<RoomDetailsCubit>(
          create: (context) => di.sl<RoomDetailsCubit>(),
          child: RoomDetailsScreen(roomId: id),
        );
      },
    ),

    GoRoute(
      path: '/booking',
      builder: (context, state) {
        return BlocProvider(
          create: (context) {
            final dio = Dio();
            final remoteDataSource = BookingsRemoteDataSourceImpl(dio: dio);
            final roomRemoteDataSource = RoomRemoteDataSource(dio: dio);
            final repository = BookingsRepositoryImpl(
              remoteDataSource: remoteDataSource,
              roomRemoteDataSource: roomRemoteDataSource,
            );
            return BookingsCubit(getUserBookings: GetUserBookings(repository));
          },
          child: const ActivityScreen(),
        );
      },
    ),
    GoRoute(
      path: '/favorite',
      builder: (context, state) {
        return BlocProvider(
          create: (context) {
            final dio = Dio();
            final roomRemoteDataSource = RoomRemoteDataSource(dio: dio);
            final remoteDataSource = FavoriteRemoteDataSource(
              dio: dio,
              roomRemoteDataSource: roomRemoteDataSource,
            );
            final repository =
                FavoriteRepositoryImpl(remoteDataSource: remoteDataSource);
            return FavoriteCubit(
              getFavoriteRooms: GetFavoriteRooms(repository),
            );
          },
          child: const FavoriteScreen(userId: 'usr001'),
        );
      },
    ),

    GoRoute(
      path: '/terms-policies',
      builder: (context, state) => const TermsAndPoliciesScreen(),
    ),
    GoRoute(
      path: '/report-problem',
      builder: (context, state) => const ReportProblemScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const AppSettingsScreen(),
    ),
    GoRoute(
      path: '/help-center',
      builder: (context, state) => const HelpCenterScreen(),
    ),
    GoRoute(
      path: '/about-app',
      builder: (context, state) => const AboutAppScreen(),
    ),
  ],
);
