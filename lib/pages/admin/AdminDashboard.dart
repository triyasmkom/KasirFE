import 'package:flutter/material.dart';
import 'package:kasir_app/pages/admin/pengguna/ManajemenPengguna.dart';
import 'package:kasir_app/pages/admin/produk/ManajemenProduk.dart';
import 'package:kasir_app/pages/admin/transaksi/LaporanTransaksi.dart';
import 'package:kasir_app/services/auth_service.dart';

class AdminDashboard extends StatelessWidget {
  final AuthService authService = AuthService();

  void logout(BuildContext context) async {
    await authService.logout();
    Navigator.pushReplacementNamed(context, "/");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.store),
            title: const Text("Manajemen Produk"),
            onTap: () {
              // arahkan ke halaman manajemen produk
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManajemenProduk(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt),
            title: const Text("Laporan Transaksi"),
            onTap: () {
              // arahkan ke halaman laporan transaksi
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LaporanTransaksi(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Managemen Pengguna"),
            onTap: () {
              // Arahkan ke halaman manajemen pengguna
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManajemenPengguna(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
