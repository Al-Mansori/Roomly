import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
import 'package:roomly/features/GlobalWidgets/bot_layout.dart';
import 'package:roomly/features/account/presentation/account_screen.dart';
import 'package:roomly/features/auth/presentation/screens/OTP_Screen.dart';
import 'package:roomly/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:roomly/features/help/presentation/screens/about_app_screen.dart';
import 'package:roomly/features/help/presentation/screens/help_center_screen.dart';
import 'package:roomly/features/help/presentation/screens/report_problem_screen.dart';
import 'package:roomly/features/help/presentation/screens/settings_screen.dart';
import 'package:roomly/features/help/presentation/screens/terms_and_policies_screen.dart';
import 'package:roomly/features/home/presentation/screens/home_screen.dart';
import 'package:roomly/features/loyalty/presentation/screens/loyalty_page.dart';
import 'package:roomly/features/payment/presentation/di/payment_injection.dart';
import 'package:roomly/features/payment/presentation/screens/add_card_screen.dart';
import 'package:roomly/features/payment/presentation/screens/cards_screen.dart';
import 'package:roomly/features/profile/data/data_source/user_local_data_source.dart';
import 'package:roomly/features/profile/data/data_source/user_remote_data_source.dart';
import 'package:roomly/features/profile/data/repository/user_repository_impl.dart';
import 'package:roomly/features/profile/domain/usecases/delete_user.dart';
import 'package:roomly/features/profile/domain/usecases/get_cached_user.dart';
import 'package:roomly/features/profile/domain/usecases/update_user.dart';
import 'package:roomly/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:roomly/features/profile/presentation/screens/profile_screen.dart';
import 'package:roomly/features/room_management/presentation/cubits/room_details_cubit.dart';
import 'package:roomly/features/room_management/presentation/di/room_management_injection_container.dart'as di;
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
import '../../features/home/domain/repositories/room_repo.dart';
import '../../features/home/presentation/bloc/cubit/room_cubit.dart';
import '../../features/home/presentation/screens/rooms_by_type_screen.dart';
import '../../features/loyalty/presentation/cubit/loyalty_points_cubit.dart';
import '../../features/map/presentaion/map_screen.dart';
import '../../features/map/presentaion/services/cubic/location_bloc.dart';
import '../../features/map/presentaion/services/location_manager.dart';
import '../../features/map/presentaion/services/state/location_event.dart';
import '../../features/payment/presentation/cubit/payment_cubit.dart';
import 'package:roomly/features/favorite/data/data_source/favorite_remote_data_source.dart';
import 'package:roomly/features/favorite/data/repository/favorite_repository_impl.dart';
import 'package:roomly/features/favorite/domain/usecases/get_favorite_rooms_usecase.dart';
import 'package:roomly/features/favorite/domain/usecases/remove_favorite_room_usecase.dart';
import 'package:roomly/features/request/domain/entities/request.dart';
import 'package:roomly/features/request/presentation/cubit/requests_cubit.dart';
import 'package:roomly/features/request/presentation/screens/request_detail_screen.dart';
import 'package:roomly/features/request/presentation/screens/requests_screen.dart';
import 'package:roomly/features/workspace/domain/usecases/get_workspace_schedules_usecase.dart';

import '../../features/payment/presentation/screens/payment_screen.dart';
import '../../features/room_management/data/data_sources/api_service.dart';
import '../../features/room_management/domain/entities/room_entity.dart';
import '../../features/room_management/presentation/cubits/booking/cubit/booking_cubit.dart';
import '../../features/room_management/presentation/cubits/booking/di.dart';
import '../../features/room_management/presentation/cubits/request.dart';
import '../../features/room_management/presentation/screens/booking_3rd_screen.dart';
import '../../features/room_management/presentation/screens/send_request_screen.dart';
import '../service_locator/service_locator.dart';


