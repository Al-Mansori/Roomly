import 'package:roomly/core/network/app_api.dart';
import 'package:roomly/features/room_management/data/models/offer_model.dart';
import 'package:dio/dio.dart';

abstract class OfferRemoteDataSource {
  Future<List<OfferModel>> getRoomOffers(String roomId);
}

class OfferRemoteDataSourceImpl implements OfferRemoteDataSource {
  final Dio dio;

  OfferRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<OfferModel>> getRoomOffers(String roomId) async {
    try {
      final response = await dio.get('${AppApi.baseUrl}/api/staff/offers/room/$roomId');
      if (response.data == null || response.data.isEmpty) {
        return [];
      }
      return (response.data as List).map((e) => OfferModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load room offers: $e');
    }
  }
}

