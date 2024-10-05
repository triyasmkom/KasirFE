import 'package:flutter/material.dart';
import 'package:kasir_app/pages/admin/AdminDashboard.dart';
import 'package:kasir_app/pages/kasir/KasirDashboard.dart';
import 'package:kasir_app/pages/LoginScreen.dart';
// import 'package:kasir_app/pages/admin/produk/ManajemenProduk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Kasir',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const LoginScreen(),
        "/kasir": (context) => KasirDashboard(),
        "/admin": (context) => AdminDashboard(),
        // "/manajemenProduk": (context) => const ManajemenProduk(),
      },
    );
  }
}
