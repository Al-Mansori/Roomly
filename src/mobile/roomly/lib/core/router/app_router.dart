import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
import 'package:roomly/features/home/presentation/home_screen.dart';
import 'package:roomly/features/loyalty/presentation/loyalty_page.dart';
import 'package:roomly/features/payment/presentation/add_card_screen.dart';
import 'package:roomly/features/payment/presentation/cards_screen.dart';
import 'package:roomly/features/profile/presentation/profile_screen.dart';
import 'package:roomly/features/room_management/presentation/cubits/room_details_cubit.dart';
import 'package:roomly/features/room_management/presentation/di/room_management_injection_container.dart'
    as di;
import 'package:roomly/features/room_management/presentation/screens/room_details_screen.dart';
import 'package:roomly/features/room_management/presentation/screens/room_list_screen.dart';
import 'package:roomly/features/room_management/presentation/screens/Booking_2nd_Screen.dart';
import 'package:roomly/features/room_management/presentation/screens/reservation_qrcode_screen.dart';
import 'package:roomly/features/room_management/presentation/screens/reviews_screen.dart';
import 'package:roomly/features/workspace/presentation/screens/workspace_details_screen.dart';
import '../../features/auth/presentation/screens/forget_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/Search/filter_screen.dart';
import 'package:roomly/features/favorite/presentation/screens/favorite_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
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
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
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
    //   path: '/workspace',
    //   builder: (context, state) => const WorkspaceListingsScreen(),
    // ),

    GoRoute(
      path: '/workspace/:id',
      builder: (context, state) {
        final String id = state.pathParameters['id']!;
        return WorkspaceDetailsScreen(workspaceId: id);
      },
    ),

    GoRoute(
      path: '/reservation-qrcode',
      builder: (context, state) => const ReservationQRCodeScreen(),
    ),
    GoRoute(
      path: '/reviews',
      builder: (context, state) => const ReviewsScreen(),
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
    //     final String id = state.pathParameters['id']!;
    //     return RoomDetailsScreen(roomId: id);
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
  ],
);
