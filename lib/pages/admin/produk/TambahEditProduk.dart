import 'package:flutter/material.dart';

class TambahEditProduk extends StatelessWidget {
  final bool isEdit;
  TambahEditProduk({
    this.isEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Produk" : "Tambah Produk"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(labelText: "Nama Produk"),
            ),
            const TextField(
              decoration: InputDecoration(labelText: "Harga"),
              keyboardType: TextInputType.number,
            ),
            const TextField(
              decoration: InputDecoration(labelText: "Stok"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Tambahkan atau update produk
              },
              child: Text(isEdit ? "Simpan Perubahan" : "Tambah Produk"),
            ),
          ],
        ),
      ),
    );
  }
}
