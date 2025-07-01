import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/network/app_api.dart';
import '../models/search_result_model.dart';
import '../../domain/entities/filter_params.dart';

abstract class SearchRemoteDataSource {
  Future<SearchResultModel> search(String query);
  Future<List<RoomModel>> filterRooms(FilterParams filterParams);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final Dio dio;

  SearchRemoteDataSourceImpl({required this.dio});

  @override
  Future<SearchResultModel> search(String query) async {
    try {
      final response = await dio.get(
        '${AppApi.baseUrl}/api/customer/search',
        queryParameters: {'query': query},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        return SearchResultModel.fromJson(response.data);
      } else {
        throw Exception('Failed to search: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Search failed: ${e.message}');
    }
  }

  @override
  Future<List<RoomModel>> filterRooms(FilterParams filterParams) async {
    try {
      final response = await dio.get(
        '${AppApi.baseUrl}/api/customer/rooms/filter',
        queryParameters: filterParams.toQueryParams(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> roomsJson = response.data;
        return roomsJson
            .map((roomJson) => RoomModel.fromJson(roomJson['room']))
            .toList();
      } else {
        throw Exception('Failed to filter rooms: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Filter failed: ${e.message}');
    }
  }
}
