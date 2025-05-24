import 'package:go_router/go_router.dart';
import 'package:roomly/features/BookingsStatus/Activity.dart';
import 'package:roomly/features/account/presentation/account_screen.dart';
import 'package:roomly/features/auth/presentation/screens/OTP_Screen.dart';
import 'package:roomly/features/home/presentation/home_screen.dart';
import 'package:roomly/features/loyalty/presentation/loyalty_page.dart';
import 'package:roomly/features/payment/presentation/add_card_screen.dart';
import 'package:roomly/features/payment/presentation/cards_screen.dart';
import 'package:roomly/features/profile/presentation/profile_screen.dart';
import 'package:roomly/features/room_management/presentation/room_details_screen.dart';
import 'package:roomly/features/room_management/presentation/room_list_screen.dart';
import 'package:roomly/features/workspace/presentation/workspace_page.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/room_management/presentation/Booking_2nd_Screen.dart';
import '../../features/room_management/presentation/reservation_qrcode_screen.dart';
import '../../features/room_management/presentation/reviews_screen.dart';
import '../../features/Search/filter_screen.dart';

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
        );
      },
    ),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/booking',
      builder: (context, state) => const ActivityScreen(),
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

    GoRoute(
      path: '/workspace',
      builder: (context, state) => const WorkspaceListingsScreen(),
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
    GoRoute(
      path: '/room/:id',
      builder: (context, state) {
        final String id = state.pathParameters['id']!;
        return RoomDetailsScreen(roomId: id);
      },
    ),
  ],
);
