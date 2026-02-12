
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'base_api_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:webflow_auth_app/core/error/exceptions.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NetworkApiService extends BaseApiService {
  final http.Client _client;
  final FlutterSecureStorage? _storage;

  NetworkApiService({
    http.Client? client,
    FlutterSecureStorage? storage,
  })  : _client = client ?? http.Client(),
        _storage = storage;

  @override
  Future<dynamic> getApi(String url, {Map<String, String>? headers}) async {
    if (kDebugMode) {
      print('GET URL: $url');
    }

    try {
      final finalHeaders = await _getHeaders(headers);
      final response = await _client
          .get(Uri.parse(url), headers: finalHeaders)
          .timeout(const Duration(seconds: 30));

      return _returnResponse(response);
    } on SocketException {
      throw InternetException();
    } on TimeoutException {
      throw RequestTimeOutException();
    } catch (e) {
      throw FetchDataException(e.toString());
    }
  }

  @override
  Future<dynamic> postApi(String url, dynamic data, {Map<String, String>? headers}) async {
    if (kDebugMode) {
      print('POST URL: $url');
      print('POST Data: $data');
    }

    try {
      final finalHeaders = await _getHeaders(headers);
      final response = await _client.post(
        Uri.parse(url),
        headers: finalHeaders,
        body: data is Map ? jsonEncode(data) : data,
      ).timeout(const Duration(seconds: 30));

      return _returnResponse(response);
    } on SocketException {
      throw InternetException();
    } on TimeoutException {
      throw RequestTimeOutException();
    } catch (e) {
      throw FetchDataException(e.toString());
    }
  }


  Future<Map<String, String>> _getHeaders([Map<String, String>? additionalHeaders]) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Safely read from storage if available
    if (_storage != null) {
      try {
        final token = await _storage.read(key: 'auth_token');
        if (token != null && token.isNotEmpty) {
          headers['Authorization'] = 'Bearer $token';
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error reading from secure storage: $e');
        }
      }
    }

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  dynamic _returnResponse(http.Response response) {
    if (kDebugMode) {
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
    }

    switch (response.statusCode) {
      case 200:
      case 201:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        dynamic responseJson = jsonDecode(response.body);
        throw BadRequestException(responseJson['message'] ?? 'Bad request');
      case 401:
        dynamic responseJson = jsonDecode(response.body);
        throw UnauthorizedException(responseJson['message'] ?? 'Unauthorized access');
      case 403:
        dynamic responseJson = jsonDecode(response.body);
        throw UnauthorizedException(responseJson['message'] ?? 'Forbidden access');
      case 404:
        dynamic responseJson = jsonDecode(response.body);
        throw NotFoundException(responseJson['message'] ?? 'Resource not found');
      case 500:
      case 501:
      case 502:
      case 503:
        dynamic responseJson = jsonDecode(response.body);
        throw ServerException(responseJson['message'] ?? 'Server error');
      default:
        throw FetchDataException('Error occurred with status code: ${response.statusCode}');
    }
  }
}
