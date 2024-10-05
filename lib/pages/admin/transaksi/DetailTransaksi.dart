import 'package:flutter/material.dart';

class DetailTransaksi extends StatelessWidget {
  final int transaksiId;
  DetailTransaksi({required this.transaksiId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Transaksi $transaksiId"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Produk 1: Rp 20000"),
            Text("Produk 2: Rp 20000"),
            SizedBox(height: 20),
            Text("Kasir: Kasir $transaksiId"),
            Text("Waktu: 2024-10-03 14:00:00"),
          ],
        ),
      ),
    );
  }
}
