import 'dart:convert';
import 'package:kasir_app/config/Config.dart';
import 'package:http/http.dart' as http;
import 'package:kasir_app/services/auth_service.dart';
import './../models/UserModel.dart';

class AdminService {
  final String baseUrl = Config.apiUrl;
  final AuthService authService = AuthService();

  Future<List<UserModel>> getAllUser() async {
    final token = authService.getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/users"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "$token",
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);

      return body.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to loas users");
    }
  }

  Future<void> addUser(
    String name,
    String email,
    String? role,
    String password,
  ) async {
    final token = authService.getToken();
    final response = await http.post(
      Uri.parse("$baseUrl/users"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "$token", // Tambahkan token untuk otorisasi
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'role': role,
        'password': password,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add user');
    }
  }

  Future<void> editUser(
    int id,
    String name,
    String email,
    String? role,
    String? password,
  ) async {
    final token = authService.getToken();

    final response = await http.put(
      Uri.parse("$baseUrl/users/$id"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "$token", // Tambahkan token untuk otorisasi
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'role': role,
        'password': password,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser(int id) async {
    final token = authService.getToken();
    final response = await http.delete(
      Uri.parse("$baseUrl/users/$id"),
      headers: {
        'Authorization': "$token", // Tambahkan token untuk otorisasi
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }
}
