import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  factory HttpClient() => _instance;
  HttpClient._internal();

  final String baseUrl = AppConfig.instance.apiBaseUrl;
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        // 如果需要token认证，可以在这里添加
        // 'Authorization': 'Bearer $token',
      };

  Future<T> get<T>(
      String path, T Function(Map<String, dynamic>) fromJson) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$path'),
        headers: _headers,
      );
      return _handleResponse(response, fromJson);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<T> post<T>(
    String path,
    dynamic data,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$path'),
        headers: _headers,
        body: jsonEncode(data),
      );
      return _handleResponse(response, fromJson);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<T> put<T>(
    String path,
    dynamic data,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$path'),
        headers: _headers,
        body: jsonEncode(data),
      );
      return _handleResponse(response, fromJson);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<T> delete<T>(
      String path, T Function(Map<String, dynamic>) fromJson) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$path'),
        headers: _headers,
      );
      return _handleResponse(response, fromJson);
    } catch (e) {
      throw _handleError(e);
    }
  }

  T _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw ApiException(
        response.statusCode,
        'Request failed: ${response.statusCode}',
      );
    }
  }

  Exception _handleError(dynamic error) {
    print('API Error: $error');
    if (error is ApiException) return error;
    return ApiException(0, error.toString());
  }
}

class ApiException implements Exception {
  final int code;
  final String message;

  ApiException(this.code, this.message);

  @override
  String toString() => 'ApiException: $code - $message';
}
