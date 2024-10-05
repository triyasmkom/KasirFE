import 'package:flutter/material.dart';
import 'package:kasir_app/services/auth_service.dart';

class KasirDashboard extends StatelessWidget {
  final AuthService authService = AuthService();

  void logout(BuildContext context) async {
    await authService.logout();
    Navigator.pushReplacementNamed(context, "/");
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
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 produk per baris
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    children: [
                      Expanded(
                        child: Icon(
                          Icons.shopping_bag,
                          size: 50,
                        ),
                      ),
                      Text("Produk $index"),
                      ElevatedButton(
                          onPressed: () {
                            // Tambahkan keranjang
                          },
                          child: Text("Tambah"))
                    ],
                  ),
                );
              },
              itemCount: 10, // jumlah produk contoh
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total: Rp 0",
                  style: TextStyle(fontSize: 24),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Checkout"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
