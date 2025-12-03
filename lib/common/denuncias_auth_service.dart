import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:huerto_hogar_2/common/api_client.dart';

class DenunciasAuthService {
  final _api = ApiClient();
  final _storage = const FlutterSecureStorage();

  Future<bool> login(String email, String password) async {
    final resp = await _api.post(
      '/api/login',
      {
        'email': email,
        'password': password,
      },
      auth: false, // 👈 login NO usa token previo
    );

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      final token = data['access_token'];
      await _storage.write(key: 'jwt', value: token); // 👈 GUARDAMOS JWT
      return true;
    }

    return false;
  }

  Future<void> ensureUserAndLogin(String email, String password) async {
    // 1) Intentar registrar (si ya existe devolverá 400 y lo ignoramos)
    final regResp = await _api.post(
      '/api/register',
      {
        'email': email,
        'password': password,
      },
      auth: false,
    );

    if (regResp.statusCode != 201 && regResp.statusCode != 400) {
      throw Exception(
          'Error registrando usuario en Flask: ${regResp.statusCode} ${regResp.body}');
    }

    // 2) Hacer login sí o sí
    final ok = await login(email, password);
    if (!ok) {
      throw Exception('Login en Flask falló');
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt');
  }

  Future<bool> hasToken() async {
    final token = await _storage.read(key: 'jwt');
    return token != null;
  }
}
