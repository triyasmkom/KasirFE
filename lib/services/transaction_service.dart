import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kasir_app/config/Config.dart';
import 'package:kasir_app/models/TransactionItemModel.dart';
import 'package:kasir_app/models/TransactionModel.dart';
import 'package:kasir_app/services/auth_service.dart';

class TransactionService {
  final String baseUrl = Config.apiUrl;

  Future<void> saveTransaction(Map<String, dynamic> trasactionData) async {
    final token = await AuthService().getToken();

    final response = await http.post(Uri.parse("$baseUrl/transactions"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "$token",
        },
        body: jsonEncode(trasactionData));

    if (response.statusCode != 200) {
      throw Exception("Failed to save transaction");
    }
  }

  Future<List<TransactionModel>> getTransactionByUserId() async {
    final token = await AuthService().getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/transactions/user"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "$token",
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonBody = jsonDecode(response.body);
      List<dynamic> body = jsonBody['data'];

      return body.map((json) => TransactionModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load product");
    }
  }

  Future<List<TransactionItemModel>> getTransactionItemByTransactionId(
      int id) async {
    final token = await AuthService().getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/transactions/detail/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "$token",
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonBody = jsonDecode(response.body);
      List<dynamic> body = jsonBody['data'];

      return body.map((json) => TransactionItemModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load product");
    }
  }
}
