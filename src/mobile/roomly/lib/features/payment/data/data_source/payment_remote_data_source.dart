import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:roomly/core/error/exceptions.dart';
import 'package:roomly/core/network/app_api.dart';
import '../models/card_model.dart';

abstract class PaymentRemoteDataSource {
  Future<List<CardModel>> getUserCards(String userId);
  Future<void> addCard(AddCardRequest request);
  Future<Map<String, dynamic>> processPayment({  // Changed from String to Map
    required String reservationId,
    required String userId,
    required String cardNumber,
    required String cvv,
    required String paymentMethod,
    required double amount,
  });
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
  @override
  Future<Map<String, dynamic>> processPayment({
    required String reservationId,
    required String userId,
    required String cardNumber,
    required String cvv,
    required String paymentMethod,
    required double amount,
  }) async {
    final url = Uri.parse('https://feminist-abigael-roomly-5d3753ef.koyeb.app/api/customer/pay')
        .replace(queryParameters: {
      'reservationId': reservationId,
      'userId': userId,
      'cardNumber': cardNumber,
      'cvv': cvv,
      'paymentMethod': paymentMethod,
      'amount': amount.toString(),
    });

    print("📡 Final API URL: $url");

    try {
      final response = await client.post(url);
      print("📥 Response Status: ${response.statusCode}");
      print("📦 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        // هنا بنعرض سبب الخطأ، مش بنرمي استثناء ساكت
        throw Exception('Server responded with status: ${response.statusCode}, body: ${response.body}');
      }
    } catch (e, stackTrace) {
      print("❌ Exception while calling payment API: $e");
      print("📍 StackTrace: $stackTrace");
      throw Exception('Unexpected error occurred while processing payment: $e');
    }
  }
}

