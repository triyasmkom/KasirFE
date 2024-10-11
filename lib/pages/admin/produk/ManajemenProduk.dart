import 'package:flutter/material.dart';
import 'package:kasir_app/models/ProductModel.dart';
import 'package:kasir_app/pages/admin/produk/TambahEditProduk.dart';
import 'package:kasir_app/services/admin_service.dart';

class ManajemenProduk extends StatefulWidget {
  const ManajemenProduk({super.key});

  @override
  State<ManajemenProduk> createState() => _ManajemenProdukState();
}

class _ManajemenProdukState extends State<ManajemenProduk> {
  late Future<List<ProductModel>> products;
  void reloadProduct() {
    setState(() {
      products = AdminService().getAllProducts();
    });
  }

  @override
  void initState() {
    super.initState();
    products = AdminService().getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manajemen Produk"),
        actions: [
          IconButton(
            onPressed: () async {
              // Tambah produk baru
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TambahEditProduk(),
                ),
              );

              // Cek jika ada perubahan data
              if (result == true) {
                reloadProduct(); // Memuat ulang data pengguna
              }
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: FutureBuilder<List<ProductModel>>(
          future: products,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              ); // Tampilkan loading
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              ); // Tampilkan error
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('Tidak ada produk ditemukan.'),
              ); // Tampilkan pesan jika tidak ada pengguna
            }

            return ListView.builder(
              itemCount: snapshot.data!.length, // jumlah produk yang ada
              itemBuilder: (context, index) {
                ProductModel product = snapshot.data![index];
                return ListTile(
                  leading: const Icon(Icons.shopping_bag),
                  title: Text(product.name),
                  subtitle:
                      Text("Harga: ${product.price} \nStok : ${product.stock}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () async {
                          // Edit Produk
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TambahEditProduk(
                                isEdit: true,
                                productData: product,
                                productId: product.id.toString(),
                              ),
                            ),
                          );

                          // Cek jika ada perubahan data
                          if (result == true) {
                            reloadProduct(); // Memuat ulang data pengguna
                          }
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
                                  title: const Text("Konfirmasi"),
                                  content: const Text(
                                      "Apakah anda yakin menghapus produk ini?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        // Hapus produk dari daftar
                                        await AdminService()
                                            .deleteProduct(product.id);
                                        reloadProduct();
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
                          icon: const Icon(Icons.delete)),
                    ],
                  ),
                );
              },
            );
          }),
    );
  }
}
