import 'package:flutter/material.dart';
import 'package:kasir_app/models/TransactionItemModel.dart';
import 'package:kasir_app/services/transaction_service.dart';

class TransactionItems extends StatefulWidget {
  const TransactionItems({super.key});

  @override
  State<TransactionItems> createState() => _TransactionItemsState();
}

class _TransactionItemsState extends State<TransactionItems> {
  late Future<List<TransactionItemModel>> transactionItems;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final int transactionId = ModalRoute.of(context)!.settings.arguments as int;
    transactionItems =
        TransactionService().getTransactionItemByTransactionId(transactionId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Transaksi Item"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: transactionItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Gagal memuat data transaksi'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada transaksi ditemukan'));
          }

          // Jika data tersedia
          List<TransactionItemModel> transactionItems = snapshot.data!;
          var index = 0;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('No')),
                DataColumn(label: Text('Produk')),
                DataColumn(label: Text('Kode')),
                DataColumn(label: Text('Harga')),
              ],
              rows: transactionItems.map((value) {
                index++;

                return DataRow(
                  cells: [
                    DataCell(Text(index.toString())),
                    DataCell(Text(value.productName)),
                    DataCell(Text(value.kode)),
                    DataCell(Text('Rp ${value.price}')),
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
