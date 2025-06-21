import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:roomly/core/error/exceptions.dart';
import 'package:roomly/core/network/app_api.dart';
import '../models/card_model.dart';

abstract class PaymentRemoteDataSource {
  Future<List<CardModel>> getUserCards(String userId);
  Future<void> addCard(AddCardRequest request);
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final http.Client client;
  final AppApi appApi;

  PaymentRemoteDataSourceImpl({
    required this.client,
    required this.appApi,
  });

  @override
  Future<List<CardModel>> getUserCards(String userId) async {
    try {
      final response = await client.get(
        Uri.parse('https://feminist-abigael-roomly-5d3753ef.koyeb.app/api/customer/get-credit-cards?userId=$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => CardModel.fromJson(json)).toList();
      } else {
        throw ServerException();
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException();
    }
  }

  @override
  Future<void> addCard(AddCardRequest request) async {
    try {
      final response = await client.post(
        Uri.parse('https://feminist-abigael-roomly-5d3753ef.koyeb.app/api/customer/add-credit'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 400) {
        throw ServerException();
      } else {
        throw ServerException();
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException();
    }
  }
}

