import 'package:flutter/material.dart';
import 'package:kasir_app/models/ProductModel.dart';
import 'package:kasir_app/services/auth_service.dart';
import 'package:kasir_app/services/kasir_service.dart';

class KasirDashboard extends StatefulWidget {
  @override
  State<KasirDashboard> createState() => _KasirDashboardState();
}

class _KasirDashboardState extends State<KasirDashboard> {
  final AuthService authService = AuthService();
  late Future<List<ProductModel>> products;
  List<Map<String, dynamic>> cart = [];
  double totalHarga = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    products = KasirService().getAllProducts(); // Fetch data produk dari API
  }

  void logout(BuildContext context) async {
    await authService.logout();
    Navigator.pushReplacementNamed(context, "/");
  }

  void reloadProduct() {
    setState(() {
      products = KasirService().getAllProducts();
    });
  }

  void tambahKeranjang(String produk, double harga) {
    setState(() {
      cart.add({
        "produk": produk,
        "harga": harga,
      });

      totalHarga += harga;
    });
  }

  void checkOut() {
    // Arahkan ke halaman checkout
    Navigator.pushNamed(
      context,
      "/checkout",
      arguments: {
        'cart': cart,
        'totalHarga': totalHarga,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Kasir"),
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: const Icon(Icons.logout),
          ),
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

            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 produk per baris
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemBuilder: (context, index) {
                      if (index >= snapshot.data!.length) {
                        return SizedBox.shrink();
                      }
                      String produk = snapshot.data![index].name;
                      double harga = snapshot.data![index].price.toDouble();
                      return Card(
                        child: Column(
                          children: [
                            const Expanded(
                              child: Icon(
                                Icons.shopping_bag,
                                size: 50,
                              ),
                            ),
                            Text(produk),
                            Text("Rp ${harga.toStringAsFixed(0)}"),
                            ElevatedButton(
                                onPressed: () {
                                  // Tambahkan keranjang
                                  tambahKeranjang(produk, harga);
                                },
                                child: const Text("Tambah"))
                          ],
                        ),
                      );
                    },
                    itemCount: snapshot.data!.length, // jumlah produk contoh
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[200],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total: Rp ${totalHarga.toStringAsFixed(0)}",
                        style: const TextStyle(fontSize: 24),
                      ),
                      ElevatedButton(
                        onPressed: cart.isEmpty ? null : checkOut,
                        child: const Text("Checkout"),
                      ),
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }
}