final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => LocationBloc(locationManager: LocationManager())..add(LoadInitialLocation()),
          child: const BotLayout(child: HomeScreen()),
        );
      },
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    // GoRoute(path: '/complete-profile', builder: (context, state) =>  CompleteProfileScreen(userId: )),
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
        return BlocProvider(
          create: (context) => LocationBloc(locationManager: LocationManager())
            ..add(const LoadInitialLocation()),
          child: const MapScreen(),
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
      path: '/payment',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        return BlocProvider(
          create: (context) => sl<PaymentCubit>(),
          child: PaymentScreen(
            amount: extras['amount'] as double,
            paymentFor: extras['paymentFor'] as String,
            userId: extras['userId'] as String,
            reservationId: extras['reservationId'] as String,
            paymentMethod: extras['paymentMethod'] as String,
          ),
        );
      },
    ),
    GoRoute(
      path: '/room-type/:type',
      name: 'room-type',
      builder: (context, state) {
        try {
          final type = state.pathParameters['type']?.toLowerCase();

          // التحقق من صحة المعلمة
          if (type == null || type.isEmpty) {
            throw ArgumentError('Invalid room type parameter');
          }

          return MultiBlocProvider(
            providers: [
              // تقديم الـ Repository مرة واحدة لكل الشاشة
              RepositoryProvider.value(
                value: sl<RoomRepository>(),
              ),
              // تهيئة الـ Cubit مع معالجة الأخطاء
              BlocProvider(
                create: (context) {
                  final cubit = RoomsCubit(
                    roomRepository: context.read<RoomRepository>(),
                  )..fetchRoomsByType(type);
                  return cubit;
                },
              ),
            ],
            child: RoomsScreen(roomType: type),
          );
        } catch (e) {
          // Fallback UI في حالة الخطأ
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    e.toString(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => GoRouter.of(context).go('/'),
                    child: const Text('Return Home'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    ),

    GoRoute(
      path: '/review-booking',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        return MultiBlocProvider(
          providers: [
            BlocProvider<LoyaltyPointsCubit>(
              create: (context) => sl<LoyaltyPointsCubit>()..loadLoyaltyPoints(),
            ),
            BlocProvider<BookingCubit>(
              create: (context) => sl<BookingCubit>(),
            ),
          ],
          child: ReviewBookingScreen(
            room: extras['room'] as RoomEntity,
            selectedDate: extras['selectedDate'] as DateTime,
            checkInTime: extras['checkInTime'] as String,
            checkOutTime: extras['checkOutTime'] as String,
            numberOfSeats: extras['numberOfSeats'] as int,
            totalPrice: extras['totalPrice'] as double,
            workspaceId: extras['workspaceId'] as String,
          ),
        );
      },
    ),

    GoRoute(
      path: '/select-data',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        final room = extra['room'] as RoomEntity;
        final workspaceId = extra['workspaceId'] as String; // Add type cast
        final discountedPrice = extra['discountedPrice'] as double;
        return SelectDataScreen(
          room: room,
          discountedPrice: discountedPrice,
          workspaceId: workspaceId,
        );
      },
    ),
    GoRoute(
      path: '/account',
      builder: (context, state) => AccountPage(),
    ),

    GoRoute(
      path: '/loyalty',
      builder: (context, state) => const LoyaltyPage(),
    ),

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
            final getWorkspaceSchedulesUseCase = GetWorkspaceSchedulesUseCase(repository);

            return WorkspaceDetailsCubit(
              getWorkspaceDetailsUseCase: getWorkspaceDetailsUseCase,
              getRoomDetailsUseCase: getRoomDetailsUseCase,
              getWorkspaceReviewsUseCase: getWorkspaceReviewsUseCase,
              getWorkspaceSchedulesUseCase: getWorkspaceSchedulesUseCase,
            );
          },
          child: WorkspaceDetailsScreen(workspaceId: id),
        );
      },
    ),

    GoRoute(
      path: '/reservation-qrcode',
      builder: (context, state) {
        final reservationData = state.extra as Map<String, dynamic>;
        return ReservationQRCodeScreen(reservationData: reservationData);
      },
    ),

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
      builder: (context, state) => BlocProvider(
        create: (context) => sl<PaymentCubit>(),
        child: const CardsScreen(),
      ),
    ),
    GoRoute(
      path: '/add-card',
      builder: (context, state) => BlocProvider(
        create: (context) => sl<PaymentCubit>(),
        child: const AddCardScreen(),
      ),
    ),

    GoRoute(
      path: '/filter',
      builder: (context, state) => const FilterScreen(),
    ),

    GoRoute(
        path: '/rooms', builder: (context, state) => const RoomListScreen()),

    GoRoute(
      path: '/room/:id',
      builder: (context, state) {
        final String roomId = state.pathParameters['id'] ?? '';
        final extras = state.extra as Map<String, dynamic>?;

        final WorkspaceDetailsCubit? workspaceCubit = extras?['workspaceCubit'];
        final String? workspaceId = extras?['workspaceId'];

        RoomDetailsCubit createRoomDetailsCubitSafely() {
          if (!sl.isRegistered<RoomDetailsCubit>()) {
            // fallback manual creation (if needed) or show an error screen
            return RoomDetailsCubit(
              getRoomDetailsUseCase: sl(),
              getRoomImagesUseCase: sl(),
              getRoomOffersUseCase: sl(),
              getFavoriteRoomsUseCase: sl(),
              addFavoriteRoomUseCase: sl(),
              removeFavoriteRoomUseCase: sl(),
            );
          }
          return sl<RoomDetailsCubit>();
        }

        // ✅ Case 1: workspaceCubit is passed
        if (workspaceCubit != null) {
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: workspaceCubit),
              BlocProvider<RoomDetailsCubit>(
                create: (_) => createRoomDetailsCubitSafely(),
              ),
            ],
            child: RoomDetailsScreen(roomId: roomId),
          );
        }

        // ✅ Case 2: workspaceId is passed
        if (workspaceId != null) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<WorkspaceDetailsCubit>(
                create: (_) => _createWorkspaceCubit(workspaceId),
              ),
              BlocProvider<RoomDetailsCubit>(
                create: (_) => createRoomDetailsCubitSafely(),
              ),
            ],
            child: RoomDetailsScreen(
              roomId: roomId,
              workspaceId: workspaceId,
            ),
          );
        }

        // ❗ Fallback (neither workspaceCubit nor workspaceId was passed)
        return BlocProvider<RoomDetailsCubit>(
          create: (_) => createRoomDetailsCubitSafely(),
          child: RoomDetailsScreen(roomId: roomId),
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
            final remoteDataSource = FavoriteRemoteDataSourceImpl(dio: dio);
            final repository = FavoriteRepositoryImpl(remoteDataSource: remoteDataSource);
            return FavoriteCubit(
              getFavoriteRoomsUseCase: GetFavoriteRoomsUseCase(repository),
              removeFavoriteRoomUseCase: RemoveFavoriteRoomUseCase(repository),
            );
          },
          child: const FavoriteScreen(), // userId will be fetched inside FavoriteScreen
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
    GoRoute(
      path: '/request',
      builder: (context, state) {
        // Get staffId from extra parameters
        final extra = state.extra as Map<String, String>;
        final staffId = extra['staffId']!;

        return BlocProvider(
          create: (context) => sl<SendRequestCubit>(),
          child: RequestScreen(staffId: staffId), // Pass staffId to screen
        );
      },
    ),
    GoRoute(
      path: '/requests',
      builder: (context, state) => BlocProvider(
        create: (context) => sl<RequestsCubit>(),
        child: const RequestsScreen(),
      ),
    ),
    GoRoute(
      path: '/request-details',
      builder: (context, state) {
        final request = state.extra as Request;
        return RequestDetailScreen(request: request);
      },
    ),
  ],
);
// Helper function to extract workspace ID from cubit state
String? _getWorkspaceIdFromCubit(WorkspaceDetailsCubit cubit) {
  final state = cubit.state;
  if (state is WorkspaceDetailsLoaded) {
    return state.workspace.id;
  }
  return null;
}

// Helper function to create a new WorkspaceDetailsCubit
WorkspaceDetailsCubit _createWorkspaceCubit(String workspaceId) {
  final client = http.Client();
  final remoteDataSource = WorkspaceRemoteDataSourceImpl(client: client);
  final repository = WorkspaceRepositoryImpl(remoteDataSource: remoteDataSource);
  final getWorkspaceDetailsUseCase = GetWorkspaceDetailsUseCase(repository: repository);
  final getWorkspaceReviewsUseCase = GetWorkspaceReviewsUseCase(repository);
  final getRoomDetailsUseCase = GetRoomDetailsUseCase(repository: repository);
  final getWorkspaceSchedulesUseCase = GetWorkspaceSchedulesUseCase(repository);

  final cubit = WorkspaceDetailsCubit(
    getWorkspaceDetailsUseCase: getWorkspaceDetailsUseCase,
    getRoomDetailsUseCase: getRoomDetailsUseCase,
    getWorkspaceReviewsUseCase: getWorkspaceReviewsUseCase,
    getWorkspaceSchedulesUseCase: getWorkspaceSchedulesUseCase,
  );

  // Trigger the fetch
  cubit.getWorkspaceDetails(workspaceId);
  return cubit;
}
