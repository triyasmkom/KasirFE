import 'dart:convert';
import 'package:kasir_app/config/Config.dart';
import 'package:http/http.dart' as http;
import 'package:kasir_app/models/ProductModel.dart';
import 'package:kasir_app/services/auth_service.dart';
import './../models/UserModel.dart';

class AdminService {
  final String baseUrl = Config.apiUrl;
  final AuthService authService = AuthService();

  Future<List<UserModel>> getAllUser() async {
    final token = await authService.getToken();

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
      throw Exception("Failed to load users");
    }
  }

  Future<void> addUser(
    String name,
    String email,
    String? role,
    String password,
  ) async {
    final token = await authService.getToken();
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
    final token = await authService.getToken();

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
    final token = await authService.getToken();
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

  Future<List<ProductModel>> getAllProducts() async {
    final token = await authService.getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/products"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "$token",
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonBody = jsonDecode(response.body);
      List<dynamic> body = jsonBody['data'];

      return body.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load product");
    }
  }

  Future<void> addProduct(
    String name,
    int stock,
    int price,
  ) async {
    final token = await authService.getToken();
    final response = await http.post(
      Uri.parse("$baseUrl/products"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "$token", // Tambahkan token untuk otorisasi
      },
      body: jsonEncode({
        'name': name,
        'stock': stock,
        'price': price,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add Product');
    }
  }

  Future<void> editProduct(
    int id,
    String name,
    int stock,
    int price,
  ) async {
    final token = await authService.getToken();

    final response = await http.put(
      Uri.parse("$baseUrl/products/$id"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "$token", // Tambahkan token untuk otorisasi
      },
      body: jsonEncode({
        'name': name,
        'stock': stock,
        'price': price,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update Product');
    }
  }

  Future<void> deleteProduct(int id) async {
    final token = await authService.getToken();
    final response = await http.delete(
      Uri.parse("$baseUrl/products/$id"),
      headers: {
        'Authorization': "$token", // Tambahkan token untuk otorisasi
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete Product');
    }
  }
}
