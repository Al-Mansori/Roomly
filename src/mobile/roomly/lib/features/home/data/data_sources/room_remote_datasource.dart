// lib/features/rooms/data/datasources/room_remote_data_source.dart
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../room_management/data/models/room_model.dart';
import '../models/room_for_type_model.dart';

class RoomRemoteDataSource {
  final http.Client client;

  RoomRemoteDataSource({required this.client});

  Future<List<RoomModelForType>> getRoomsByType(String type) async {
    final response = await client.get(
      Uri.parse('https://feminist-abigael-roomly-5d3753ef.koyeb.app/api/staff/room/type?type=$type'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => RoomModelForType.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load rooms');
    }
  }
}