import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:roomly/core/error/exceptions.dart';
import '../../../../core/network/app_api.dart';
import 'package:roomly/features/workspace/data/data_sources/workspace_remote_data_source.dart';
import 'package:roomly/features/room_management/data/models/room_model.dart';
import 'package:roomly/features/workspace/data/models/workspace_model.dart';

class WorkspaceRemoteDataSourceImpl implements WorkspaceRemoteDataSource {
  final http.Client client;

  WorkspaceRemoteDataSourceImpl({required this.client});

  @override
  Future<WorkspaceModel> getWorkspaceDetails(String workspaceId) async {
    final response = await client.get(
      Uri.parse("${AppApi.baseUrl}/api/customer/workspace/details?workspaceId=$workspaceId"),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return WorkspaceModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<RoomModel> getRoomDetails(String roomId) async {
    print('Fetching room details for roomId: $roomId');
    final response = await client.get(
      Uri.parse('${AppApi.baseUrl}/api/customer/room/details?roomId=$roomId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return RoomModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}

