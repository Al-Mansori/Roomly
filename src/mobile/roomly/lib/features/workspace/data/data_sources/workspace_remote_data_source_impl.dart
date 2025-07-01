import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:roomly/core/error/exceptions.dart';
import 'package:roomly/features/workspace/data/models/review_model.dart';
import 'package:roomly/features/workspace/data/models/user_model_workspace.dart';
import 'package:roomly/features/workspace/domain/entities/user_entity_workspace.dart';
import '../../../../core/network/app_api.dart';
import 'package:roomly/features/workspace/data/data_sources/workspace_remote_data_source.dart';
import 'package:roomly/features/room_management/data/models/room_model.dart';
import 'package:roomly/features/workspace/data/models/workspace_model.dart';

import 'package:roomly/features/workspace/data/models/workspace_schedule_model.dart';

class WorkspaceRemoteDataSourceImpl implements WorkspaceRemoteDataSource {
  final http.Client client;

  WorkspaceRemoteDataSourceImpl({required this.client});

  @override
  Future<WorkspaceModel> getWorkspaceDetails(String workspaceId) async {
    final response = await client.get(
      Uri.parse("${AppApi.baseUrl}/api/customer/workspace/details?workspaceId=$workspaceId"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return WorkspaceModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<RoomModel> getRoomDetails(String roomId) async {
    print("Fetching room details for roomId: $roomId");
    final response = await client.get(
      Uri.parse("${AppApi.baseUrl}/api/customer/room/details?roomId=$roomId"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return RoomModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<ReviewModel>> getWorkspaceReviews(String workspaceId) async {
    print("Fetching workspace reviews for workspaceId: $workspaceId");
    final response = await client.get(
      Uri.parse("${AppApi.baseUrl}/api/customer/WorkspaceReviews?workspaceId=$workspaceId"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => ReviewModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<UserEntity2> getUserName(String userId) async {
    print("Fetching user name for userId: $userId");
    final response = await client.get(
      Uri.parse("${AppApi.baseUrl}/api/users/username?userId=$userId"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return UserModel2.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> submitReview({required String comment, required String userId, required String workspaceId, required double rating}) async {
    print("Submitting review for workspaceId: $workspaceId, userId: $userId");
    final response = await client.post(
      Uri.parse("${AppApi.baseUrl}/api/customer/review?comment=$comment&userId=$userId&workspaceId=$workspaceId&rating=$rating"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode != 200) {
      throw ServerException();
    }
  }

  @override
  Future<List<WorkspaceScheduleModel>> getWorkspaceSchedules(String workspaceId) async {
    print("Fetching workspace schedules for workspaceId: $workspaceId");
    final response = await client.get(
      Uri.parse("https://feminist-abigael-roomly-5d3753ef.koyeb.app/api/staff/workspace-schedules/workspace/$workspaceId"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => WorkspaceScheduleModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }
}


  