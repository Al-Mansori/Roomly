import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/workspace_model.dart';
import 'constants.dart';
import 'failure.dart';
import 'network_service.dart';

abstract class WorkspaceRemoteDataSource {
  Future<List<WorkspaceModel>> getNearbyWorkspaces({
    required String userId,
    required double latitude,
    required double longitude,
    int topN = 5,
  });

  Future<List<WorkspaceModel>> getTopRatedWorkspaces({
    required String userId,
    int topN = 5,
  });

  Future<WorkspaceModel> getWorkspaceDetails({
    required String workspaceId,
  });

  Future<List<String>> getWorkspaceImages({  // Changed to return List<String>
    required String workspaceId,
  });
}


class WorkspaceRemoteDataSourceImpl implements WorkspaceRemoteDataSource {
  final NetworkService networkService;

  WorkspaceRemoteDataSourceImpl({
    required this.networkService,
  });


  @override
  Future<List<WorkspaceModel>> getNearbyWorkspaces({
    required String userId,
    required double latitude,
    required double longitude,
    int topN = 5,
  }) async {
    try {
      final response = await networkService.get(
        url: HomeConstants.nearbyWorkspacesUrl,
        queryParameters: {
          'user_id': userId,
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
          'top_n': topN.toString(),
        },
      );

      final rawData = response;

      if (rawData is Map<String, dynamic> &&
          rawData['data'] is Map<String, dynamic> &&
          rawData['data']['recommendations'] is List) {

        final List recommendations = rawData['data']['recommendations'];

        return recommendations.map((workspace) => WorkspaceModel.fromNearbyJson({
          ...workspace,
          'images': workspace['images'] ?? [],
        })).toList();

      } else {
        throw const ServerException("Invalid response format");
      }

    } catch (e) {
      throw ServerException('Failed to fetch nearby workspaces: ${e.toString()}');
    }
  }

  @override
  Future<List<WorkspaceModel>> getTopRatedWorkspaces({
    required String userId,
    int topN = 5,
  }) async {
    try {
      final response = await networkService.get(
        url: HomeConstants.topRatedWorkspacesUrl,
        queryParameters: {
          'user_id': userId,
          'top_n': topN.toString(),
        },
      );

      final data = response['data'];
      if (data is Map<String, dynamic> && data['recommendations'] is List) {

        final recommendations = data['recommendations'] as List;
        return recommendations
            .map((workspace) {
          if (workspace is Map<String, dynamic>) {
            return WorkspaceModel.fromTopRatedJson({
              ...workspace,
              'images': workspace['images'] ?? [],
            });
          } else {
            throw const ServerException('Unexpected data type in recommendations list');
          }
        }).toList();

        // continue mapping here
      } else {
        throw const ServerException("Invalid response format");
      }


    } catch (e) {
      throw ServerException('Failed to fetch top rated workspaces: ${e.toString()}');
    }
  }

  @override
  Future<WorkspaceModel> getWorkspaceDetails({
    required String workspaceId,
  }) async {
    try {
      final response = await networkService.get(
        url: HomeConstants.workspaceDetailsUrl,
        queryParameters: {
          'workspaceId': workspaceId,
        },
      );
      debugPrint("🔥🔥 API workspace details response: ${jsonEncode(response)}");

      return WorkspaceModel.fromDetailsJson({
        ...response,
        'images': response['images'] ?? [],
      });
    } catch (e) {
      throw ServerException('Failed to fetch workspace details: ${e.toString()}');
    }
  }

  @override
  Future<List<String>> getWorkspaceImages({
    required String workspaceId,
  }) async {
    try {
      final uri = Uri.parse(HomeConstants.workspaceImageUrl)
          .replace(queryParameters: {'workspaceId': workspaceId});
      print(uri);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((img) => img['imageUrl']?.toString() ?? '')
            .where((url) => url.isNotEmpty)
            .toList();
      } else {
        throw ServerException('Server returned ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException('Failed to fetch workspace images: ${e.toString()}');
    }
  }


}