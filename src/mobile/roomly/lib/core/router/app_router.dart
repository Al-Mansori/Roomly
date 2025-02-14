import 'package:go_router/go_router.dart';
import 'package:roomly/features/home/presentation/home_screen.dart';
import 'package:roomly/features/room_management/presentation/room_details_screen.dart';
import 'package:roomly/features/room_management/presentation/room_list_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
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
