import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:roomly/features/GlobalWidgets/app_session.dart';

class LoyaltyApiService {
  // Base URL - Update this to match your backend URL
  static const String baseUrl = 'https://feminist-abigael-roomly-5d3753ef.koyeb.app';
  
  /// Fetches loyalty points for the current user
  /// Returns the total points as an integer, or null if failed
  static Future<int?> getLoyaltyPoints() async {
    try {
      // Get userId from secure storage
      final userId = AppSession().currentUser?.id;
      if (userId == null) {
        print('No user ID found in secure storage');
        return null;
      }

      // Get auth token for authorization
      final token = AppSession().token;
      if (token == null) {
        print('No auth token found in secure storage');
        return null;
      }

      // Prepare the API request
      final url = Uri.parse('$baseUrl/api/customer/loyalty/points?userId=$userId');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Adjust authorization header format as needed
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        
        // Extract total points from response
        // Adjust the key name based on your API response structure
        final totalPoints = data['totalPoints'] ?? 0;
        
        return totalPoints is int ? totalPoints : int.tryParse(totalPoints.toString()) ?? 0;
      } else {
        print('Failed to fetch loyalty points: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching loyalty points: $e');
      return null;
    }
  }

  /// Fetches loyalty points with retry mechanism
  /// Returns the total points as an integer, or 0 if failed after retries
  static Future<int> getLoyaltyPointsWithRetry({int maxRetries = 3}) async {
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      final points = await getLoyaltyPoints();
      if (points != null) {
        return points;
      }
      
      if (attempt < maxRetries) {
        // Wait before retrying (exponential backoff)
        await Future.delayed(Duration(seconds: attempt * 2));
      }
    }
    
    // Return 0 if all attempts failed
    return 0;
  }

  /// Checks if the user is authenticated and has required data for API calls
  static Future<bool> isUserAuthenticated() async {
    final userId = AppSession().currentUser?.id;
    final token = AppSession().token;
    return userId != null && token != null;
  }
}

