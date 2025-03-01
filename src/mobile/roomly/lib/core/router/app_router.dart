import 'package:go_router/go_router.dart';
import 'package:roomly/features/auth/presentation/screens/OTP_Screen.dart';
import 'package:roomly/features/home/presentation/home_screen.dart';
import 'package:roomly/features/profile/presentation/Booking_Screen.dart';
import 'package:roomly/features/profile/presentation/profile_screen.dart';
import 'package:roomly/features/room_management/presentation/room_details_screen.dart';
import 'package:roomly/features/room_management/presentation/room_list_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',

  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    GoRoute(path: '/verify', builder: (context, state) => const OtpVerifyScreen()),
    GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
    GoRoute(path: '/booking', builder: (context, state) => const BookingScreen()),

    GoRoute(
        path: '/rooms', builder: (context, state) => const RoomListScreen()),
    GoRoute(
      path: '/room/:id',
      builder: (context, state) {
        final String id = state.pathParameters['id']!;
        return RoomDetailsScreen(roomId: id);
      },
    ),
  ],
);
