import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  static const String baseUrl = 'https://aa6e6e72fdc2.ngrok-free.app';

  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return _storage.read(key: 'jwt');
  }

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  Future<http.Response> post(
    String path,
    Map<String, dynamic> body, {
    bool auth = true,
  }) async {
    final token = auth ? await _getToken() : null;

    return http.post(
      _uri(path),
      headers: {
        'Content-Type': 'application/json',
        if (auth && token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> get(
    String path, {
    bool auth = true,
  }) async {
    final token = auth ? await _getToken() : null;

    return http.get(
      _uri(path),
      headers: {
        'Content-Type': 'application/json',
        if (auth && token != null) 'Authorization': 'Bearer $token',
      },
    );
  }
}