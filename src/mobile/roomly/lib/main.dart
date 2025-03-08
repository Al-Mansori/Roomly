import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:roomly/core/router/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const RoomlyApp());
}

class RoomlyApp extends StatelessWidget {
  const RoomlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlaySt

        statusBarColor: Colors.black, // Change to any color you want
        statusBarIconBrightness: Brightness.light, // White icons
        systemNavigationBarColor: Colors.black, // Bottom bar color
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: MaterialApp.router(

        title: 'Roomly',
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
      ),
    );
  }
}
