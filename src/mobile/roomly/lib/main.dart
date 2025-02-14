import 'package:flutter/material.dart';
import 'package:roomly/core/router/app_router.dart';

void main() {
  runApp(const RoomlyApp());
}

class RoomlyApp extends StatelessWidget {
  const RoomlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Roomly',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter, // Using GoRouter for navigation
    );
  }
}
