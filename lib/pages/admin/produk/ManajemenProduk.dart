import 'package:flutter/material.dart';
import 'package:kasir_app/pages/admin/produk/TambahEditProduk.dart';

class ManajemenProduk extends StatelessWidget {
  const ManajemenProduk({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manajemen Produk"),
        actions: [
          IconButton(
            onPressed: () {
              // Tambah produk baru
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TambahEditProduk(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: 10, // jumlah produk yang ada
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: Text("Produk $index"),
            subtitle: Text("Harga: ${index * 1000}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    // Edit Produk
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TambahEditProduk(isEdit: true),
                      ),
                    );
                  },
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                    onPressed: () {
                      // Hapus Produk
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Konfirmasi"),
                            content:
                                Text("Apakah anda yakin menghapus produk ini?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  // Hapus produk dari daftar
                                },
                                child: Text("Ya"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Tidak"),
                              )
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.delete)),
              ],
            ),
          );
        },
      ),
    );
  }
}
