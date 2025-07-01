// lib/core/network/api_service.dart
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;
  final String baseUrl;

  ApiService({
    required this.baseUrl,
    required Dio dio, // Add Dio as a required parameter
  }) : _dio = dio {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  Future<dynamic> get(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? headers,
      }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<dynamic> post(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? headers,
      }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<dynamic> put(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? headers,
      }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<dynamic> delete(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? headers,
      }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  dynamic _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw TimeoutException('Request timed out');
      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case 400:
            throw BadRequestException(error.response?.data);
          case 401:
            throw UnauthorizedException(error.response?.data);
          case 403:
            throw ForbiddenException(error.response?.data);
          case 404:
            throw NotFoundException(error.response?.data);
          case 500:
          case 502:
          case 503:
            throw ServerException(error.response?.data);
          default:
            throw ApiException(
                'Received invalid status code: ${error.response?.statusCode}');
        }
      case DioExceptionType.cancel:
        throw CancelException('Request cancelled');
      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') ?? false) {
          throw NoInternetException('No internet connection');
        }
        throw UnknownException(error.message);
      case DioExceptionType.badCertificate:
        throw BadCertificateException('Bad certificate');
      case DioExceptionType.connectionError:
        throw ConnectionErrorException('Connection error');
    }
  }
}

// lib/core/network/api_exceptions.dart
class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class BadRequestException extends ApiException {
  BadRequestException([dynamic message]) : super(message ?? 'Bad request');
}

class UnauthorizedException extends ApiException {
  UnauthorizedException([dynamic message]) : super(message ?? 'Unauthorized');
}

class ForbiddenException extends ApiException {
  ForbiddenException([dynamic message]) : super(message ?? 'Forbidden');
}

class NotFoundException extends ApiException {
  NotFoundException([dynamic message]) : super(message ?? 'Not found');
}

class ServerException extends ApiException {
  ServerException([dynamic message]) : super(message ?? 'Server error');
}

class TimeoutException extends ApiException {
  TimeoutException([dynamic message]) : super(message ?? 'Request timed out');
}

class CancelException extends ApiException {
  CancelException([dynamic message]) : super(message ?? 'Request cancelled');
}

class NoInternetException extends ApiException {
  NoInternetException([dynamic message])
      : super(message ?? 'No internet connection');
}

class UnknownException extends ApiException {
  UnknownException([dynamic message]) : super(message ?? 'Unknown error');
}

class BadCertificateException extends ApiException {
  BadCertificateException([dynamic message])
      : super(message ?? 'Bad certificate');
}

class ConnectionErrorException extends ApiException {
  ConnectionErrorException([dynamic message])
      : super(message ?? 'Connection error');
}