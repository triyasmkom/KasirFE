import 'dart:convert';

import 'package:kasir_app/config/Config.dart';
import 'package:kasir_app/models/ProductModel.dart';
import 'package:kasir_app/models/UserModel.dart';
import 'package:kasir_app/services/auth_service.dart';
import 'package:http/http.dart' as http;

class KasirService {
  final String baseUrl = Config.apiUrl;
  final AuthService authService = AuthService();

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

  Future<List<ProductModel>> getAllTransactionByUserId() async {
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

  Future<UserModel> getProfileByUserId() async {
    final token = await authService.getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/users/profile"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "$token",
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonBody = jsonDecode(response.body);
      var body = jsonBody;

      return UserModel.fromJson(body);
    } else {
      throw Exception("Failed to load user profile: ${response.reasonPhrase}");
    }
  }
}
