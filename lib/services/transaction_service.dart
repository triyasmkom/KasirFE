import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kasir_app/config/Config.dart';
import 'package:kasir_app/services/auth_service.dart';

class TransactionService {
  final String baseUrl = Config.apiUrl;

  Future<void> saveTransaction(Map<String, dynamic> trasactionData) async {
    print("trasactionData $trasactionData");
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
}
