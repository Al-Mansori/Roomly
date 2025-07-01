import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'failure.dart';

class NetworkService {
  final http.Client client;

  NetworkService({http.Client? client}) : client = client ?? http.Client();

  Future<dynamic> get({
    required String url,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse(url).replace(queryParameters: queryParameters);
      print(uri);
      final response = await client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          ...?headers,
        },
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response); // <== هيبقى dynamic
    } on SocketException {
      throw const NetworkException('No internet connection');
    } on HttpException {
      throw const NetworkException('Error connection');
    } on FormatException {
      throw const ServerException('bad response from the server');
    } catch (e) {
      throw ServerException('unexpected error: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> post({
    required String url,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await client.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          ...?headers,
        },
        body: body != null ? json.encode(body) : null,
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException('No internet connection');
    } on HttpException {
      throw const NetworkException('Error connection');
    } on FormatException {
      throw const ServerException('bad response from the server');
    } catch (e) {
      throw ServerException('unexpected error: ${e.toString()}');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        try {
          return json.decode(response.body) as Map<String, dynamic>;
        } catch (e) {
          throw const ServerException('error analysing response of the server');
        }
      case 400:
        throw const ServerException('wrong request');
      case 401:
        throw const ServerException('unauthorized access');
      case 403:
        throw const ServerException('forbidden access');
      case 404:
        throw const ServerException('server is not here');
      case 500:
        throw const ServerException('error in server');
      default:
        throw ServerException('error in server: ${response.statusCode}');
    }
  }

  void dispose() {
    client.close();
  }
}

