import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:kasir_app/config/Config.dart';

class AuthService {
  final String baseUrl = Config.apiUrl;
  final storage = FlutterSecureStorage(); // Untuk menyimpan token secara aman

  Future<String?> login(String email, String password) async {
    final response = await http.post(Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'email': email, 'password': password}));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      String token = data["token"];

      await storage.write(key: "jwt_token", value: token);

      return token;
    } else {
      return null;
    }
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'jwt_token');
  }

  // Fungsi untuk mengambil role dari token JWT
  Future<String?> getRole() async {
    String? token = await storage.read(key: 'jwt_token');

    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return decodedToken['role']; // Mengembalikan role dari token
    } else {
      return null; // Jika token tidak ditemukan
    }
  }

  Future<bool> logout() async {
    await storage.delete(key: 'jwt_token'); // Menghapus token saat logout
    String? token = await storage.read(key: 'jwt_token');
    if (token != null) {
      return true; // Mengembalikan role dari token
    } else {
      return false; // Jika token tidak ditemukan
    }
  }
}
