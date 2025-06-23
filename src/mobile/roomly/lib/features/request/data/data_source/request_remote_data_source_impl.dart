import 'package:dio/dio.dart';
import 'package:roomly/core/error/exceptions.dart';
import 'package:roomly/features/request/data/data_source/request_remote_data_source.dart';
import 'package:roomly/features/request/data/models/request_model.dart';

class RequestRemoteDataSourceImpl implements RequestRemoteDataSource {
  final Dio dio;

  RequestRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<RequestModel>> getRequests(String userId) async {
    try {
      final response = await dio.get(
        'https://feminist-abigael-roomly-5d3753ef.koyeb.app/api/customer/requests?userId=$userId',
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => RequestModel.fromJson(json)).toList();
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      throw ServerException();
    }
  }
}


