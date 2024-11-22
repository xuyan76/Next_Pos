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
      final url = '$baseUrl$path';
      print('发送GET请求到: $url');
      print('请求头: $_headers');

      final response = await http.get(
        Uri.parse(url),
        headers: _headers,
      );
      print('响应状态码: ${response.statusCode}');
      print('响应内容: ${response.body}');
      return _handleResponse(response, fromJson);
    } catch (e) {
      print('请求失败: $e');
      throw _handleError(e);
    }
  }

  Future<T> post<T>(
    String path,
    dynamic data,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final url = '$baseUrl$path';
      print('发送POST请求到: $url');
      print('请求头: $_headers');
      print('请求体: ${jsonEncode(data)}');

      final response = await http.post(
        Uri.parse(url),
        headers: _headers,
        body: jsonEncode(data),
      );
      print('响应状态码: ${response.statusCode}');
      print('响应内容: ${response.body}');
      return _handleResponse(response, fromJson);
    } catch (e) {
      print('请求失败: $e');
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
      try {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return fromJson(data);
      } catch (e) {
        print('JSON parse error: $e');
        throw ApiException(0, 'Invalid response format');
      }
    } else {
      throw ApiException(
        response.statusCode,
        'Request failed: ${response.statusCode} - ${response.body}',
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
