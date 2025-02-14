import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Roomly Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.push('/login'),
              child: const Text("Login"),
            ),
            ElevatedButton(
              onPressed: () => context.push('/signup'),
              child: const Text("Sign Up"),
            ),
            ElevatedButton(
              onPressed: () => context.push('/rooms'),
              child: const Text("View Rooms"),
            ),
          ],
        ),
      ),
    );
  }
}
