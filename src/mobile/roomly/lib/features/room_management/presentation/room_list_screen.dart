import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoomListScreen extends StatelessWidget {
  const RoomListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rooms List")),
      body: ListView.builder(
        itemCount: 5, // Example rooms
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("Room ${index + 1}"),
            subtitle: Text("Click to view details"),
            onTap: () => context.push('/room/${index + 1}'),
          );
        },
      ),
    );
  }
}
