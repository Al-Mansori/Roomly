import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:roomly/core/error/exceptions.dart';
import 'package:roomly/core/network/app_api.dart';
import 'package:roomly/features/auth/data/data_sources/secure_storage.dart';
import '../../../GlobalWidgets/app_session.dart';
import '../models/loyalty_points_model.dart';

// Remote Data Source
abstract class LoyaltyPointsRemoteDataSource {
  Future<LoyaltyPointsModel> getLoyaltyPoints(String userId);
  Future<LoyaltyPointsModel> updateLoyaltyPoints(LoyaltyPointsModel loyaltyPoints);
  Future<bool> addPoints(String userId, int points);
  Future<bool> redeemPoints(String userId, int points);
}

class LoyaltyPointsRemoteDataSourceImpl implements LoyaltyPointsRemoteDataSource {
  final http.Client client;
  static const String baseUrl = AppApi.baseUrl; // Update with your actual backend URL

  LoyaltyPointsRemoteDataSourceImpl({required this.client});

  @override
  Future<LoyaltyPointsModel> getLoyaltyPoints(String userId) async {
    try {
      // Get auth token from secure storage
      // final token = await SecureStorage.getToken();
      final token = AppSession().token;

      if (token == null) {
        throw Exception('No auth token found');
      }

      final url = Uri.parse('$baseUrl/api/customer/loyalty/points?userId=$userId');
      
      final response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        
        // If the API returns just the points count, create a model with default values
        if (jsonData.containsKey('totalPoints') || jsonData.containsKey('points')) {
          final totalPoints = jsonData['totalPoints'] ?? jsonData['points'] ?? 0;
          return LoyaltyPointsModel(
            totalPoints: totalPoints is int ? totalPoints : int.tryParse(totalPoints.toString()) ?? 0,
            lastAddedPoint: jsonData['lastAddedPoint'] ?? 0,
            lastUpdatedDate: jsonData['lastUpdatedDate'] != null 
                ? DateTime.parse(jsonData['lastUpdatedDate'])
                : DateTime.now(),
            userId: userId,
          );
        } else if (jsonData.isEmpty) {
          throw NoDataException(message: 'No loyalty points data found for this user');
        } else {
          // If the API returns the full loyalty points object
          return LoyaltyPointsModel.fromJson(jsonData);
        }
      } else if (response.statusCode == 404) {
        throw NoDataException(message: 'Loyalty points not found for this user');
      } else {
        throw Exception('Failed to load loyalty points: ${response.statusCode}');
      }
    } catch (e) {
      if (e is NoDataException) {
        rethrow;
      } else {
        throw Exception('Error fetching loyalty points: $e');
      }
    }
  }

  @override
  Future<LoyaltyPointsModel> updateLoyaltyPoints(LoyaltyPointsModel loyaltyPoints) async {
    try {
      final token = await SecureStorage.getToken();
      if (token == null) {
        throw Exception('No auth token found');
      }

      final url = Uri.parse('$baseUrl/loyalty/points');
      
      final response = await client.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(loyaltyPoints.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        return LoyaltyPointsModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to update loyalty points: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating loyalty points: $e');
    }
  }

  @override
  Future<bool> addPoints(String userId, int points) async {
    try {
      final token = await SecureStorage.getToken();
      if (token == null) {
        throw Exception('No auth token found');
      }

      final url = Uri.parse('$baseUrl/loyalty/points/add');
      
      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'userId': userId,
          'points': points,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error adding points: $e');
    }
  }

  @override
  Future<bool> redeemPoints(String userId, int points) async {
    try {
      final token = await SecureStorage.getToken();
      if (token == null) {
        throw Exception('No auth token found');
      }

      final url = Uri.parse('$baseUrl/loyalty/points/redeem');
      
      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'userId': userId,
          'points': points,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error redeeming points: $e');
    }
  }
}

