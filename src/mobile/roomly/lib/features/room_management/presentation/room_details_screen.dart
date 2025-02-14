import 'package:flutter/material.dart';

class RoomDetailsScreen extends StatelessWidget {
  final String roomId;

  const RoomDetailsScreen({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Room Details - $roomId")),
      body: Center(
        child: Text("Details of Room $roomId",
            style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}
