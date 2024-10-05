import 'package:flutter/material.dart';
import 'package:kasir_app/pages/admin/transaksi/DetailTransaksi.dart';

class LaporanTransaksi extends StatelessWidget {
  const LaporanTransaksi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan Transaksi"),
      ),
      body: ListView.builder(
        itemCount: 10, // jumlah laporan transaksi
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.receipt),
            title: Text("Transaksi $index"),
            subtitle: Text("Total Rp ${index * 50000}, Kasir: Kasir $index"),
            onTap: () {
              // Tampilan detail transaksi
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailTransaksi(
                    transaksiId: index,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
