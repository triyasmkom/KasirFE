import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kasir_app/models/TransactionModel.dart';
import 'package:kasir_app/services/transaction_service.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  late Future<List<TransactionModel>> transactions;

  void transactionItem(int id) {
    print("Button pressed for transaction ID: ${id}");

    Navigator.pushNamed(
      context,
      "/transaction_item",
      arguments: id,
    );
  }

  // Fungsi untuk memuat ulang pengguna
  void reloadUsers() {
    setState(() {
      transactions = TransactionService().getTransactionByUserId();
    });
  }

  String formatDateTime(String inputTime) {
    // Parse waktu yang datang dari server
    DateTime parsedTime = DateTime.parse(inputTime);

    // Format ulang ke "2024-10-11 16:24:54"
    String formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(parsedTime);

    return formattedTime;
  }

  @override
  void initState() {
    super.initState();
    transactions = TransactionService().getTransactionByUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Riwayat Transaksi",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: transactions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Gagal memuat data transaksi'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada transaksi ditemukan'));
          }

          // Jika data tersedia
          List<TransactionModel> transactions = snapshot.data!;
          var index = 0;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('No')),
                DataColumn(label: Text('Kode Transaksi')),
                DataColumn(label: Text('Total Harga')),
                DataColumn(label: Text('Metode Pembayaran')),
                DataColumn(label: Text('Waktu Transaksi')),
                DataColumn(label: Text("Action"))
              ],
              rows: transactions.map((transaction) {
                index++;

                return DataRow(
                  cells: [
                    DataCell(Text(index.toString())),
                    DataCell(Text(transaction.kodeTransaksi)),
                    DataCell(Text('Rp ${transaction.totalHarga}')),
                    DataCell(Text(transaction.metodePembayaran)),
                    DataCell(Text(formatDateTime(transaction.waktuTransaksi))),
                    DataCell(
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              transactionItem(transaction.id);
                            },
                            child: Text(
                              "Detail",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
