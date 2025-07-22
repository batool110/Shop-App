import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../error/app_exception.dart';

class HttpClient {
  static const Duration _timeoutDuration = Duration(seconds: 30);

  static Future<dynamic> get(String endpoint) async {
    try {
      final url = Uri.parse('${AppConstants.baseUrl}$endpoint');

      final response = await http
          .get(url, headers: {'Content-Type': 'application/json'})
          .timeout(_timeoutDuration);

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException();
    } on HttpException catch (e) {
      throw ServerException(e.message);
    } on FormatException {
      throw const ServerException('Invalid response format');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  static Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final url = Uri.parse('${AppConstants.baseUrl}$endpoint');

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data),
          )
          .timeout(_timeoutDuration);

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException();
    } on HttpException catch (e) {
      throw ServerException(e.message);
    } on FormatException {
      throw const ServerException('Invalid response format');
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  static dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);
      case 400:
        throw const ServerException('Bad request');
      case 401:
        throw const ServerException('Unauthorized');
      case 403:
        throw const ServerException('Forbidden');
      case 404:
        throw const ServerException('Not found');
      case 500:
        throw const ServerException('Internal server error');
      default:
        throw ServerException('HTTP Error: ${response.statusCode}');
    }
  }
}
